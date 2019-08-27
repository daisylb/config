function archive-old
    if test (count $argv) -ne 1
        echo "Need to supply a directory to archive."
        return
    else if test ! -d $argv[1]
        echo "That's not a directory."
        return
    end

    set sourcedir $argv[1]
    set destfile (echo $sourcedir | sed -e "s|/\$||g" -e "s|\$|.txz|g")

    tar -cJf $destfile --options 'xz:compression-level=9' $sourcedir
end