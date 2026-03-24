#!/bin/bash
# F·I·S·H — Fast Install Script Helper (Bash)
fish_version="2.5.6"
set -e

# Rams-ish palette
ORANGE="#f1833f"
INK="#1d1d1d"
STONE="#595959"
CREAM="#dddede"
OK="#80b68a"
ERR="#ea6962"
# Plain-text bootstrap (before gum): bright green ✓ lines
GRN='\033[1;32m'
NC='\033[0m'

# ── Gum Wrappers (used after gum is installed) ──────────────────
section() {
  echo ""
  gum style --border-foreground "$ORANGE" --foreground "$CREAM" \
    --background "$ORANGE" \
    --bold --padding "0 2" --margin "0 2" "$1"
  echo ""
}

task() {
  local title="$1"
  shift
  if gum spin --spinner dot --title "$title" -- "$@"; then
    gum style --foreground "$OK" "✓ $title"
  else
    gum style --foreground "$ERR" "✗ $title"
    return 1
  fi
}

# After any gum spin --show-output: wipe TUI residue, redraw hero + section.
main_banner() {
  echo ""
  gum style --border normal --border-foreground "$ORANGE" --foreground "$CREAM" \
    --background "$ORANGE" \
    --bold --padding "1 3" --margin "0 2" --align center \
    "f · i · s · h 🐟 🐠 🐡 ><>" "" \
    "Fast Install Script Helper v${fish_version}" \
    "Arch Linux bootstrap"
}

vspin() {
  local sec="$1"
  shift
  local title="$1"
  shift
  if gum spin --show-output --spinner dot --title "$title" -- "$@"; then
    printf '\033[2J\033[H'
    main_banner
    section "$sec"
    return 0
  fi
  printf '\033[2J\033[H'
  main_banner
  section "$sec"
  gum style --foreground "$ERR" "✗ $title"
  exit 1
}

step() {
  gum style --foreground "$ORANGE" --bold "→ $1"
}

info() {
  gum style --foreground "$STONE" --italic "● $1"
}

success() {
  gum style --foreground "$OK" "✓ $1"
}

# Must match https://fnm.vercel.app/install (INSTALL_DIR resolution)
fnm_install_dir() {
  if [ -d "$HOME/.fnm" ]; then
    printf '%s\n' "$HOME/.fnm"
  elif [ -n "${XDG_DATA_HOME:-}" ]; then
    printf '%s\n' "$XDG_DATA_HOME/fnm"
  else
    printf '%s\n' "$HOME/.local/share/fnm"
  fi
}

# ── Pre-Gum Bootstrap (plain bash, gum not yet available) ───────
bootstrap_banner() {
  echo ""
  echo "  f · i · s · h 🐟 🐠 🐡 ><> v${fish_version}"
  echo "  Fast Install Script Helper for Arch Linux"
  echo "  --------------------------------------------"
  echo "  Author: https://github.com/tuantf"
  echo "  Repo: https://github.com/tuantf/linux-config"
  echo "  --------------------------------------------"
  echo "  Bootstrapping..."
  echo ""
}

bootstrap_confirm() {
  echo "  This will change pacman settings, run a full system upgrade,"
  echo "  and install packages and dev tooling. Use only on a machine"
  echo "  you mean to configure with this script."
  echo ""
  local reply
  read -rp "  Proceed? [y/N] " reply || exit 1
  case "${reply,,}" in
    y|yes) ;;
    *)
      echo "  Aborted."
      exit 1
      ;;
  esac
  echo ""
}

clear
bootstrap_banner
bootstrap_confirm

sudo sed -i "s/ParallelDownloads.*/ParallelDownloads = 10\nILoveCandy/" /etc/pacman.conf
sudo sed -i "s/#Color/Color/" /etc/pacman.conf
sudo sed -i "s/#DisableSandbox/DisableSandbox/" /etc/pacman.conf
echo -e "${GRN}  ✓ Pacman configured (ParallelDownloads + ILoveCandy)${NC}"

echo ""
echo "  → Syncing package databases..."
sudo pacman -Syu --noconfirm
clear
bootstrap_banner
echo -e "${GRN}  ✓ Pacman configured (ParallelDownloads + ILoveCandy)${NC}"
echo -e "${GRN}  ✓ System upgraded${NC}"

echo ""
echo "  → Installing gum..."
sudo pacman -S --noconfirm gum
hash -r

if ! command -v gum &>/dev/null; then
  echo "  ✗ gum not found — cannot continue"
  exit 1
fi
clear
bootstrap_banner
echo -e "${GRN}  ✓ Pacman configured (ParallelDownloads + ILoveCandy)${NC}"
echo -e "${GRN}  ✓ System upgraded${NC}"
echo -e "${GRN}  ✓ gum ready${NC}"

# Gum theme: spin + confirm pick up GUM_* (see `gum spin --help` / `gum confirm --help`)
export GUM_SPIN_SPINNER_FOREGROUND="$ORANGE"
export GUM_SPIN_TITLE_FOREGROUND="$INK"
export GUM_CONFIRM_PROMPT_FOREGROUND="$INK"
export GUM_CONFIRM_SELECTED_FOREGROUND="$CREAM"
export GUM_CONFIRM_SELECTED_BACKGROUND="$ORANGE"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="$STONE"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="#EBE8E0"

# ── Banner (gum available from here on) ─────────────────────────
printf '\033[2J\033[H'
main_banner

# ── System Packages ──────────────────────────────────────────────
section "System Packages"

step "Installing packages"
vspin "System Packages" "Installing system packages" bash -c \
  'sudo pacman -S --noconfirm --needed base-devel zsh pacman-contrib man-db git neovim fzf zoxide go eza reflector && \
   sudo pacman -S --noconfirm --needed tree unzip postgresql postgresql-libs wget libffi openssl zlib openssh curl lua'
success "All packages installed"

vspin "System Packages" "Reflector: config, timer, mirror refresh" \
  bash -c \
  'sudo sed -i "s/# --country.*/--country SG,HK,VN/" /etc/xdg/reflector/reflector.conf && \
     sudo sed -i "s/--latest 5/--latest 10/" /etc/xdg/reflector/reflector.conf && \
     sudo sed -i "s/--sort age/--sort rate/" /etc/xdg/reflector/reflector.conf && \
     sudo systemctl enable --now reflector.timer && \
     sudo systemctl start reflector.service'
success "Reflector configured, mirrorlist refreshed, timer enabled and running"

vspin "System Packages" "Paccache: weekly cleanup" \
  bash -c 'sudo systemctl enable --now paccache.timer && sudo systemctl start paccache.timer'
success "Paccache: weekly cleanup enabled and running"

# ── Git Config ───────────────────────────────────────────────────
section "Git Configuration"

task "Setting user → tuantf" \
  git config --global user.name tuantf
task "Setting email" \
  git config --global user.email fr.sqre.dm@gmail.com
task "Setting credential cache (7 days)" \
  git config --global credential.helper "cache --timeout=604800"
task "Setting default branch → main" \
  git config --global init.defaultBranch main

# ── Dev Tools ────────────────────────────────────────────────────
section "Developer Tools"

vspin "Developer Tools" "Installing oh-my-posh" \
  bash -c 'curl -s https://ohmyposh.dev/install.sh | bash -s'
success "oh-my-posh installed"

vspin "Developer Tools" "Installing fnm (Fast Node Manager)" \
  bash -c 'curl -o- https://fnm.vercel.app/install | bash'
success "fnm installed"

export PATH="$(fnm_install_dir):$PATH"
eval "$(fnm env 2>/dev/null)" 2>/dev/null || true

vspin "Developer Tools" "Installing Node.js 24 via fnm" \
  bash -c 'export PATH="'"$(fnm_install_dir)"':$PATH" && eval "$(fnm env)" && fnm install --progress never 24 && fnm use 24'
eval "$(fnm env 2>/dev/null)" 2>/dev/null || true
success "Node.js $(node -v 2>/dev/null || echo 'v24') and npm $(npm -v 2>/dev/null || echo 'n/a') installed"

vspin "Developer Tools" "Installing bun" \
  bash -c 'curl -fsSL https://bun.sh/install | bash'
export PATH="$HOME/.bun/bin:$PATH"
success "bun $(bun -v 2>/dev/null || echo '') installed"

# ── AI Tools ────────────────────────────────────────────
section "AI Tools"

vspin "AI Tools" "Installing Claude Code" \
  bash -c 'curl -fsSL https://claude.ai/install.sh | bash && git clone https://github.com/tuantf/claude-code.git ~/.claude'
success "Claude Code installed"

vspin "AI Tools" "Installing OpenCode" \
  bash -c 'curl -fsSL https://opencode.ai/install | bash'
success "OpenCode installed"

# ── Config Files ─────────────────────────────────────────────────
section "Config Files"

task "Cloning config repo → ~/.config" \
  bash -c 'cd && rm -rf ~/.config && git clone https://github.com/tuantf/linux-config.git ~/.config'

task "Linking .zshrc" \
  bash -c 'rm -f ~/.zshrc && ln -s ~/.config/zsh/.zshrc ~/.zshrc'

# ── Programming Languages ─────────────────────────────────────────
section "Programming Languages"

vspin "Programming Languages" "Installing Python" \
  sudo pacman -S --noconfirm python python-pip python-pipx uv
success "$(python -V 2>/dev/null || echo 'Python') installed"

vspin "Programming Languages" "Installing Rust" \
  bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
success "Rust installed"

# ── Done ─────────────────────────────────────────────────────────
echo ""
gum style --border rounded --border-foreground "$OK" --foreground "$OK" \
  --background "$CREAM" \
  --bold --padding "0 2" --margin "0 2" "✓ All done!  f·i·s·h v${fish_version}"
echo ""
info "Switch to zsh to apply your new config"
echo ""

rm -f "${BASH_SOURCE[0]}"

if gum confirm "Launch zsh now?"; then
  exec zsh
fi
