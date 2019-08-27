function config
    if test (count $argv) -ne 2
        echo "Usage: config [diff|commit-all|push|pushd] [config-dir]"
        return
    end

    pushd ~/config/$argv[2]

    switch $argv[1]
        case diff
            git diff
        case commit-all
            git add .
            git commit
        case pushd
        case push
            git push
        case '*'
            echo "I don't know how to" $argv[2]
    end

	if test $argv[1] != pushd
	    popd
	end
end