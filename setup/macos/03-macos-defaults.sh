#!/bin/bash
set -e

echo "[*] applying macOS defaults..."

# Trackpad: tap to click (built-in and Bluetooth)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Finder: show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable .DS_Store on network/USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Restart affected apps
killall Finder 2>/dev/null || true

echo "[ok] macOS defaults applied!"
