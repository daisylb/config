function forget-known-host
	sed -i.bak -e $argv'd' ~/.ssh/known_hosts
end
