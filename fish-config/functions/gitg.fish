function gitg
	set toplevel (git rev-parse --show-toplevel)
	if test $status = 0
		if test (uname) = "Darwin"
			# Hack to work around a libgit2 bug--libgit2 doesn't read
			# core.excludesfile.
			set gitg_line "# Copied from global excludesfile for libgit2's benefit. Do not edit below this line."
			set ignorefile $toplevel/.git/info/exclude
			set oldcontents (mktemp)
			set gitg_file (mktemp)
			echo $gitg_line > $gitg_file
			echo ignorefile: $ignorefile
			awk "/$gitg_line/ {exit} {print}" $toplevel/.git/info/exclude > $oldcontents
			set globalfile (git config core.excludesfile | sed -e "s|^~|$HOME|")
			cat $oldcontents $gitg_file $globalfile > $ignorefile
			rm $oldcontents $gitg_file
			open -a GitUp $toplevel
		else
			command gitg >/dev/null ^&1 &
		end
	else
		echo "Not a Git repository."
	end
end