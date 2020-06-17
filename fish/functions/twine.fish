# Defined in /var/folders/w7/5ysspdvj03qc3qmsrnn4b4hr0000gn/T//fish.wG4G69/twine.fish @ line 2
function twine
	if not set -gq OP_SESSION_my
		opin
		set OP_IN
	end
	set pypi_item (op get item nqvbhuaz6zfjlcpwnsx4sb6gxa)
	env TWINE_USERNAME=(echo $pypi_item | jq -r '.details.fields[] | select(.name == "username") | .value') \
		TWINE_PASSWORD=(echo $pypi_item | jq -r '.details.fields[] | select(.name == "password") | .value') \
		command twine $argv
	if set -q OP_IN
		opout
	end
end
