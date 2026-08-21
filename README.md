# asdf-sops

[![CI](https://github.com/feniix/asdf-sops/actions/workflows/ci.yml/badge.svg)](https://github.com/feniix/asdf-sops/actions/workflows/ci.yml)

[SOPS](https://github.com/getsops/sops) plugin for the
[asdf](https://asdf-vm.com/) version manager.

## Install

```bash
asdf plugin add sops https://github.com/feniix/asdf-sops.git
```

## Use

```bash
asdf list all sops
asdf install sops latest
asdf set -u sops latest
sops --version
```

See the [asdf documentation](https://asdf-vm.com/manage/versions.html) for
version-management commands.

## Supported platforms

CI exercises the plugin on current Ubuntu and macOS runners. SOPS release
availability determines the supported operating-system and CPU combinations.

## License

MIT. See [LICENSE](LICENSE).
