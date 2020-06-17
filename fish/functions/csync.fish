function csync
	if test (count $argv) -ne 1
        echo "Usage: csync <project>"
        return 1
    end
    pushd ~/config/$argv
    set -lx GIT_PAGER 'less -+F'
    git add .
    git diff --cached
    git commit
    git pull
    if test (git ls-files -u | wc -l) -eq 0
        git push
    else
        echo "There is an unsolved merge request. Fix it and push."
        echo "Run "(set_color -b)"popd"(set_color)" to return to where you were once fixed."
    return 2
    end
    popd
end
