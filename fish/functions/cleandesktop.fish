function cleandesktop
	find ~/Desktop -maxdepth 1 -mtime +2d | xargs -IFILE mv FILE ~/DesktopOld/
end
