function cameracp
	rsync -rlt --progress /Volumes/NO\ NAME/DCIM /Users/adam/Desktop/camera\ dls
and echo "Labelling directory with date..."
and mv /Users/adam/Desktop/camera\ dls/DCIM /Users/adam/Desktop/camera\ dls/(date "+%Y-%m-%d")
and echo "Unmounting..."
and diskutil unmountDisk "NO NAME"
and echo "Done. Don't forget to check the import and format the SD on the camera."
end
