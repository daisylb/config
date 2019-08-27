# Defined in - @ line 0
function tempdir --description 'alias tempdir pushd (mktemp -d)'
	pushd (mktemp -d) $argv;
end
