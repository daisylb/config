function svgopen
	set svgf $TMPDIR/(uuidgen).svg
cat | tee $svgf >/dev/null
open -a "Google Chrome" $svgf
end
