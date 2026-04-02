# ─── Completions ─────────────────────────────────────────────────────────────

# Completion style
zstyle ':completion:*' menu select

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)

# Init completions (must be after fpath modifications)
autoload -Uz compinit && compinit
