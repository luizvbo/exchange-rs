# Justfile for exchange-rs development tasks

# Default: show available recipes
default:
    @just --list

# Build the release binary
build:
    cargo build --release

# Run tests
test:
    cargo test --workspace --all-features

# Run clippy
lint:
    cargo clippy -- -D warnings

# Format check
fmt-check:
    cargo fmt --all -- --check

# Format
fmt:
    cargo fmt --all

# Dry-run crates.io publish (verifies package without uploading)
publish-dry-run:
    cargo publish --dry-run

# First-time publish to crates.io (must be done manually before release-plz can automate)
# Requires CARGO_REGISTRY_TOKEN env var or ~/.cargo/credentials.toml
publish-first:
    cargo publish

# Preview what release-plz would do (bump versions + changelog locally without committing)
release-preview:
    release-plz update

# Check what release-plz would release (dry-run)
release-check:
    release-plz release --dry-run
