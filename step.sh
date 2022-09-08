#!/bin/bash
set -e

# Load input values that have been passed by Bitrise.
source "${BITRISE_STEP_SOURCE_DIR}"/inputs.sh

# Load required functions in scope to keep step.sh clean.
source "${BITRISE_STEP_SOURCE_DIR}"/helpers.sh

# Silently source, in case the cache has already restored rustup and/or cargo folders.
CARGO_ENV=${HOME}/.cargo/env

if [[ -e $CARGO_ENV ]]; then 
    # shellcheck source=/dev/null
    source "${CARGO_ENV}"
fi

# Keep track if it's first install to skip updates after the setup.
IS_FIRST_INSTALL=false

# Check if rustup is installed.
if ! command -v rustup &>/dev/null; then
    IS_FIRST_INSTALL=true

    printf 'No Rust Toolchain found\n\n'
    install_rustup
fi

# Export PATH via envman to make the toolchain available for the next steps.
envman add --key "PATH" --value "${PATH}:${HOME}/.cargo/bin"

# Calling set_default_rustup() to ensure the required version of rustc is used, as ~/.rustup/settings.toml might have been restored from cache.
set_default_rustup

# Update is not performed on first install as the download has just happened.
if [ "${RUST_AUTO_UPDATE_TOOLCHAIN}" = true ] && [ "${IS_FIRST_INSTALL}" = false ]; then
    update_rustup
fi

# Use envman to add versions as ENV.
export_rust_envs

# Append local cargo and rustup path to the local Bitrise cache if necessary.
append_to_bitrise_cache

# Show current versions.
if [ "${RUST_SHOW_ENVS}" = true ]; then
    print_rust_envs
fi

exit $?
