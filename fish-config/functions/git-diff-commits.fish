function git-diff-commits
	set left $argv[1]/.git
set right $argv[2]/.git
set leftfile (mktemp)
set rightfile (mktemp)
git --git-dir $left rev-list --remotes | sort > $leftfile
git --git-dir $right rev-list --remotes | sort > $rightfile
diff $leftfile $rightfile
rm $leftfile $rightfile
end
