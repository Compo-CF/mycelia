#!/usr/bin/env bash
# Bootstrap the Mycelia Xcode project on MacInCloud (or any macOS dev box).
#
# Per the memory note on MacInCloud: xcodegen is NOT pre-installed and Homebrew
# hits permissions errors in RDP sessions. Install as a standalone binary in
# ~/bin and persist the PATH via ~/.zshrc.
#
# Usage:
#   chmod +x scripts/bootstrap.sh
#   ./scripts/bootstrap.sh

set -euo pipefail

XCODEGEN_VERSION="2.42.0"
BIN_DIR="$HOME/bin"

mkdir -p "$BIN_DIR"

if [ ! -x "$BIN_DIR/xcodegen" ]; then
  echo "→ installing xcodegen $XCODEGEN_VERSION to $BIN_DIR"
  TMPDIR=$(mktemp -d)
  curl -sL "https://github.com/yonaskolb/XcodeGen/releases/download/$XCODEGEN_VERSION/xcodegen.zip" -o "$TMPDIR/xcodegen.zip"
  unzip -q "$TMPDIR/xcodegen.zip" -d "$TMPDIR"
  cp "$TMPDIR/xcodegen/bin/xcodegen" "$BIN_DIR/xcodegen"
  chmod +x "$BIN_DIR/xcodegen"
  cp -R "$TMPDIR/xcodegen/share" "$BIN_DIR/../share" 2>/dev/null || true
  rm -rf "$TMPDIR"
fi

if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
  echo "→ added ~/bin to PATH in ~/.zshrc"
fi

export PATH="$HOME/bin:$PATH"

echo "→ generating Mycelia.xcodeproj"
xcodegen generate

echo
echo "Done. Open Mycelia.xcodeproj in Xcode and build."
