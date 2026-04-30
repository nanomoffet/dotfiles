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

# Zellij tab renaming – keep tab name in sync with current directory
if [[ -n "$ZELLIJ" ]]; then
    _zellij_tab_rename() { zellij action rename-tab "$(basename "$PWD")"; }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _zellij_tab_rename
    _zellij_tab_rename   # set name on shell start
fi

# Yazi – shell wrapper that changes CWD on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
