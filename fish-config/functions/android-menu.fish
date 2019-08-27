# Defined in - @ line 0
function android-menu --description 'alias android-menu adb shell input keyevent 82'
	adb shell input keyevent 82 $argv;
end
