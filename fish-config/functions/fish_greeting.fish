function fish_greeting
	for thing in (ls ~/config)
		set gitstatus (git -C ~/config/$thing status --porcelain ^/dev/null)
        set gitunpushed (git -C ~/config/$thing rev-list "@{u}.." ^/dev/null)
		if test "$gitstatus" != ""
			echo -s (set_color -o white -b red) "config/$thing working directory is dirty" (set_color normal)
		end
		if test "$gitunpushed" != ""
			echo -s (set_color -o white -b blue) "config/$thing is ahead of remote" (set_color normal)
		end
	end

    if test -f /etc/systemd/system/backup.service
        if systemctl is-failed backup.service --quiet
            echo -s (set_color -o white -b red)
            echo -s "                              "
            echo -s "           OH NOES!           "
            echo -s "     BACKUPS ARE FAILING!     "
            echo -s "                              "
        end
    end
end