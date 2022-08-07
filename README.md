# Rust Toolchain Installer

Downloads and installs the Rust Toolchain in the current container and makes it available to the next steps.

### Useful links 

* [Rust Toolchain Installer](https://rustup.rs/)
* [Installation tips from 'The rustup book'](https://rust-lang.github.io/rustup/installation/index.html)


-----

## ⚙️ Configuration

<details>
<summary>Inputs</summary>

| Input Key | Description | Values | Default |
| --- | --- | --- | --- |
| `use_rustup_nightly` | If `true`, makes the Rust Nightly Toolchain as default toolchain. | `true`, `false` | `false` |
| `auto_update_toolchain` | If `true`, auto updates the Rust Toolchain on every run.  | `true`, `false` | `false` |
| `cache_level` | If set to `all`, appends the `cargo` and `rustup` main folders to Bitrise `$BITRISE_CACHE_INCLUDE_PATHS` env var that will be picked up by the `Cache:Push` step later on (if present). This speeds up the entire step quite a lot after the first invocation. | `all`, `none` | `none` |
| `show_exported_envs` | If `true`, shows the exported envs with the `rustc`, `cargo` and `rustup` versions at the end of the step. | `true`, `false` | `false` |
</details>

<details>
<summary>Outputs</summary>

| Environment Variable | Description |
| --- | --- |
| `RUSTUP_VERSION` | This output will include the `rustup` version (from `rustup -V`). |
| `RUSTC_VERSION`| This output will include the `rustc` version (from `rustc -V`). |
| `CARGO_VERSION` | This output will include the `cargo` version (from `cargo -V`). |
</details>

-----
## 🙋 Contributing

[Pull Requests](https://github.com/nick0602/bitrise-step-rustup/pulls) and [Issues](https://github.com/nick0602/bitrise-step-rustup/issues) are welcome against this repository.

For pull requests, work on your changes in a forked repository and use the Bitrise CLI to [run step tests locally](https://devcenter.bitrise.io/bitrise-cli/run-your-first-build/).

Learn more about developing steps:

- [Create your own step](https://devcenter.bitrise.io/contributors/create-your-own-step/)
- [Testing your Step](https://devcenter.bitrise.io/contributors/testing-and-versioning-your-steps/)
