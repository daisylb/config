# Defined in /var/folders/w7/5ysspdvj03qc3qmsrnn4b4hr0000gn/T//fish.AfJNzn/memorable-password.fish @ line 2
function memorable-password
	set wordfile /usr/share/dict/words
	if which shuf >/dev/null
		set words (shuf -n 4 $wordfile)
	else if which gshuf >/dev/null
		set words (gshuf -n 4 $wordfile)
	else
		echo "Install coreutils to make this faster!"
		set words (sort --random-sort $wordfile | head -n 4)
	end
	echo $words | tr "\n" " "
	echo
end
