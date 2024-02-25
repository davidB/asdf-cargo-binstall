<div align="center">

# asdf-cargo-binstall [![Build](https://github.com/davidB/asdf-cargo-binstall/actions/workflows/build.yml/badge.svg)](https://github.com/davidB/asdf-cargo-binstall/actions/workflows/build.yml) [![Lint](https://github.com/davidB/asdf-cargo-binstall/actions/workflows/lint.yml/badge.svg)](https://github.com/davidB/asdf-cargo-binstall/actions/workflows/lint.yml)

[cargo-binstall](https://github.com/cargo-bins/cargo-binstall) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-cargo-binstall  ](#asdf-cargo-binstall--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar` (linux) or `zip` (apple), and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `CARGO_HOME`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add cargo-binstall
# or
asdf plugin add cargo-binstall https://github.com/davidB/asdf-cargo-binstall.git
```

cargo-binstall:

```shell
# Show all installable versions
asdf list-all cargo-binstall

# Install specific version
asdf install cargo-binstall latest

# Set a version globally (on your ~/.tool-versions file)
asdf global cargo-binstall latest

# Now cargo-binstall commands are available
cargo-binstall -V
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/davidB/asdf-cargo-binstall/graphs/contributors)!

# License

See [LICENSE](LICENSE)
