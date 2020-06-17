function title
	if test (count $argv) -gt 0
		set -g FISH_TITLE $argv
	else
		set -ge FISH_TITLE
	end
end