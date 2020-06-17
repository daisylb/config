function fucking_postgres
	rm /usr/local/var/postgres/postmaster.pid
launchctl start homebrew.mxcl.postgresql
end
