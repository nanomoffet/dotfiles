#!/usr/bin/env bash

current=$(pwd)
cd ${HOME}/.dotfiles || return
stow -R .
git add .
git commit -m "update to dotfiles $(date +"%Y-%m-%d %H:%M:%S")"
git push
cd ${current} || return
