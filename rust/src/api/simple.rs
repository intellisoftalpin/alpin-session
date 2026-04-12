//! Flutter ↔ Rust bridge — thin wrappers over libsession.
//!
//! All business logic (crypto, message encode/decode, snode networking, onion
//! routing) lives in `libsession`. This module only shuttles values across
//! the FFI boundary.
//!
//! Networking:
//!
//! * `init_network()` creates a single `libsession::network::Network<HttpTransport>`
//!   and stashes it in an `OnceLock`.
//! * `send_message` encrypts a 1:1 envelope and sends it via onion routing.
//! * `poll_messages` runs a single authenticated retrieve over onion routing
//!   and returns decrypted (sender, body, ts_ms) tuples.
//!
//! Keys:
//!
//! * `generate_keypair` / `keypair_from_seed` — Ed25519 keypairs.
//! * `validate_session_id` / `ed25519_sign` / `ed25519_pubkey_from_secret` —
//!   utility passthroughs.

use std::sync::OnceLock;

use libsession::crypto::curve25519;
use libsession::crypto::ed25519;
use libsession::network::{
    HttpTransport, Network, NetworkConfig, NetworkError,
};
use libsession::network::auth::{current_timestamp_ms, namespace};
use libsession::network::rpc::{RetrieveParams, StoreParams, DEFAULT_MESSAGE_TTL_MS};
use libsession::protocol::protocol::{
    decode_envelope, encode_for_1o1, DecodeEnvelopeKey,
};
use libsession::proto::session_protos;
use libsession::util::types::session_id_is_valid;
use prost::Message as _;
use tokio::runtime::Runtime;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

// ---------------------------------------------------------------------------
// Key utilities (unchanged — thin passthroughs)
// ---------------------------------------------------------------------------

/// Generates a new random Ed25519 keypair.
/// Returns (session_id, secret_key_bytes, seed_hex).
#[flutter_rust_bridge::frb(sync)]
pub fn generate_keypair() -> (String, Vec<u8>, String) {
    let (ed_pk, ed_sk) = ed25519::ed25519_key_pair();
    let x_pk = curve25519::to_curve25519_pubkey(&ed_pk)
        .expect("Ed25519 to X25519 conversion failed");
    let session_id = format!("05{}", hex::encode(x_pk));
    let seed_hex = hex::encode(&ed_sk[..16]);
    (session_id, ed_sk.to_vec(), seed_hex)
}

/// Derives a keypair from a 16-byte seed.
#[flutter_rust_bridge::frb(sync)]
pub fn keypair_from_seed(seed: Vec<u8>) -> (String, Vec<u8>) {
    assert!(seed.len() == 16, "Seed must be exactly 16 bytes");
    let mut padded = [0u8; 32];
    padded[..16].copy_from_slice(&seed);
    let (ed_pk, ed_sk) = ed25519::ed25519_key_pair_from_seed(&padded)
        .expect("Ed25519 keypair derivation failed");
    let x_pk = curve25519::to_curve25519_pubkey(&ed_pk)
        .expect("Ed25519 to X25519 conversion failed");
    let session_id = format!("05{}", hex::encode(x_pk));
    (session_id, ed_sk.to_vec())
}

/// Validates a 66-character hex Session ID.
#[flutter_rust_bridge::frb(sync)]
pub fn validate_session_id(session_id: String) -> bool {
    session_id_is_valid(&session_id)
}

/// Signs a message with an Ed25519 secret key. Returns 64-byte signature as hex.
#[flutter_rust_bridge::frb(sync)]
pub fn ed25519_sign(secret_key: Vec<u8>, message: Vec<u8>) -> String {
    let signature = ed25519::sign(&secret_key, &message)
        .expect("Ed25519 signing failed");
    hex::encode(signature)
}

/// Returns the Ed25519 public key (hex) from a 64-byte secret key.
#[flutter_rust_bridge::frb(sync)]
pub fn ed25519_pubkey_from_secret(secret_key: Vec<u8>) -> String {
    hex::encode(&secret_key[32..64])
}

// ---------------------------------------------------------------------------
// Network orchestrator (wraps libsession::network::Network)
// ---------------------------------------------------------------------------

struct NetHandle {
    rt: Runtime,
    net: Network<HttpTransport>,
}

static NET: OnceLock<NetHandle> = OnceLock::new();

fn net() -> &'static NetHandle {
    NET.get()
        .expect("network not initialised — call init_network() first")
}

/// Initialises the network orchestrator. Must be called once at app start
/// before any `send_message` / `poll_messages` call.
#[flutter_rust_bridge::frb(sync)]
pub fn init_network() -> Result<(), String> {
    if NET.get().is_some() {
        return Ok(());
    }
    let rt = tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .thread_name("libsession-net")
        .build()
        .map_err(|e| format!("tokio: {e}"))?;
    let transport = HttpTransport::new().map_err(|e| format!("transport: {e}"))?;
    let net = Network::new(NetworkConfig::default(), transport);
    let _ = NET.set(NetHandle { rt, net });
    Ok(())
}

/// Sends a 1:1 text message.
///
/// * `sender_ed25519_secret_key` — 64-byte libsodium-style secret key.
/// * `recipient_session_id` — 66-hex-char Session id (`05...`).
/// * `text` — UTF-8 message body.
/// * `timestamp_ms` — message timestamp (usually `now()`).
pub fn send_message(
    sender_ed25519_secret_key: Vec<u8>,
    recipient_session_id: String,
    text: String,
    timestamp_ms: i64,
) -> Result<(), String> {
    let handle = net();

    // 1. Encode the Content → padded → encrypted → envelope → WebSocket
    //    blob, then base64.
    let content = session_protos::Content {
        data_message: Some(session_protos::DataMessage {
            body: Some(text),
            timestamp: Some(timestamp_ms as u64),
            ..Default::default()
        }),
        sig_timestamp: Some(timestamp_ms as u64),
        ..Default::default()
    };
    let content_bytes = content.encode_to_vec();

    let recipient_bytes = hex::decode(&recipient_session_id)
        .map_err(|e| format!("recipient hex: {e}"))?;
    let recipient_arr: [u8; 33] = recipient_bytes
        .as_slice()
        .try_into()
        .map_err(|_| "recipient must be 33 bytes (05 + 32)".to_string())?;

    let ws_blob = encode_for_1o1(
        &content_bytes,
        &sender_ed25519_secret_key,
        timestamp_ms as u64,
        &recipient_arr,
        None,
    )
    .map_err(|e| format!("encode: {e}"))?;

    use base64::Engine;
    let b64 = base64::engine::general_purpose::STANDARD.encode(&ws_blob);

    // 2. Send onion-routed store via libsession Network facade.
    let ts_ms = current_timestamp_ms();
    let params = StoreParams {
        pubkey: &recipient_session_id,
        pubkey_ed25519: None, // unauthenticated store into default namespace
        namespace: namespace::DEFAULT,
        timestamp_ms: ts_ms,
        ttl_ms: DEFAULT_MESSAGE_TTL_MS,
        data_base64: &b64,
        signing_key: None,
    };

    handle
        .rt
        .block_on(async { handle.net.send_store(&params).await })
        .map_err(map_network_err)?;

    Ok(())
}

/// One-shot message poll: runs an authenticated retrieve over onion routing,
/// decrypts every received envelope, and returns
/// `(sender_session_id, body, timestamp_ms, hash)` for each successfully
/// decrypted message.
///
/// * `my_ed25519_secret_key` — 64-byte secret key.
/// * `my_session_id` — the owner's `05...` id.
/// * `last_hash` — the hash of the last retrieved message (from the previous
///   poll); empty string for "fetch everything".
pub fn poll_messages(
    my_ed25519_secret_key: Vec<u8>,
    my_session_id: String,
    last_hash: String,
) -> Result<Vec<PolledMessage>, String> {
    let handle = net();

    let ed_pk_hex = hex::encode(&my_ed25519_secret_key[32..64]);
    let ts_ms = current_timestamp_ms();
    let last_hash_opt = if last_hash.is_empty() {
        None
    } else {
        Some(last_hash.as_str())
    };

    let params = RetrieveParams {
        pubkey: &my_session_id,
        pubkey_ed25519: &ed_pk_hex,
        namespace: namespace::DEFAULT,
        timestamp_ms: ts_ms,
        last_hash: last_hash_opt,
        max_size: None,
        signing_key: &my_ed25519_secret_key,
    };

    let resp = handle
        .rt
        .block_on(async { handle.net.send_retrieve(&params).await })
        .map_err(map_network_err)?;

    // The onion response `body` is a JSON string with a `messages` array.
    let body_str = resp.body.as_deref().unwrap_or("");
    let json: serde_json::Value =
        serde_json::from_str(body_str).map_err(|e| format!("resp json: {e}"))?;
    let messages = json
        .get("messages")
        .and_then(|m| m.as_array())
        .cloned()
        .unwrap_or_default();

    let sk_slice: &[u8] = &my_ed25519_secret_key;
    let decrypt_keys: [&[u8]; 1] = [sk_slice];
    let decode_key = DecodeEnvelopeKey {
        group_ed25519_pubkey: None,
        decrypt_keys: &decrypt_keys,
    };

    let mut out = Vec::with_capacity(messages.len());
    let pro_backend_pk = [0u8; 32];

    for m in messages {
        let hash = m
            .get("hash")
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let data_b64 = match m.get("data").and_then(|v| v.as_str()) {
            Some(s) => s,
            None => continue,
        };

        use base64::Engine;
        let bytes = match base64::engine::general_purpose::STANDARD.decode(data_b64) {
            Ok(b) => b,
            Err(_) => continue,
        };

        let decoded = match decode_envelope(&decode_key, &bytes, &pro_backend_pk) {
            Ok(d) => d,
            Err(_) => continue,
        };

        // Parse Content from the decrypted plaintext to extract the visible
        // body + timestamp.
        let content = match session_protos::Content::decode(decoded.content_plaintext.as_slice())
        {
            Ok(c) => c,
            Err(_) => continue,
        };

        let dm = match content.data_message {
            Some(d) => d,
            None => continue,
        };
        let body = dm.body.unwrap_or_default();
        if body.is_empty() {
            continue;
        }
        let ts = content
            .sig_timestamp
            .or(dm.timestamp)
            .unwrap_or(decoded.envelope.timestamp) as i64;

        // Reconstruct sender session id (05 + sender x25519 hex).
        let sender = format!("05{}", hex::encode(decoded.sender_x25519_pubkey));

        out.push(PolledMessage {
            hash,
            sender_session_id: sender,
            body,
            timestamp_ms: ts,
        });
    }

    Ok(out)
}

/// One decrypted inbound message, returned by [`poll_messages`].
#[derive(Debug, Clone)]
pub struct PolledMessage {
    /// Snode-assigned message hash (used for `last_hash` on the next poll).
    pub hash: String,
    /// Sender's Session id (`05...`).
    pub sender_session_id: String,
    /// Plaintext UTF-8 body.
    pub body: String,
    /// Timestamp in milliseconds (from the envelope or content).
    pub timestamp_ms: i64,
}

fn map_network_err(e: NetworkError) -> String {
    format!("network: {e}")
}

/// Returns the libsession crate version.
#[flutter_rust_bridge::frb(sync)]
pub fn lib_version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}
