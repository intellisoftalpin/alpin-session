# Alpin Session

An **alternative, third-party client** for the [Session](https://getsession.org)
messaging network — written in Flutter, with all crypto and networking
delegated to a Rust core (`libsession`) to minimise trusted surface and keep
behaviour identical across platforms.

> ⚠️ **Not affiliated with the Session Foundation or Oxen Labs.** Alpin
> Session is an independent implementation that speaks to the same public
> Session service-node network. The reference apps live at
> [session-android](https://github.com/session-foundation/session-android) and
> [session-ios](https://github.com/session-foundation/session-ios).
>
> Alpin Session is pre-1.0 and should not be relied on as your only Session
> client while under active development.

---

## Status

| Feature | Status |
|---|---|
| Account create / restore (13-word mnemonic) | ✅ |
| 1-to-1 messaging (send / receive, onion-routed) | ✅ |
| Onion-routed snode RPCs (no direct IP leak) | ✅ |
| Local database encryption (SQLCipher) | ✅ |
| Group messaging | 🚧 planned |
| Communities / open groups | 🚧 planned |
| Attachments | 🚧 planned |
| Voice / video calls | ❌ not planned |
| Session Pro | ❌ not planned |

## Design principles

- **Privacy first.** Every decision gets evaluated for privacy impact before
  shipping. No analytics, no crash reporting, no Firebase, no runtime font
  downloads — everything bundled locally.
- **Business logic stays in Rust.** Dart is UI and local-state plumbing only.
  The moment crypto, protocol parsing, or network routing touches Dart, it's
  a bug. This lets us rely on `libsession`'s test suite (400+ unit tests) for
  correctness instead of reviewing the same logic in two languages.
- **Parity with upstream Session, not with upstream apps.** Wire formats,
  encryption, onion routing, seed CA pinning, swarm lookup — all match the
  official clients byte-for-byte. The UI is our own.
- **No web build.** Only iOS, Android, Windows, macOS, Linux. Session's
  threat model doesn't suit browser-hosted key material.

## Architecture

```
┌─────────────────────────── Dart ────────────────────────────┐
│  Poller (Timer) ──→ rust.pollMessages()                     │
│  ConversationBloc ──→ rust.sendMessage(recipient, body)     │
│  Home / chat screens ──→ stream from drift DB (unchanged)   │
└─────────────────────────────┬───────────────────────────────┘
                              │ flutter_rust_bridge 2.12
┌─────────────────────────────▼───────────────────────────────┐
│                Rust (libsession 0.1.8+)                     │
│                                                             │
│   api/simple.rs — thin FFI wrappers                         │
│        │                                                    │
│   protocol::encode_for_1o1 / decode_envelope                │
│        │                                                    │
│   network::Network::send_rpc                                │
│        ├── SnodePool (bootstrap + refresh + strikes)        │
│        ├── PathManager (3-hop path pool, rotation)          │
│        ├── OnionRequestRouter (build + send + decrypt)      │
│        ├── HttpTransport (rustls + pinned seed CAs)         │
│        └── swarm::fetch_swarm_via_onion                     │
└─────────────────────────────────────────────────────────────┘
```

### Components

| Layer | Responsibility |
|---|---|
| `lib/src/features/*` | UI screens, BLoCs, routing (GoRouter). |
| `lib/src/services/*` | Thin orchestration: `MessageService`, `KeyService`, `SessionService`. |
| `lib/src/core/storage` | Drift + SQLCipher schema for `threads` and `messages`. |
| `rust/src/api/simple.rs` | FFI surface: keypair, sign, encrypt, send, poll. |
| `libsession` (crates.io) | Crypto, protocol, network orchestrator. Separate repo: [libsession-rust](https://github.com/intellisoftalpin/libsession-rust). |

## Privacy properties

Every outbound snode RPC — send, retrieve, swarm lookup, path rotation — is
onion-wrapped to a random guard snode. The guard sees your IP but only an
encrypted blob; the exit snode sees the recipient pubkey but not your IP.
No snode ever sees both.

The Rust transport uses rustls with a bundled Mozilla root CA set
(`webpki-roots`) for general HTTPS, plus three pinned CA certs for the
Session seed nodes — matching what Android does via
`network_security_configuration.xml`. This means TLS behaviour is identical
on iOS, Android, and desktop, and does not depend on any OS trust store.

## Getting started

### Prerequisites

- Flutter 3.x (check `.fvmrc` for exact version if you use fvm)
- Rust toolchain (1.93+) — `rustup default stable`
- Platform tools: Xcode (iOS/macOS), Android SDK + NDK (Android),
  cmake + pkg-config (Linux), Visual Studio (Windows)

### Build

```bash
flutter pub get
flutter run                         # or target a specific device
```

The Rust core is built automatically through
[cargokit](https://github.com/irondash/cargokit) — no manual `cargo build`
required.

### Development

If you change the Rust FFI surface (`rust/src/api/*.rs`), regenerate the
Dart bindings:

```bash
./scripts/regen_bridge.sh
```

That script runs `flutter_rust_bridge_codegen generate`, `cargo check` on
the bridge crate, and `flutter analyze` — fails fast on any step.

## Project layout

```
session-app/
├── lib/                      # Dart UI + services
│   ├── src/
│   │   ├── core/            # DI, router, storage, theme
│   │   ├── features/        # Screens + BLoCs (auth, conversation, home, …)
│   │   ├── services/        # MessageService, KeyService, SessionService
│   │   └── rust/            # ← generated Dart bindings (do not edit)
│   └── main.dart
├── rust/                     # flutter_rust_bridge crate — thin libsession wrapper
│   ├── src/api/simple.rs
│   └── Cargo.toml
├── scripts/
│   └── regen_bridge.sh      # regenerate FFI bindings
└── flutter_rust_bridge.yaml
```

## License

**GPL-3.0-only.** See [`LICENSE`](LICENSE) for the full text.

This is required, not chosen: Alpin Session links to `libsession`
(GPL-3.0-only), and the upstream reference clients — `session-android`,
`session-ios`, and Oxen Labs' `libsession-util` — are all GPL-3.0. Any
distributed binary combining these must inherit GPL-3.0.

## Acknowledgements

- [Session](https://getsession.org) and the Session Foundation — protocol,
  reference implementations, snode infrastructure.
- [Oxen Labs](https://oxen.io) — `libsession-util` (the C++ library Alpin's
  Rust port is reverse-engineered from).
- [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/) — the
  FFI layer that makes this architecture possible.
