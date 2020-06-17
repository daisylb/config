# Defined in /var/folders/w7/5ysspdvj03qc3qmsrnn4b4hr0000gn/T//fish.cH3XdU/sl-ui-watch.fish @ line 2
function sl-ui-watch
	while true
		watchman-wait ../sl-ui -p "**/*.js"
		pushd ../sl-ui
		npm pack
		popd
		npm i ../sl-ui/*.tgz
		rm -f ../sl-ui/*.tgz
	end
end
