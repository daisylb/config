# Defined in - @ line 0
function randport --description alias\ randport\ python\ -c\ \'from\ random\ import\ randint\;\ print\(randint\(10000,\ 65536\)\)\'
	python -c 'from random import randint; print(randint(10000, 65536))' $argv;
end
