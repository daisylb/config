function sshcat
	set tf (mktemp -d)"/"(basename $argv[-1])
ssh $argv[1] cat $argv[2] > $tf
open $tf
end
