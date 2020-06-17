function rdocker
	set -g RDOCKER_SOCKET (mktemp -d)/docker.sock
ssh -nNT -L $RDOCKER_SOCKET:/var/run/docker.sock $argv &
set -gx DOCKER_HOST unix:/$RDOCKER_SOCKET
end
