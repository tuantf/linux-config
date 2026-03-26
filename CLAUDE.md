# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal dotfiles repository for Linux configuration, designed to be cloned into `~/.config` (XDG config home). Contains zsh, Neovim, Oh My Posh theme, and an Arch Linux bootstrap script.

## Key Components

### Zsh Configuration (`zsh/.zshrc`)
- Uses **zinit** as the plugin manager (auto-installs if missing)
- Plugins: zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions, fzf-tab
- OMZ snippets: git, sudo, archlinux, command-not-found
- Integrations: Oh My Posh prompt, fzf, zoxide (with `cd` command override)
- Aliases use `eza` for `ls`

### Neovim Configuration (`nvim/`)
- Built on **LazyVim** framework (auto-bootstraps lazy.nvim)
- Structure:
  - `init.lua` → entry point, loads `config/lazy.lua`
  - `lua/config/` — core config (lazy, options, keymaps, autocmds)
  - `lua/plugins/` — plugin specs (LazyVim auto-imports this directory)
- Plugin specs are individual files per plugin/feature
- Formatting: stylua with 2-space indentation

### Arch Bootstrap Script (`.fi.sh`)
- Bash script (not fish-shell) for fresh Arch Linux setup
- Uses `gum` for TUI elements after initial bootstrap
- Performs: pacman config, reflector, package installation, git identity setup, dev tooling (fnm binary, bun, oh-my-posh), and re-clones this repo into `~/.config`
- **Node.js**: not installed in `.fi.sh`; after clone, optionally run [`~/.config/.fi.temp.sh`](.fi.temp.sh) with **zsh** (`fnm install` + default version). Same file lives in-repo as [`.fi.temp.sh`](.fi.temp.sh).
- **Destructive**: removes existing `~/.config` before cloning
- Lint with: `bash -n .fi.sh` or `shellcheck .fi.sh`; `zsh -n .fi.temp.sh` for the zsh helper

## Symlink Setup

Zsh requires a symlink from `~/.zshrc` to the repo copy:
```bash
ln -sf ~/.config/zsh/.zshrc ~/.zshrc
```

Other configs (nvim, omp) are used in-place from `~/.config`.

## Lua Style

- 2-space indentation
- 120 column width
- Follow stylua config in `nvim/stylua.toml`