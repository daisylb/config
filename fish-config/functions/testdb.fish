function testdb
	set dbname (uuidgen)
createdb $dbname
pgcli $dbname
dropdb $dbname
end
