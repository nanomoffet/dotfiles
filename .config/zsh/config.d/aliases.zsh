alias vim='nvim'
alias python='python3'
alias pip='pip3'
alias lzd='lazydocker'
alias xz="exec zsh"
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
alias m='mise'
alias mr='mise run'
alias dc='mise run debugchoose'
alias zshconfig="vim ~/.zshrc"

alias dfs="$HOME/.scripts/dotfiles.sh"
alias pra="$HOME/.scripts/pull-request-approvals.sh"
alias prc="$HOME/.scripts/pull-request-close.sh"
