# ─── Tool Initialisation ─────────────────────────────────────────────────────

# Shell integration
[[ -f ~/.shell-integration.sh ]] && source ~/.shell-integration.sh

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# Fast Node Manager
eval "$(fnm env --use-on-cd)"

# Starship prompt
eval "$(starship init zsh)"

# Mise (polyglot runtime manager)
eval "$(mise activate zsh)"

# Zellij (terminal multiplexer) – auto-attach or create default session
if [[ -z "$ZELLIJ" && -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then
    if command -v zellij &>/dev/null; then
        eval "$(zellij setup --generate-auto-start zsh)"
    fi
fi
