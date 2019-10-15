function android-screenshot
	set path /sdcard/screencap-(date -u +"%Y-%m-%dT%H:%M:%SZ").png
adb shell screencap -p $path
adb pull $path
adb shell rm $path
end
