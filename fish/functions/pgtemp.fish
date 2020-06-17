function pgtemp
	set uuid (uuidgen)
createdb test-$uuid
pgcli test-$uuid
dropdb test-$uuid
end
