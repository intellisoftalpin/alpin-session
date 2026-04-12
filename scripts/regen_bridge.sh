#!/usr/bin/env bash
# Regenerates the flutter_rust_bridge Dart bindings from the Rust API.
#
# Run this whenever you change public (`pub`) functions, structs, or enums
# in `rust/src/api/*.rs`. After it finishes, the generated Dart files under
# `lib/src/rust/` are up to date and `flutter analyze` should be clean.
#
# Usage:  ./scripts/regen_bridge.sh
#
# Reads flutter_rust_bridge.yaml for rust_input / rust_root / dart_output.

set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v flutter_rust_bridge_codegen >/dev/null 2>&1; then
  echo "error: flutter_rust_bridge_codegen not on PATH" >&2
  echo "  install:  cargo install flutter_rust_bridge_codegen --version 2.12.0 --locked" >&2
  exit 1
fi

echo "==> regenerating Dart bindings from rust/src/api"
flutter_rust_bridge_codegen generate

echo "==> cargo check (bridge crate)"
(cd rust && cargo check --lib)

echo "==> flutter analyze"
flutter analyze

echo "done."
