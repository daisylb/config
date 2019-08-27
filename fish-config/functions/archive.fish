function archive
	if test (count $argv) -ne 1
echo "Usage: archive <repo-directory>"
return 1
end
pushd $argv[1]
set dest ~/Dropbox/Project\ Archives/(basename $PWD).bundle
if test -e $dest
echo "$dest already exists"
popd
return 2
end
if not test -d .git
git init .
end
if test -n (git diff --shortstat)
git add .
git commit -m "Automatic commit for archiving"
end
git bundle create $dest --all
popd
end