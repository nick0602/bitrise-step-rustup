#!/bin/bash

# This file contains the main bash functions used in step.sh.

install_rustup() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "${RUST_VERSION}"
}

update_rustup() {
    # Remove rustfmt + cargo-fmt if necessary, as they need to be handled by rustup and not cargo itself.
    # See more at: https://github.com/rust-lang/rustup/issues/1352
    rm -rf ~/.cargo/bin/rustfmt
    rm -rf ~/.cargo/bin/cargo-fmt

    envman run rustup update "${RUST_VERSION}"
}

set_default_rustup() {
    envman run rustup default "${RUST_VERSION}"
}

export_rust_envs() {
    envman run rustup -V | envman add --key "RUSTUP_VERSION"
    envman run rustc -V | envman add --key "RUSTC_VERSION"
    envman run cargo -V | envman add --key "CARGO_VERSION"
}

print_rust_envs() {
    printf "\n\nExported ENV vars:\n"
    envman run bash -c 'printf "RUSTUP_VERSION: ${RUSTUP_VERSION}"'
    envman run bash -c 'printf "RUSTC_VERSION: ${RUSTC_VERSION}"'
    envman run bash -c 'printf "CARGO_VERSION: ${CARGO_VERSION}"'
}

# Don't forget that $BITRISE_CACHE_INCLUDE_PATHS separates paths with `\n`.
append_to_bitrise_cache() {
    ADDITIONAL_CACHE_PATHS=$'\n'

    case $RUST_CACHE_LEVEL in
    'all')
        printf "\n\nAdding ~/.rustup, ~/.cargo/bin and ~/.cargo/env to \$BITRISE_CACHE_INCLUDE_PATHS.\n"
        
        ADDITIONAL_CACHE_PATHS+="${HOME}/.rustup"
        ADDITIONAL_CACHE_PATHS+=$'\n'
        ADDITIONAL_CACHE_PATHS+="${HOME}/.cargo/bin"
        ADDITIONAL_CACHE_PATHS+=$'\n'
        ADDITIONAL_CACHE_PATHS+="${HOME}/.cargo/env"

        envman add --key "BITRISE_CACHE_INCLUDE_PATHS" --value "${BITRISE_CACHE_INCLUDE_PATHS}${ADDITIONAL_CACHE_PATHS}"
        ;;
    'none')
        # Nothing to do.
        ;;
    esac
}
