function ssh-copy-id
	switch (count $argv)
		case 1
			set server $argv[1]
			set port 22
			set keyfile ~/.ssh/id_rsa.pub
		case 2
			set server $argv[1]
			if test -z (echo $argv[2] | tr -d "[0-9]")
				# second arg is a number
				set port $argv[2]
				set keyfile ~/.ssh/id_rsa.pub
			else
				set port 22
				set keyfile $argv[2]
			end
		case 3
			set server $argv[1]
			set port $argv[2]
			set keyfile $argv[3]
		case '*'
			echo 'Error: please supply at least one argument'
			echo 'Usage: ssh-copy-id <server> [<port>] [<pubkeyfile>]'
			return 1
	end
	if test ! -f $keyfile
		echo "Keyfile $keyfile doesn't exist."
		return 1
	end
	set cmd "sh -c 'mkdir -p .ssh; key=\""(cat $keyfile)"\"; echo \$key >> .ssh/authorized_keys; echo \$key >> .ssh/authorized_keys2; chmod 700 .ssh/; chmod 600 .ssh/authorized_keys .ssh/authorized_keys2'"
	ssh $server -p $port $cmd
end