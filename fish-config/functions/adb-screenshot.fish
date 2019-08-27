function adb-screenshot
	adb shell screencap -p /sdcard/screencap.png
adb pull /sdcard/screencap.png $argv
adb shell rm /sdcard/screencap.png
end
