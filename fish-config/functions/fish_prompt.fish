# Defined in /var/folders/dq/2_62hfn515l6g1_nscpfjjcw0000gn/T//fish.duEm2p/fish_prompt.fish @ line 2
function fish_prompt --description 'Write out the prompt'
	set _status $status
	# Empty line
	echo " "

    if test $_status -ne 0
        echo (set_color -b red white) exit $_status (set_color normal)
        echo
    end

	if test $TERM_PROGRAM = "iTerm.app"
		echo -n -s (set_color -o green) "→" (set_color normal) ' '
		return
	end


	# Path
	# echo -s (set_color -o cyan) (prompt_pwd)

	# Git line
	set __prompt_git_branch (git branch ^/dev/null | sed -En 's/^\* ([^\(].*)/\1/p')
	set __prompt_git_ref_colour yellow
	if test "$__prompt_git_branch" = ""
		set __prompt_git_branch (git name-rev HEAD ^/dev/null | awk "{ print \$2 }")
		set __prompt_git_ref_colour red
	end
	if [ "$__prompt_git_branch" != '' ]
		echo -n -s (set_color $__prompt_git_ref_colour) $__prompt_git_branch " (" (git rev-parse --short HEAD) ")"
        set __prompt_git_staged (git status --porcelain ^/dev/null | sed -E 's/^([^?[:space:]])?.*/\1/g' | tr -d '\n')
		set __prompt_git_unstaged (git status --porcelain ^/dev/null | sed -E 's/^.([^[:space:]])?.*/\1/g' | tr -d '\n')
		if [ "$__prompt_git_staged$__prompt_git_unstaged" != '' ]
			echo -ns (set_color red) ' ' "$__prompt_git_unstaged:$__prompt_git_staged"
		else
			echo -ns (set_color green) ' ' 'clean'
		end
	end

	set git_ahead (git rev-list --count "@{u}"...HEAD ^/dev/null)
	if test "$git_ahead" != "" -a "$git_ahead" -gt 0
		echo -ns (set_color purple) ' ' $git_ahead'↑' 
	end
	echo # add newline at the end

	# Virtualenv line
	if set -q VIRTUAL_ENV
		echo -s (set_color yellow) "virtualenv: " (basename "$VIRTUAL_ENV")
	end
    
    # Gopath line
	if test $GOPATH != $GLOBAL_GOPATH
		echo -s (set_color yellow) "gopath: " (basename "$GOPATH")
	end

	# Pyenv line
	if pyenv local ^/dev/null >/dev/null
		echo -s (set_color yellow) "pyenv: " (pyenv local | tr "\n" " ")
	end

	# Docker Machine line
	if set -q DOCKER_MACHINE_NAME
		echo -s (set_color purple) "docker-machine: " $DOCKER_MACHINE_NAME
	end

	# Java line
	if set -q JAVA_HOME
		echo -s (set_color red) "java: " (echo $JAVA_HOME | egrep -o "[0-9][0-9.]+[0-9]")
	end

	if test $USER = root
		echo -n -s (set_color -b red) (set_color -o white) "root" (set_color normal) ' '
		if test $PWD != $HOME
			echo -n -s (set_color -o cyan) '@ '
		end
	end

	# 1Password line
	if set -q OP_SESSION_my
		echo -s (set_color blue) "1password logged in"
	end

	# Path
	echo -n -s (set_color -o cyan) (prompt_pwd)

	# Prompt
	echo -n -s (set_color -o green) "→" (set_color normal) ' '
end
