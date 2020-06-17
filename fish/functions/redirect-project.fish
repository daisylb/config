function redirect-project
	set old_url $argv[1]
set new_url $argv[2]
set dir (mktemp -d)
pushd $dir
git init .
echo -e "# Project moved!\nNew location: $new_url\n" > README.md
git add README.md
git commit -m "Redirect message"
git push -f $old_url master:master
popd
rm -rf $dir
end
