#!/bin/bash
set -e

install_rustup_standard() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y
}

install_rustup_nightly() {
    install_rustup_standard
    rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
}

set_default_rustup() {
    if [ "$RUST_USE_RUSTUP_NIGHTLY" = true ]; then
        rustup default nightly
    else 
        rustup default stable
    fi
}

# Silently source, in case the cache has already restored rustup and/or cargo folders.
source "$HOME/.cargo/env" &> /dev/null || true

if ! command -v rustup &> /dev/null && [ "$RUST_USE_RUSTUP_NIGHTLY" = false ]; then
    printf 'No Rust Toolchain found, installing latest stable...\n'
    install_rustup_standard
elif [ "$RUST_USE_RUSTUP_NIGHTLY" = true ]; then
    printf 'Nightly Toolchain required, installing...\n'
    install_rustup_nightly
elif [ "$RUST_AUTO_UPDATE_TOOLCHAIN" = true ]; then
    printf 'Toolchain auto-update enabled, running installation script again...\n'
    install_rustup_standard
fi

# Calling set_default_rustup() to ensure the required version of rustc is used, as ~/.rustup/settings.toml might have been restored from cache.
set_default_rustup

# Export PATH via envman to make the toolchain available for the next steps.
envman add --key "PATH" --value "${PATH}:$HOME/.cargo/bin"

# Use envman to add versions as ENV
envman run rustup -V | envman add --key CURRENT_RUSTUP_VERSION
envman run rustc -V | envman add --key CURRENT_RUSTC_VERSION
envman run cargo -V | envman add --key CURRENT_CARGO_VERSION

# Show current versions
printf "\n\nExported ENV vars:\n"
envman run bash -c 'printf "CURRENT_RUSTUP_VERSION: $CURRENT_RUSTUP_VERSION"'
envman run bash -c 'printf "CURRENT_RUSTC_VERSION: $CURRENT_RUSTC_VERSION"'
envman run bash -c 'printf "CURRENT_CARGO_VERSION: $CURRENT_CARGO_VERSION"'

exit $?
