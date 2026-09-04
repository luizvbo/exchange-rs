# Exchange-rs

Exchange-rs is a command-line application written in Rust. It fetches real-time
trading data from multiple exchanges and outputs it in a customizable format.
This can be particularly useful for financial analysis, algorithmic trading,
and other applications that require real-time stock market data.

## Repository

The source code for Exchange-rs is hosted on GitHub. You can clone or fork the
repository from the following URL:

https://github.com/luizvbo/exchange-rs

## Installation

### From crates.io

If you have [Rust](https://rustup.rs/) installed, the simplest way to install
Exchange-rs is via Cargo:

```bash
cargo install exchange-rs
```

### From pre-built binaries (Linux, macOS, Windows)

You can install a pre-built binary without needing Rust installed:

```bash
curl -sSfL https://raw.githubusercontent.com/luizvbo/exchange-rs/main/install.sh | sh
```

To install a specific version:

```bash
curl -sSfL https://raw.githubusercontent.com/luizvbo/exchange-rs/main/install.sh | sh -s -- --version 0.2.0
```

Alternatively, download the archive for your platform directly from the
[releases page](https://github.com/luizvbo/exchange-rs/releases), extract it,
and place the binary in your `PATH`.

### From source

To build from source, you need [Rust](https://rustup.rs/) installed:

1. Clone the repository:

```bash
git clone https://github.com/luizvbo/exchange-rs.git
```

2. Navigate into the cloned repository:

```bash
cd exchange-rs
```

3. Build the application:

```bash
cargo build --release
```

The executable will be located in the target/release directory.

## Usage

You can run Exchange-rs from the terminal with the following command:

```bash
./target/release/exchange-rs <ISIN> [<FORMAT>]
```

### Arguments

- **ISIN**: The ISIN of the instrument to fetch data for. This is required and
should follow the format `{ISIN}-XAMS` (e.g., `IE00B4L5Y983-XAMS`).

- **FORMAT** (optional): A custom output format string that defines how the
data is displayed. The default format is: `"%p | Open: %o (%O) | Close: %c
(%C)"`

You can use the following placeholders in the format string:

- `%p`: The price.
- `%o`: The value since open.
- `%O`: The percentage change since open.
- `%c`: The value since close.
- `%C`: The percentage change since close.

For example, to customize the output to show only the price and open
percentage, you can use the following format:

```bash
./target/release/exchange-rs IE00B4L5Y983-XAMS "%p - %O"
```

### Example

```bash
./target/release/exchange-rs IE00B4L5Y983-XAMS
```

This will fetch the data for the instrument with the specified ISIN and print
it in the default format.

For example, the output could look like:

```
123.45 | Open: 120.00 (2.5%) | Close: 121.00 (1.9%)
```

#### Custom Format Example

```bash
./target/release/exchange-rs IE00B4L5Y983-XAMS "%p | Open: %o | Change: %O"
```

This will print something like:

```
123.45 | Open: 120.00 | Change: 2.5%
```

## Contributing

Contributions to Exchange-rs are welcome! Please feel free to open an issue or
submit a pull request on GitHub.

## Releasing

Releases are automated using [release-plz](https://release-plz.dev/) for
crates.io publishing and changelog generation, plus a hand-rolled GitHub Actions
workflow for pre-built binaries.

### Prerequisites

- Use [conventional commit](https://www.conventionalcommits.org/) messages when
  pushing to `main`:
  - `feat:` — new feature (triggers a minor version bump)
  - `fix:` — bug fix (triggers a patch version bump)
  - `feat!:` — breaking change (triggers a major version bump)
  - `chore:`, `docs:`, `ci:` — no release (ignored by release-plz)

### Creating a release

1. **Push your changes to `main`** using conventional commit messages.

2. **release-plz opens a draft release PR** automatically. It contains the
   version bump in `Cargo.toml` and an auto-generated `CHANGELOG.md`.

3. **Review and merge the release PR.** Edit the changelog in the PR if you
   want to adjust the release notes before merging.

4. **release-plz publishes to crates.io** and creates a git tag (e.g.,
   `v0.2.0`) and a GitHub Release with the changelog notes.

5. **The tag push triggers the binary build workflow**, which builds
   pre-built binaries for Linux, macOS, and Windows and uploads them to the
   GitHub Release.

### Previewing a release locally

```bash
just release-preview    # see what version bump + changelog release-plz would produce
just release-check      # dry-run the release command
just publish-dry-run    # verify the package is valid for crates.io
```

