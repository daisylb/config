function prompt_pwd --description 'Print the current working directory, shortened to fit the prompt'
		switch "$PWD"
				case "$HOME"
					echo ''
				case '*'
					printf "%s" (echo $PWD|perl -pe "s|^$HOME\/||i" | sed -e 's-\(\.\{0,1\}[^/]\{4\}\)\([^/][^/]*\)/-\1…/-g') ' '
		end
end