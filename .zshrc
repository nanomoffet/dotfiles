# init
autoload -Uz compinit && compinit

# extended history size
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

bindkey -v
COMPLETION_WAITING_DOTS="true"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Env var exports
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"


[[ -f ~/.config/zsh/config.d/envvar.zsh ]] && source ~/.config/zsh/config.d/envvar.zsh

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

  # Aliases
[[ -f ~/.config/zsh/config.d/aliases.zsh ]] && source ~/.config/zsh/config.d/aliases.zsh

# Plugins
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
zplug "MichaelAquilina/zsh-you-should-use"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

zstyle ':completion:*' menu select

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/libpq/bin:$PATH"

source ~/.shell-integration.sh

# Startup scripts
eval "$(zoxide init zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(fnm env --use-on-cd)"
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
