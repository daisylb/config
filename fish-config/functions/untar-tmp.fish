function untar-tmp
	set FILE $PWD/$argv[1]
pushd (mktemp -d)
tar -xf $FILE
end
