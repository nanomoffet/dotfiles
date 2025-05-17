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

