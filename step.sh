#!/bin/bash
set -e

install_rustup_standard() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y
}

install_rustup_nightly() {
    install_rustup_standard
    rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
}

if ! command -v rustup &> /dev/null && [ "$INSTALL_RUST_NIGHTLY" = false ]; then
    printf 'No Rust Toolchain found, installing latest stable...\n'
    install_rustup_standard
elif [ "$INSTALL_RUST_NIGHTLY" = true ]; then
    printf 'Nightly Toolchain required, installing...\n'
    install_rustup_nightly
elif [ "$RUST_AUTO_UPDATE_TOOLCHAIN" = true ]; then
    printf 'Toolchain auto-update enabled, running installation script again...\n'
    install_rustup_standard
else 
    printf 'Rust toolchain already installed, skipping...\n'
fi

source "$HOME/.cargo/env"

# Use envman to add versions as ENV
rustup -V | envman add --key CURRENT_RUSTUP_VERSION
rustc -V | envman add --key CURRENT_RUSTC_VERSION
cargo -V | envman add --key CURRENT_CARGO_VERSION

# Show current versions
printf "\n\nExported ENV vars:\n"
envman run bash -c 'printf "CURRENT_RUSTUP_VERSION: $CURRENT_RUSTUP_VERSION"'
envman run bash -c 'printf "CURRENT_RUSTC_VERSION: $CURRENT_RUSTC_VERSION"'
envman run bash -c 'printf "CURRENT_CARGO_VERSION: $CURRENT_CARGO_VERSION"'

exit $?
