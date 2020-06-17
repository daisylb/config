function android-keepawake
	while true
echo "Sending tap"
adb shell input tap 0 0
sleep 10
end
end
