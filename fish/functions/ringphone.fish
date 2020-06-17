# Defined in /var/folders/44/6fpm7qvx0_v53gxknvqzf88h0000gn/T//fish.8C8lca/ringphone.fish @ line 2
function ringphone
	# To set ID, run `set -U ICLOUD_PHONE_ID <the ID>`
	icloud --username adam@brenecki.id.au --sound --device $ICLOUD_PHONE_ID
end
