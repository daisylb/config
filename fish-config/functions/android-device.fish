# Defined in /var/folders/0h/v25x4ks55g1bb83jvj4jjltc0000gn/T//fish.8zQcXV/android-device.fish @ line 1
function android-device
	set device_host $argv[1]
set serial (eval echo '$'ANDROID_SERIAL_USB_(echo $device_host | tr '.' '_'))
adb -s $serial tcpip 11881
adb connect $device_host:11881
set -gx ANDROID_SERIAL $device_host:11881
end
