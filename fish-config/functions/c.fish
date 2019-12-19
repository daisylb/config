function c
	if test (count $argv) -eq 0
set dest (realpath .)
else
set dest (realpath $argv[1])
end
if test -f $dest/../(basename $dest).code-workspace
code $dest/../(basename $dest).code-workspace
else
code $dest
end
end
