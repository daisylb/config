function npm
	if test -f yarn.lock
echo "There is a yarn.lock in this directory. If you're sure you want to run npm anyway, run `command npm`."
else
command npm $argv
end
end
