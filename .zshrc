# ─── ZSH Configuration Loader ────────────────────────────────────────────────
# All configuration is split into modular files under ~/.config/zsh/config.d/
# Files are sourced in alphabetical order (use numeric prefixes to control order):
#   01-core.zsh        - Shell options, history, oh-my-zsh init
#   02-variables.zsh   - Environment variables, PATH
#   03-plugins.zsh     - Plugin managers (oh-my-zsh, zplug)
#   04-aliases.zsh     - Shell aliases
#   05-completions.zsh - Completion settings, fzf, docker
#   06-tools.zsh       - Startup eval scripts (zoxide, brew, starship, etc.)
#   07-keybindings.zsh - Key bindings
# ──────────────────────────────────────────────────────────────────────────────

ZSHCONF_DIR="${HOME}/.config/zsh/config.d"

if [[ -d "$ZSHCONF_DIR" ]]; then
    for conf in "${ZSHCONF_DIR}"/*.zsh(N); do
        source "${conf}"
    done
fi
autoload -U compinit; compinit
