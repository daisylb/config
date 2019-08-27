function yarn
	if test -f package-lock.json 
echo "There is a package-lock.json in this directory. If you're sure you want to run yarn anyway, run `command yarn`."
else
command yarn $argv
end
end
