function clean-login-items
	osascript -e 'tell application "System Events" to delete login item "Spotify"'
osascript -e 'tell application "System Events" to delete login item "GOG Galaxy"'
osascript -e 'tell application "System Events" to delete login item "Steam"'
osascript -e 'tell application "System Events" to delete login item "Google Chrome"'
end
