#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_ASK=0

echo "==> Checking Homebrew toolchain for Tiny11 Builder for Mac..."
if ! command -v brew >/dev/null 2>&1; then
    echo "Error: Homebrew is required on the developer machine to fetch build dependencies." >&2
    exit 1
fi

FORMULAE=(wimlib cdrtools hivex)
MISSING=()
for pkg in "${FORMULAE[@]}"; do
    if ! brew list --versions "$pkg" >/dev/null 2>&1; then
        MISSING+=("$pkg")
    fi
done

if [ "${#MISSING[@]}" -gt 0 ]; then
    echo "==> Installing missing formulae: ${MISSING[*]}"
    brew install "${MISSING[@]}"
else
    echo "==> All required formulae (${FORMULAE[*]}) are already installed."
fi

echo "==> Verifying binaries and libraries:"
echo "  wimlib-imagex : $(command -v wimlib-imagex)"
echo "  mkisofs       : $(command -v mkisofs)"
echo "  hivex.h       : $(brew --prefix hivex)/include/hivex.h"
echo "  libhivex      : $(brew --prefix hivex)/lib/libhivex.0.dylib"
