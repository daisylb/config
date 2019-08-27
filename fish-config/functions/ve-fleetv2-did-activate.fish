function ve-fleetv2-did-activate --on-event virtualenv_did_activate:fleetv2
	set -x DJANGO_SETTINGS_MODULE fleet.settings
set -x PYTHONPATH /home/adam/fleet
end
