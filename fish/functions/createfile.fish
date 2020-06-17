# Defined in /var/folders/w7/5ysspdvj03qc3qmsrnn4b4hr0000gn/T//fish.sR77TT/createfile.fish @ line 2
function createfile
	mkdir -p (dirname $argv[1])
touch $argv[1]
end
