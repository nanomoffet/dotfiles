# ─── Environment Variables ───────────────────────────────────────────────────

# Editor
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'

# Go
export GOPATH="$HOME/go"
export GOROOT="$(brew --prefix golang)/libexec"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
