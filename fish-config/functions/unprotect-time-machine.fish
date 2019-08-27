function unprotect_time_machine
	sudo sh -c "chown -R $USER .; chgrp -R staff .; xattr -rd com.apple.metadata:_kTimeMachineNewestSnapshot .; xattr -rd com.apple.metadata:_kTimeMachineOldestSnapshot ."
end