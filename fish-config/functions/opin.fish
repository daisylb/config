# Defined in /var/folders/y9/392rp7rx4vvf9v2_np4fkl700000gn/T//fish.8Pomus/opin.fish @ line 2
function opin
	if set -q OP_SESSION_my
		echo "Already signed in"
	else
		op signin my | source
	end
end
