function svg2icon
	if test (count $argv) -ne 2
echo "Usage: svg2icon <svg> <icon>"
return 1
end
set svg $argv[1]
set icon $argv[2]
set icon2x (echo $icon | sed -E "s/(\.[^.]+)\$/@2x\1/")
set icon3x (echo $icon | sed -E "s/(\.[^.]+)\$/@3x\1/")
rsvg-convert $svg > $icon
rsvg-convert -z 2 $svg > $icon2x
rsvg-convert -z 3 $svg > $icon3x
end
