function gofish
    if test (count $argv) -eq 1
        pushd $argv[1]
        set -x GOPATH (pwd)
        popd
    else
        set -x GOPATH $GLOBAL_GOPATH
    end
end