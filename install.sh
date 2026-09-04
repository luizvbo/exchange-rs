#!/bin/sh
# Install exchange-rs from GitHub Release binaries.
# Usage: curl -sSfL https://raw.githubusercontent.com/luizvbo/exchange-rs/main/install.sh | sh
#
# Or to install a specific version:
#   curl -sSfL https://raw.githubusercontent.com/luizvbo/exchange-rs/main/install.sh | sh -s -- --version 0.2.0

set -eu

REPO="luizvbo/exchange-rs"
BINARY_NAME="exchange-rs"

VERSION=""
INSTALL_DIR="${CARGO_HOME:-$HOME/.cargo}/bin"

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: curl -sSfL https://raw.githubusercontent.com/luizvbo/exchange-rs/main/install.sh | sh"
            echo "       curl -sSfL https://raw.githubusercontent.com/luizvbo/exchange-rs/main/install.sh | sh -s -- --version 0.2.0"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

# Detect platform
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Linux*)  OS=unknown-linux-gnu ;;
    Darwin*) OS=apple-darwin ;;
    MINGW*|MSYS*|CYGWIN*|Windows*) OS=pc-windows-msvc ;;
    *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

case "$ARCH" in
    x86_64|amd64)  ARCH=x86_64 ;;
    arm64|aarch64) ARCH=aarch64 ;;
    *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

TARGET="${ARCH}-${OS}"

# Determine archive extension
if [ "$OS" = "pc-windows-msvc" ]; then
    EXT="zip"
    BINARY_NAME="exchange-rs.exe"
else
    EXT="tar.gz"
fi

# Resolve version
if [ -z "$VERSION" ]; then
    echo "Fetching latest release version..."
    VERSION=$(curl -sSfL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    if [ -z "$VERSION" ]; then
        echo "Failed to determine latest version" >&2
        exit 1
    fi
fi

echo "Installing ${BINARY_NAME} v${VERSION} for ${TARGET}..."

ARCHIVE="${BINARY_NAME}-${VERSION}-${TARGET}.${EXT}"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ARCHIVE}"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading ${URL}..."
curl -sSfL "$URL" -o "${TMPDIR}/${ARCHIVE}"

mkdir -p "$INSTALL_DIR"

if [ "$EXT" = "zip" ]; then
    if ! command -v unzip >/dev/null 2>&1; then
        echo "unzip is required but not installed" >&2
        exit 1
    fi
    unzip -o "${TMPDIR}/${ARCHIVE}" -d "${TMPDIR}/extracted"
    mv "${TMPDIR}/extracted/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
    tar -xzf "${TMPDIR}/${ARCHIVE}" -C "${TMPDIR}/extracted" 2>/dev/null || {
        mkdir -p "${TMPDIR}/extracted"
        tar -xzf "${TMPDIR}/${ARCHIVE}" -C "${TMPDIR}/extracted"
    }
    mv "${TMPDIR}/extracted/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

echo ""
echo "Installed ${BINARY_NAME} v${VERSION} to ${INSTALL_DIR}/${BINARY_NAME}"
echo ""
echo "Make sure ${INSTALL_DIR} is in your PATH."
echo "Run '${BINARY_NAME} --help' to get started."
