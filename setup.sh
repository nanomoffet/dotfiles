#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve the directory this script lives in (i.e. the repo root)
# ---------------------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Dry-run support:  ./setup.sh --dry-run
# ---------------------------------------------------------------------------
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
  esac
done

# Diagnostics tracking
declare -a DIAG_OK=()
declare -a DIAG_SKIP=()
declare -a DIAG_FAIL=()
declare -a DIAG_MANUAL=()

diag_ok()     { DIAG_OK+=("$1"); }
diag_skip()   { DIAG_SKIP+=("$1"); }
diag_fail()   { DIAG_FAIL+=("$1"); }
diag_manual() { DIAG_MANUAL+=("$1"); }

run_cmd() {
  if $DRY_RUN; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

echo "------------------------------"
echo "Dotfiles directory: $DOTFILES_DIR"
$DRY_RUN && echo "*** DRY-RUN MODE — no changes will be made ***"
echo "Elevating privileges..."

if ! $DRY_RUN; then
  sudo -v
  # Keep sudo alive for the duration of the script
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

###############################################################################
# Xcode Command Line Tools                                                    #
###############################################################################

if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  run_cmd xcode-select --install
  if ! $DRY_RUN; then
    echo "Waiting for Xcode CLT installation to complete..."
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi
  diag_ok "Xcode CLT installed"
else
  echo "Xcode Command Line Tools are already installed."
  diag_ok "Xcode CLT (already present)"
fi

###############################################################################
# macOS Settings                                                              #
###############################################################################

echo "Applying macOS settings..."

# --- Input ---

# Disable smart quotes
run_cmd defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
run_cmd defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable autocorrect
run_cmd defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalisation
run_cmd defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable "natural" scrolling
run_cmd defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Enable full keyboard access for all controls (e.g. Tab in modal dialogs)
run_cmd defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Blazingly fast keyboard repeat rate
run_cmd defaults write NSGlobalDomain KeyRepeat -int 1
run_cmd defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad: enable tap to click (both built-in and Bluetooth trackpads)
run_cmd defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
run_cmd defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
run_cmd defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
run_cmd defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# --- Power ---

# Prevent sleep (replaces deprecated systemsetup -setcomputersleep)
run_cmd sudo pmset -a sleep 0
run_cmd sudo pmset -a disksleep 0
run_cmd sudo pmset -a displaysleep 0

# Disable hibernation (speeds up entering sleep mode)
run_cmd sudo pmset -a hibernatemode 0

# --- Dock ---

run_cmd defaults write com.apple.dock tilesize -int 32
run_cmd defaults write com.apple.dock autohide -bool true
run_cmd defaults write com.apple.dock autohide-delay -float 0
run_cmd defaults write com.apple.dock autohide-time-modifier -float 0
# Group windows by app in Mission Control (recommended for AeroSpace)
run_cmd defaults write com.apple.dock expose-group-apps -bool true

# --- Spaces (AeroSpace recommended) ---

# Disable "Displays have separate Spaces" — recommended by AeroSpace docs
# for better stability and fewer focus bugs with multi-monitor setups
run_cmd defaults write com.apple.spaces spans-displays -bool true

# --- Menu Bar ---

run_cmd defaults write NSGlobalDomain _HIHideMenuBar -bool true

# --- Finder ---

run_cmd defaults write com.apple.finder AppleShowAllFiles -bool true
run_cmd defaults write NSGlobalDomain AppleShowAllExtensions -bool true
run_cmd defaults write com.apple.finder ShowPathbar -bool true
run_cmd defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
run_cmd defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
run_cmd defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
run_cmd defaults write com.apple.finder WarnOnEmptyTrash -bool false
run_cmd chflags nohidden ~/Library

# --- Dialogs ---

# Expand save panel by default
run_cmd defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
run_cmd defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
run_cmd defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
run_cmd defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# --- Screenshots ---

SCREENSHOT_DIR="$HOME/Screenshots"
echo ""
echo "Where should screenshots be saved?"
echo "  1) ~/Screenshots  (default)"
echo "  2) ~/Desktop"
echo "  3) ~/Documents/Screenshots"
printf "Choose [1/2/3]: "
if ! $DRY_RUN; then
  read -r ss_choice
else
  ss_choice="1"
  echo "[dry-run] defaulting to 1"
fi
case "${ss_choice:-1}" in
  2) SCREENSHOT_DIR="$HOME/Desktop" ;;
  3) SCREENSHOT_DIR="$HOME/Documents/Screenshots" ;;
  *) SCREENSHOT_DIR="$HOME/Screenshots" ;;
esac
run_cmd mkdir -p "$SCREENSHOT_DIR"
run_cmd defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"

echo ""
echo "Screenshot format?"
echo "  1) png  (default, lossless)"
echo "  2) jpg  (smaller files)"
printf "Choose [1/2]: "
if ! $DRY_RUN; then
  read -r ss_fmt
else
  ss_fmt="1"
  echo "[dry-run] defaulting to 1"
fi
case "${ss_fmt:-1}" in
  2) run_cmd defaults write com.apple.screencapture type -string "jpg" ;;
  *) run_cmd defaults write com.apple.screencapture type -string "png" ;;
esac

# Disable screenshot shadow
run_cmd defaults write com.apple.screencapture disable-shadow -bool true

# --- Window Management ---

# Drag windows from anywhere with Ctrl+Cmd+click
run_cmd defaults write -g NSWindowShouldDragOnGesture -bool true

# --- Gatekeeper ---

# Disable Gatekeeper quarantine "are you sure?" dialog for downloaded apps
run_cmd defaults write com.apple.LaunchServices LSQuarantine -bool false

# --- Media Keys ---

# Prevent Music app from hijacking media keys (modern launchctl syntax)
run_cmd launchctl disable "gui/$(id -u)/com.apple.rcd" 2>/dev/null || true

# --- Apply changes ---

run_cmd killall Dock 2>/dev/null || true
run_cmd killall Finder 2>/dev/null || true
run_cmd killall SystemUIServer 2>/dev/null || true

diag_ok "macOS settings applied"
echo "macOS settings applied."

###############################################################################
# Security & Privacy                                                          #
###############################################################################

echo ""
echo "--- Security & Privacy ---"

# Enable firewall
if ! $DRY_RUN; then
  fw_status=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null || echo "")
  if [[ "$fw_status" != *"enabled"* ]]; then
    echo "Enabling macOS firewall..."
    run_cmd sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
    diag_ok "Firewall enabled"
  else
    echo "Firewall is already enabled."
    diag_ok "Firewall (already enabled)"
  fi
else
  echo "  [dry-run] sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on"
fi

# FileVault
if ! $DRY_RUN; then
  fv_status=$(fdesetup status 2>/dev/null || echo "")
  if [[ "$fv_status" == *"FileVault is Off"* ]]; then
    echo ""
    printf "FileVault disk encryption is OFF. Enable it now? [y/N]: "
    read -r fv_choice
    if [[ "${fv_choice:-n}" =~ ^[Yy]$ ]]; then
      sudo fdesetup enable
      diag_ok "FileVault enabled"
    else
      diag_manual "FileVault is OFF — enable via System Settings > Privacy & Security"
    fi
  else
    echo "FileVault is already enabled."
    diag_ok "FileVault (already enabled)"
  fi
else
  echo "  [dry-run] fdesetup enable"
fi

###############################################################################
# Homebrew                                                                    #
###############################################################################

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  if ! $DRY_RUN; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "  [dry-run] install homebrew"
  fi
fi

# Add Homebrew to PATH — Apple Silicon (/opt/homebrew) or Intel (/usr/local)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew &>/dev/null; then
  echo "ERROR: Homebrew installation failed or brew is not in PATH."
  echo "       Please install Homebrew manually and re-run this script."
  diag_fail "Homebrew"
  exit 1
fi

diag_ok "Homebrew"
echo "Homebrew is ready."

###############################################################################
# Brewfile                                                                    #
###############################################################################

echo "Running Brewfile..."
run_cmd brew update

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  run_cmd brew bundle --file="$DOTFILES_DIR/Brewfile"
  diag_ok "Brewfile installed"
else
  echo "Warning: No Brewfile found at $DOTFILES_DIR/Brewfile. Skipping brew bundle."
  diag_skip "Brewfile (not found)"
fi

###############################################################################
# Oh My Zsh                                                                   #
###############################################################################

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  if ! $DRY_RUN; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "  [dry-run] install oh-my-zsh"
  fi
fi

diag_ok "Oh My Zsh"
echo "Oh My Zsh is ready."

###############################################################################
# Set Homebrew zsh as default shell                                           #
###############################################################################

echo ""
BREW_PREFIX="$(brew --prefix)"
BREW_ZSH="$BREW_PREFIX/bin/zsh"
if [ -x "$BREW_ZSH" ]; then
  if ! grep -qF "$BREW_ZSH" /etc/shells 2>/dev/null; then
    echo "Registering $BREW_ZSH in /etc/shells..."
    run_cmd sudo sh -c "echo '$BREW_ZSH' >> /etc/shells"
  fi
  if [ "$SHELL" != "$BREW_ZSH" ]; then
    echo "Switching default shell to Homebrew zsh ($BREW_ZSH)..."
    run_cmd chsh -s "$BREW_ZSH"
    diag_ok "Default shell → $BREW_ZSH"
  else
    echo "Default shell is already $BREW_ZSH."
    diag_ok "Default shell (already Homebrew zsh)"
  fi
else
  echo "Homebrew zsh not found at $BREW_ZSH — skipping shell switch."
  diag_skip "Default shell switch (zsh not found)"
fi

###############################################################################
# SSH & Git Identity                                                          #
###############################################################################

echo ""
echo "--- SSH & Git Identity ---"

SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
  printf "No SSH key found. Generate one now? [Y/n]: "
  if ! $DRY_RUN; then read -r ssh_choice; else ssh_choice="y"; echo "[dry-run] y"; fi
  if [[ "${ssh_choice:-y}" =~ ^[Yy]$ ]]; then
    printf "Email for SSH key: "
    if ! $DRY_RUN; then read -r ssh_email; else ssh_email="user@example.com"; echo "[dry-run] user@example.com"; fi
    run_cmd ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_KEY" -N ""
    run_cmd eval "$(ssh-agent -s)"
    # Add to macOS keychain
    mkdir -p "$HOME/.ssh"
    if ! $DRY_RUN; then
      cat > "$HOME/.ssh/config" <<'SSHEOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
SSHEOF
      ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add -K "$SSH_KEY" 2>/dev/null || true
    fi
    diag_ok "SSH key generated & added to keychain"
    echo ""
    echo "  ╔══════════════════════════════════════════════════════════════╗"
    echo "  ║  Your public key (add to GitHub/GitLab):                   ║"
    echo "  ╚══════════════════════════════════════════════════════════════╝"
    $DRY_RUN || cat "$SSH_KEY.pub"
    echo ""
  else
    diag_skip "SSH key generation"
  fi
else
  echo "SSH key already exists at $SSH_KEY."
  diag_ok "SSH key (already present)"
fi

# Git global config
echo ""
GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [ -z "$GIT_NAME" ]; then
  printf "Git user.name: "
  if ! $DRY_RUN; then read -r GIT_NAME; else GIT_NAME="Your Name"; echo "[dry-run] Your Name"; fi
  run_cmd git config --global user.name "$GIT_NAME"
fi

if [ -z "$GIT_EMAIL" ]; then
  printf "Git user.email: "
  if ! $DRY_RUN; then read -r GIT_EMAIL; else GIT_EMAIL="you@example.com"; echo "[dry-run] you@example.com"; fi
  run_cmd git config --global user.email "$GIT_EMAIL"
fi

# Set sensible git defaults
run_cmd git config --global init.defaultBranch main
run_cmd git config --global core.pager delta
run_cmd git config --global interactive.diffFilter "delta --color-only"
run_cmd git config --global delta.navigate true
run_cmd git config --global merge.conflictstyle diff3
run_cmd git config --global diff.colorMoved default

diag_ok "Git global config"

###############################################################################
# Copy config files from repo to $HOME                                        #
###############################################################################

echo ""
echo "Copying config files from repo to home directory..."

# Helper: copy a file or directory from the repo into the target location,
# backing up any existing target that differs from the source.
copy_item() {
  local src="$1" dest="$2"
  if $DRY_RUN; then
    echo "  [dry-run] copy $src → $dest"
    return
  fi
  # Remove stale symlinks left over from a previous setup
  if [ -L "$dest" ]; then
    echo "  Removing old symlink $dest"
    rm -f "$dest"
  fi
  # If destination already exists and is identical, skip
  if [ -e "$dest" ]; then
    if diff -rq "$src" "$dest" >/dev/null 2>&1; then
      return  # already up to date
    fi
    echo "  Backing up existing $dest → ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -d "$src" ]; then
    cp -R "$src" "$dest"
  else
    cp "$src" "$dest"
  fi
  echo "  Copied $src → $dest"
}

# --- Root-level dotfiles → $HOME ---

copy_item "$DOTFILES_DIR/.zshrc"                "$HOME/.zshrc"
copy_item "$DOTFILES_DIR/.shell-integration.sh" "$HOME/.shell-integration.sh"

# --- .config directories → $HOME/.config ---

CONFIG_DIRS=(
  aerospace
  borders
  btop
  configstore
  gh-dash
  iterm2
  karabiner
  mise
  nvim
  sketchybar
  wezterm
  yazi
  zsh
)

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
    copy_item "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
  fi
done

# --- .config single files ---

if [ -f "$DOTFILES_DIR/.config/starship.toml" ]; then
  copy_item "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
fi

# --- Oh My Zsh custom content ---

# .oh-my-zsh-custom/ in the repo maps to ~/.oh-my-zsh/custom/
if [ -d "$DOTFILES_DIR/.oh-my-zsh-custom" ]; then
  for item in "$DOTFILES_DIR/.oh-my-zsh-custom"/*; do
    [ -e "$item" ] || continue
    copy_item "$item" "$HOME/.oh-my-zsh/custom/$(basename "$item")"
  done
fi

# --- Scripts ---

if [ -d "$DOTFILES_DIR/.scripts" ]; then
  copy_item "$DOTFILES_DIR/.scripts" "$HOME/.scripts"
fi

# --- Wallpaper ---

if [ -f "$DOTFILES_DIR/wallpaper.jpg" ]; then
  if ! $DRY_RUN; then
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$DOTFILES_DIR/wallpaper.jpg\"" 2>/dev/null || true
  fi
  echo "  Desktop wallpaper set."
fi

diag_ok "Config files copied"
echo "Config files copied."


###############################################################################
# Zplug                                                                       #
###############################################################################

echo ""
echo "Setting up zplug..."

export ZPLUG_HOME="$(brew --prefix)/opt/zplug"

if [ ! -d "$ZPLUG_HOME" ]; then
  echo "  zplug not found at $ZPLUG_HOME."
  echo "  It should have been installed via the Brewfile. Attempting brew install..."
  run_cmd brew install zplug
fi

if [ ! -f "$ZPLUG_HOME/init.zsh" ]; then
  echo "ERROR: zplug init.zsh not found — cannot continue zplug setup."
  diag_fail "zplug init.zsh not found"
else
  diag_ok "zplug"
  echo "  zplug is installed at $ZPLUG_HOME."
fi

###############################################################################
# Initialise .zshrc — install zplug plugins non-interactively                 #
###############################################################################

echo "Installing zplug plugins..."

if ! $DRY_RUN; then
  zsh -c '
    export ZPLUG_HOME="$(brew --prefix)/opt/zplug"
    source "$ZPLUG_HOME/init.zsh"

    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-syntax-highlighting"
    zplug "plugins/git",   from:oh-my-zsh
    zplug "plugins/eza",   from:oh-my-zsh
    zplug "dracula/zsh", as:theme
    zplug "MichaelAquilina/zsh-you-should-use"

    if ! zplug check; then
      zplug install
    fi

    echo "  zplug plugins are installed."
  '
  diag_ok "zplug plugins installed"
else
  echo "  [dry-run] zplug install (6 plugins)"
fi

echo "Zsh plugin setup complete."

###############################################################################
# Font Verification                                                           #
###############################################################################

echo ""
echo "Verifying font installation..."

# Each entry maps a human-readable name to a filename pattern found in
# ~/Library/Fonts after the corresponding Homebrew cask is installed.
#   Cask                          → file pattern
#   font-fira-code-nerd-font      → FiraCodeNerdFont
#   font-fira-mono-nerd-font      → FiraMonoNerdFont
#   font-monaspace                → Monaspace
#   font-noto-color-emoji         → NotoColorEmoji
#   font-symbols-only-nerd-font   → SymbolsNerdFont
declare -A EXPECTED_FONTS=(
  ["FiraCode Nerd Font"]="FiraCodeNerdFont"
  ["FiraMono Nerd Font"]="FiraMonoNerdFont"
  ["Monaspace"]="Monaspace"
  ["Noto Color Emoji"]="NotoColorEmoji"
  ["Symbols Nerd Font"]="SymbolsNerdFont"
)

FONT_DIR="$HOME/Library/Fonts"
FONTS_MISSING=false

for name in "${!EXPECTED_FONTS[@]}"; do
  pattern="${EXPECTED_FONTS[$name]}"
  if $DRY_RUN; then
    echo "  [dry-run] check $name ($pattern*)"
    continue
  fi
  if compgen -G "$FONT_DIR/${pattern}*" >/dev/null 2>&1; then
    echo "  ✓  $name"
  else
    echo "  ✗  $name — not found (expected ${pattern}* in $FONT_DIR)"
    FONTS_MISSING=true
  fi
done

if $FONTS_MISSING; then
  echo ""
  echo "  Attempting to install missing fonts via Homebrew..."
  run_cmd brew bundle --file="$DOTFILES_DIR/Brewfile" --no-upgrade

  # Re-check after install attempt
  STILL_MISSING=false
  for name in "${!EXPECTED_FONTS[@]}"; do
    pattern="${EXPECTED_FONTS[$name]}"
    if ! compgen -G "$FONT_DIR/${pattern}*" >/dev/null 2>&1; then
      echo "  ✗  $name — still missing after install attempt"
      STILL_MISSING=true
    fi
  done

  if $STILL_MISSING; then
    diag_fail "Some fonts are still missing — install manually or re-run 'brew bundle'"
  else
    diag_ok "Fonts installed (recovered)"
    echo "  All expected fonts are now installed."
  fi
else
  diag_ok "Fonts verified"
  echo "  All expected fonts are installed."
fi

###############################################################################
# Development Environment Bootstrap                                           #
###############################################################################

echo ""
echo "--- Development Environment ---"

# Create GOPATH directory
run_cmd mkdir -p "$HOME/go"

# Node.js via fnm
if command -v fnm &>/dev/null; then
  echo ""
  printf "Install Node.js LTS via fnm? [Y/n]: "
  if ! $DRY_RUN; then read -r node_choice; else node_choice="y"; echo "[dry-run] y"; fi
  if [[ "${node_choice:-y}" =~ ^[Yy]$ ]]; then
    run_cmd fnm install --lts
    run_cmd fnm default lts-latest
    diag_ok "Node.js LTS (fnm)"
  else
    diag_skip "Node.js LTS install"
  fi
else
  diag_skip "fnm not found"
fi

# Mise — install runtimes from config
if command -v mise &>/dev/null; then
  echo ""
  printf "Run 'mise install' to install configured runtimes? [Y/n]: "
  if ! $DRY_RUN; then read -r mise_choice; else mise_choice="y"; echo "[dry-run] y"; fi
  if [[ "${mise_choice:-y}" =~ ^[Yy]$ ]]; then
    run_cmd mise install --yes
    diag_ok "mise runtimes installed"
  else
    diag_skip "mise install"
  fi
else
  diag_skip "mise not found"
fi

# pipx — common Python tools
if command -v pipx &>/dev/null; then
  echo ""
  echo "Install common Python tools via pipx?"
  echo "  Available: black, ruff, httpie, poetry"
  printf "Install all? [y/N]: "
  if ! $DRY_RUN; then read -r pipx_choice; else pipx_choice="n"; echo "[dry-run] n"; fi
  if [[ "${pipx_choice:-n}" =~ ^[Yy]$ ]]; then
    for tool in black ruff httpie poetry; do
      run_cmd pipx install "$tool" 2>/dev/null || echo "  $tool may already be installed."
    done
    diag_ok "pipx tools installed"
  else
    diag_skip "pipx tools"
  fi
else
  diag_skip "pipx not found"
fi

###############################################################################
# 1Password CLI                                                               #
###############################################################################

echo ""
if command -v op &>/dev/null; then
  op_status=$(op account list 2>/dev/null || echo "")
  if [ -z "$op_status" ]; then
    printf "1Password CLI is installed but not signed in. Sign in now? [y/N]: "
    if ! $DRY_RUN; then read -r op_choice; else op_choice="n"; echo "[dry-run] n"; fi
    if [[ "${op_choice:-n}" =~ ^[Yy]$ ]]; then
      echo "  Running 'op signin'... follow the prompts."
      if ! $DRY_RUN; then
        eval "$(op signin)" && diag_ok "1Password CLI signed in" || diag_fail "1Password CLI sign-in failed"
      fi
    else
      diag_skip "1Password CLI sign-in"
    fi
  else
    echo "1Password CLI is already signed in."
    diag_ok "1Password CLI (already signed in)"
  fi
else
  diag_skip "1Password CLI (not installed)"
fi

###############################################################################
# GitHub Personal Access Token                                                #
###############################################################################

echo ""
echo "--- GitHub Personal Access Token ---"

if ! command -v gh &>/dev/null; then
  echo "  GitHub CLI (gh) not found — skipping PAT setup."
  diag_skip "GitHub PAT (gh not installed)"
else
  # Authenticate if not already signed in
  if ! gh auth status &>/dev/null; then
    echo "  GitHub CLI is not authenticated."
    printf "  Authenticate with GitHub now? [Y/n]: "
    if ! $DRY_RUN; then read -r gh_auth_choice; else gh_auth_choice="y"; echo "[dry-run] y"; fi
    if [[ "${gh_auth_choice:-y}" =~ ^[Yy]$ ]]; then
      if ! $DRY_RUN; then
        gh auth login --web --git-protocol https
      else
        echo "  [dry-run] gh auth login --web --git-protocol https"
      fi
    else
      diag_skip "GitHub PAT (auth skipped)"
    fi
  else
    echo "  GitHub CLI is already authenticated."
  fi

  # Retrieve and export GITHUB_TOKEN
  if $DRY_RUN || gh auth status &>/dev/null; then
    if ! $DRY_RUN; then
      GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
    else
      GITHUB_TOKEN="ghp_dryrun00000000000000000000000000000000"
    fi

    if [ -n "$GITHUB_TOKEN" ]; then
      export GITHUB_TOKEN
      echo "  GITHUB_TOKEN exported for this session."

      # Persist to ~/.zshenv (sourced by zsh for all session types)
      ZSHENV_FILE="$HOME/.zshenv"
      if ! $DRY_RUN; then
        if grep -q "^export GITHUB_TOKEN=" "$ZSHENV_FILE" 2>/dev/null; then
          sed -i '' "s|^export GITHUB_TOKEN=.*|export GITHUB_TOKEN=$GITHUB_TOKEN|" "$ZSHENV_FILE"
          echo "  GITHUB_TOKEN updated in $ZSHENV_FILE."
        else
          echo "export GITHUB_TOKEN=$GITHUB_TOKEN" >> "$ZSHENV_FILE"
          echo "  GITHUB_TOKEN appended to $ZSHENV_FILE."
        fi
      else
        echo "  [dry-run] persist GITHUB_TOKEN to $ZSHENV_FILE"
      fi
      diag_ok "GitHub PAT exported as GITHUB_TOKEN"
    else
      echo "  Could not retrieve GitHub token — check 'gh auth status'."
      diag_fail "GitHub PAT (token retrieval failed)"
    fi
  fi
fi

###############################################################################
# AeroSpace — recommended macOS settings                                      #
###############################################################################

echo ""
echo "--- AeroSpace macOS recommendations ---"

# These are the macOS defaults recommended by the AeroSpace documentation
# for best stability and performance with the tiling window manager.

# 1. "Displays have separate Spaces" = OFF  (already set above via spans-displays)
echo "  ✓ Displays have separate Spaces: OFF (set above)"

# 2. "Group windows by application" in Mission Control = ON  (already set above)
echo "  ✓ Group windows by application: ON (set above)"

# 3. Dock position — AeroSpace recommends bottom so hidden workspace window
#    slivers are obscured by the Dock.
echo ""
echo "  AeroSpace recommends placing the Dock at the bottom."
echo "    1) bottom  (AeroSpace recommended)"
echo "    2) left"
echo "    3) right"
printf "  Choose [1/2/3]: "
if ! $DRY_RUN; then read -r dock_pos; else dock_pos="1"; echo "[dry-run] 1"; fi
case "${dock_pos:-1}" in
  2) run_cmd defaults write com.apple.dock orientation left   ;;
  3) run_cmd defaults write com.apple.dock orientation right  ;;
  *) run_cmd defaults write com.apple.dock orientation bottom ;;
esac
run_cmd killall Dock 2>/dev/null || true
diag_ok "Dock position set"

# 4. Reduce motion (makes Space switching faster if user ever triggers it)
echo ""
printf "  Enable 'Reduce motion' for faster animations? [Y/n]: "
if ! $DRY_RUN; then read -r motion_choice; else motion_choice="y"; echo "[dry-run] y"; fi
if [[ "${motion_choice:-y}" =~ ^[Yy]$ ]]; then
  run_cmd sudo defaults write com.apple.universalaccess reduceMotion -bool true
  diag_ok "Reduce motion enabled (AeroSpace recommendation)"
fi

diag_ok "AeroSpace macOS settings reviewed"

###############################################################################
# App Permissions & Login Items                                               #
###############################################################################

echo ""
echo "--- Login Items & Accessibility ---"

# Register login items for services that should auto-start
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
run_cmd mkdir -p "$LAUNCH_AGENTS_DIR"

# AeroSpace config already has start-at-login = true, so it handles itself.
echo "  AeroSpace: managed by its own start-at-login config."

# SketchyBar — ensure it starts at login via brew services
if command -v sketchybar &>/dev/null; then
  run_cmd brew services start sketchybar 2>/dev/null || true
  diag_ok "sketchybar login item"
  echo "  SketchyBar: registered via brew services."
fi

# JankyBorders — ensure it starts at login via brew services
if brew list borders &>/dev/null 2>&1; then
  run_cmd brew services start borders 2>/dev/null || true
  diag_ok "borders login item"
  echo "  JankyBorders: registered via brew services."
fi

# Accessibility reminders
echo ""
echo "  ╔══════════════════════════════════════════════════════════════╗"
echo "  ║  MANUAL STEP: Grant Accessibility permissions              ║"
echo "  ║  System Settings → Privacy & Security → Accessibility      ║"
echo "  ║  Enable access for:                                        ║"
echo "  ║    • AeroSpace                                             ║"
echo "  ║    • sketchybar                                            ║"
echo "  ║    • borders (JankyBorders)                                ║"
echo "  ╚══════════════════════════════════════════════════════════════╝"
diag_manual "Grant Accessibility permissions for AeroSpace, sketchybar, borders"

###############################################################################
# SketchyBar — build helpers & install SbarLua                                #
###############################################################################

echo ""
echo "--- SketchyBar setup ---"

SKETCHYBAR_CONFIG="$HOME/.config/sketchybar"

if command -v sketchybar &>/dev/null && [ -d "$SKETCHYBAR_CONFIG" ]; then
  # Build and install SbarLua module from source.
  # Always rebuild to ensure the .so matches the installed Lua version
  # (e.g. Homebrew may upgrade Lua 5.4 → 5.5, breaking an older .so).
  echo "  Building SbarLua from source..."
  if ! $DRY_RUN; then
    rm -rf /tmp/SbarLua
    git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua 2>/dev/null
    (cd /tmp/SbarLua && make install) && diag_ok "SbarLua installed" || diag_fail "SbarLua build failed"
    rm -rf /tmp/SbarLua
  else
    echo "  [dry-run] git clone SbarLua && make install"
  fi

  # Build the C helper binaries (event providers & menus)
  echo "  Building sketchybar helpers..."
  if ! $DRY_RUN; then
    (cd "$SKETCHYBAR_CONFIG/helpers" && make) && diag_ok "sketchybar helpers built" || diag_fail "sketchybar helpers build failed"
  else
    echo "  [dry-run] cd $SKETCHYBAR_CONFIG/helpers && make"
  fi
else
  echo "  sketchybar not installed or config not found — skipping."
  diag_skip "sketchybar helpers"
fi

###############################################################################
# Start Services                                                              #
###############################################################################

echo ""
echo "Starting services..."

# AeroSpace
run_cmd open -a AeroSpace 2>/dev/null || echo "  AeroSpace not found — skipping."

# SketchyBar (may already be running from login items step)
brew services restart sketchybar 2>/dev/null && diag_ok "sketchybar started" || diag_skip "sketchybar"

# JankyBorders (may already be running from login items step)
brew services restart borders 2>/dev/null && diag_ok "borders started" || diag_skip "borders"

# Starship — confirm it will load on next shell launch (init is in .zshrc)
if command -v starship &>/dev/null; then
  echo "  Starship is installed and will initialise via .zshrc."
  diag_ok "Starship (will init via .zshrc)"
else
  echo "  Starship not found — skipping."
  diag_skip "Starship"
fi

###############################################################################
# Post-Setup Diagnostic Summary                                               #
###############################################################################

echo ""
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                       SETUP SUMMARY                               ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"

if [ ${#DIAG_OK[@]} -gt 0 ]; then
  echo ""
  echo "  ✅  Succeeded:"
  for item in "${DIAG_OK[@]}"; do
    echo "      • $item"
  done
fi

if [ ${#DIAG_SKIP[@]} -gt 0 ]; then
  echo ""
  echo "  ⏭   Skipped:"
  for item in "${DIAG_SKIP[@]}"; do
    echo "      • $item"
  done
fi

if [ ${#DIAG_FAIL[@]} -gt 0 ]; then
  echo ""
  echo "  ❌  Failed:"
  for item in "${DIAG_FAIL[@]}"; do
    echo "      • $item"
  done
fi

if [ ${#DIAG_MANUAL[@]} -gt 0 ]; then
  echo ""
  echo "  🔧  Manual steps required:"
  for item in "${DIAG_MANUAL[@]}"; do
    echo "      • $item"
  done
fi

echo ""
echo "------------------------------"
echo "Setup complete. Open a new terminal window for all changes to take effect."
