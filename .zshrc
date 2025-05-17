export GOPATH=$HOME/go
export GOPRIVATE="github.com/NBCUDTC"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

alias dfs="$HOME/.scripts/dotfiles.sh"
alias pra="$HOME/.scripts/pull-request-approvals.sh"
alias prc="$HOME/.scripts/pull-request-close.sh"

bindkey -v

export ZSH="$HOME/.oh-my-zsh"


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

export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/eza",   from:oh-my-zsh
zplug 'dracula/zsh', as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

COMPLETION_WAITING_DOTS="true"

autoload -Uz compinit && compinit

source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' menu select

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/libpq/bin:$PATH"

source ~/.shell-integration.sh

eval "$(zoxide init zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(fnm env --use-on-cd)"
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
