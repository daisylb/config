function cp3run
	set build_output (mktemp)
if ant >$build_output ^&1
java -cp $PWD/build/classes $argv
else
cat $build_output
end
rm $build_output
end
