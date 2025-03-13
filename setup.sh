#!/bin/sh

#==============
# Install all the packages
#==============

sh "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~ || return
git clone git clone https://github.com/nanomoffet/dotfiles.git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd .dotfiles || return

brew bundle

rcup -v

osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/${account}$/.dotfiles/wallpaper.jpg"'
defaults write com.apple.dock orientation left
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock autohide -boolean yes
killall Dock

# start yabai
aerospace --start-service

# start skhd
skhd --start-service

# start sketchybar
brew services start sketchybar

# hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

killall Finder

# start JankyBorders
brew services start borders

# copy firefox css tweaks and toggle customstyle config flag
