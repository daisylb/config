function rn-release
	pushd android
./gradlew assembleRelease
adb install app/build/outputs/apk/release/app-release.apk
popd
end
