# dotfiles

Managed via [chezmoi](https://www.chezmoi.io/).

### On a new machine

1. Clone this repo.
2. Run:

```console
cd dotfiles
./bootstrap.sh
```

3. Download shell history:

```console
atuin login -u <USERNAME>
atuin sync
```
