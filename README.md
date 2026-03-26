# linux-config

Personal dotfiles and shell/editor configuration for Linux, kept under `~/.config` (XDG config home).

## Contents

| Path                 | Purpose                                      |
| -------------------- | -------------------------------------------- |
| `zsh/.zshrc`         | Zsh startup — link to `~/.zshrc` (see below) |
| `omp/.conf.omp.toml` | [Oh My Posh](https://ohmyposh.dev/) theme    |
| `nvim/`              | Neovim config (LazyVim-style layout)         |
| `.fi.sh`             | Arch Linux fast-install bootstrap (optional) |
| `.fi.temp.sh`       | Second phase: install Node via fnm (zsh)     |

## Using this repo manually

Clone into `~/.config` (or symlink individual paths). For Zsh, the install script links `~/.zshrc` → `~/.config/zsh/.zshrc`; you can do the same:

```bash
ln -sf ~/.config/zsh/.zshrc ~/.zshrc
```

Ensure [Oh My Posh](https://ohmyposh.dev/) is installed and that your `~/.zshrc` references the theme path under this repo.

## Arch bootstrap: `.fi.sh`

The installer is literally named **`f` · `i` · `s` · `h`** (dots in `.fi.sh`). It is **Bash**, not the [Fish](https://fishshell.com/) shell — the name is a souvenir from “fast install script helper,” stretched one letter for the road.

When you run it, expect **real fish** (emoji + a tiny ASCII pilchard) and **no** `fish` binary unless you install that yourself.

**`f·i·s·h` (Fast Install Script Helper)** automates a fresh Arch setup: pacman tuning, `gum` UI, packages, `reflector`, git identity, dev tooling (oh-my-posh, **fnm**, bun), AI CLI installers, Python/Rust, and a **destructive** re-clone of this repo into `~/.config` (it removes an existing `~/.config` first). It installs the **fnm** binary only; **Node.js** is installed in a second step via [`~/.config/.fi.temp.sh`](.fi.temp.sh) (the script offers to run it after cloning, or you can run `zsh ~/.config/.fi.temp.sh` later).

**Requirements:** Arch Linux with `sudo` and network; run as your normal user (not root). Review the script before running — it encodes personal git name/email and remote URLs.

**Run:**

```bash
bash ~/.config/.fi.sh
# or after copying the script somewhere:
bash ./.fi.sh
```

On success it offers to `exec zsh` and deletes **this script file** (whatever path you ran) when finished.

**Syntax:** Validated with `bash -n` (no parse errors). For extra linting, install [ShellCheck](https://www.shellcheck.net/) and run `shellcheck .fi.sh`.

---

_Version in script: see `fish_version` in `.fi.sh`._
_Use at your own risk!_
