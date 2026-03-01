#!/bin/zsh

defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# this stops the Mac from periodically waking from sleep and lighting up the
# room with its display in the middle of the night
# the below originally had -currentHost, dunno if that mattters
defaults write com.apple.Bluetooth RemoteWakeEnabled 0

# Disable rearranging Spaces based on most recently used
defaults write com.apple.dock mru-spaces -bool false

# Disable two finger swipe back/forward in Chromium-based Web browsers
# nb: for the Magic Mouse the key to use is AppleEnableMouseSwipeNavigateWithScrolls
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.vivaldi.Vivaldi AppleEnableSwipeNavigateWithScrolls -bool false

# disable Spotlight shortcut
# from https://superuser.com/questions/1211108/remove-osx-spotlight-keyboard-shortcut-from-command-line
# /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
#   -c "Delete :AppleSymbolicHotKeys:64" \
#   -c "Add :AppleSymbolicHotKeys:64:enabled bool false" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters array" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 65535" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 49" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 1048576" \
#   -c "Add :AppleSymbolicHotKeys:64:type string standard"
