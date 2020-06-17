# Defined in /var/folders/y9/392rp7rx4vvf9v2_np4fkl700000gn/T//fish.76eCLR/awslogin.fish @ line 2
function awslogin
	opin
	set item (op get item 746hzl53bffapomdbj7qrg3aqq)
	set -gx AWS_ACCESS_KEY_ID (echo $item | jq -r '.details.sections[].fields[]? | select(.t == "Access Key ID") | .v')
	set -gx AWS_SECRET_ACCESS_KEY (echo $item | jq -r '.details.sections[].fields[]? | select(.t == "Secret Access Key") | .v')
end
