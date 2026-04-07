# ─── Plugins ─────────────────────────────────────────────────────────────────

# Oh My Zsh plugins
plugins=(
    git
    docker
    colorize
    colored-man-pages
    fasd
    gh
    golang
    mise
    z
    vi-mode
)

# Zplug
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source "$ZPLUG_HOME/init.zsh"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/eza",   from:oh-my-zsh
zplug "dracula/zsh", as:theme
zplug "MichaelAquilina/zsh-you-should-use"
zplug "tranzystorekk/zellij-zsh"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Autosuggestions (installed via Homebrew)
# HOMEBREW_PREFIX may not be set yet if brew shellenv hasn't been evaluated,
# so resolve it explicitly here.
_brew_prefix="${HOMEBREW_PREFIX:-$(/opt/homebrew/bin/brew --prefix 2>/dev/null)}"
[[ -f "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
unset _brew_prefix
