# ─── Aliases ─────────────────────────────────────────────────────────────────

# Editor
alias vim='nvim'
alias zshconfig="vim ~/.zshrc"

# Language defaults
alias python='python3'
alias pip='pip3'

# Modern CLI replacements
alias cat='bat --theme ansi'
alias top='btop'
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'

# Tools
alias lzd='lazydocker'
alias bd="/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"

# Mise shortcuts
alias m='mise'
alias mr='mise run'
alias mu='mise use'
alias mt='mise trust'
alias dc='mise run debugchoose'

# Shell
alias xz="exec zsh"

# Scripts
alias dfs="$HOME/.scripts/dotfiles.sh"
alias pra="$HOME/.scripts/pull-request-approvals.sh"
alias prc="$HOME/.scripts/pull-request-close.sh"
