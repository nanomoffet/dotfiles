#!/usr/bin/env bash

echo "------------------------------"
echo "Elevating privileges..."
# Ask for the administrator password upfront.
sudo -v

osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/mmoffet/.dotfiles/wallpaper.jpg"'

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off >/dev/null
# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

# Configure dock
defaults write com.apple.dock orientation left
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock autohide -boolean yes
# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

defaults write -g NSWindowShouldDragOnGesture -bool true

# hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

killall Finder

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then

  # Install homebrew
  echo "installing homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi

# Enable the brew command
eval "$(/opt/homebrew/bin/brew shellenv)"
#
# Install oh my zsh
if ! [ -d ".oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install dracula theme for zsh
git clone https://github.com/dracula/zsh.git .dotfiles/zsh-theme
ln -s ~/.dotfiles/zsh-theme/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme

# copy core config files to Home
cp .dotfiles/Brewfile Brewfile

# Make sure we’re using the latest Homebrew.
brew update

brew bundle

# Set up dotfiles
stow -v .

# start aerospace
open -n /Applications/AeroSpace.app

# start skhd
skhd --start-service

# start sketchybar
brew services restart sketchybar

# start JankyBorders
brew services start borders

# initiate starship
eval "$(starship init zsh)"

# copy firefox css tweaks and toggle customstyle config flag
