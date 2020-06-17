function q
	if set -q TMPDIR
        touch $TMPDIR/q
	    tail -f $TMPDIR/q
	else
        touch /tmp/q
		tail -f /tmp/q
	end
end
