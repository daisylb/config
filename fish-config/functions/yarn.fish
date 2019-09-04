# Defined in /var/folders/y9/392rp7rx4vvf9v2_np4fkl700000gn/T//fish.CAooDI/yarn.fish @ line 2
function yarn
	if test -f package-lock.json 
echo "There is a package-lock.json in this directory. If you're sure you want to run yarn anyway, run `command yarn`."
else
command npx yarn $argv
end
end
