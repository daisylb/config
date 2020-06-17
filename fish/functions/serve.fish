function serve
	twistd -n web --path . $argv;
end