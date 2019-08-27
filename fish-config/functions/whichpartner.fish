# Defined in - @ line 0
function whichpartner --description alias\ whichpartner\ python\ -c\ \'import\ random\;\ print\(random.choice\(\(\"jess\",\ \"kit\"\)\)\)\'
	python -c 'import random; print(random.choice(("jess", "kit")))' $argv;
end
