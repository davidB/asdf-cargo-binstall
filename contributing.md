# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test cargo-binstall https://github.com/davidB/asdf-cargo-binstall.git "cargo-binstall -V"
```

Tests are automatically run in GitHub Actions on push and PR.
