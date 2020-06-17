function fish_title
	if set -gq FISH_TITLE
		echo $FISH_TITLE
	else
		echo (basename $PWD) ":" $_
	end
end