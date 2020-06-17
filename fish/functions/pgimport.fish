# Defined in /var/folders/dq/2_62hfn515l6g1_nscpfjjcw0000gn/T//fish.zUVUsA/pgimport.fish @ line 2
function pgimport
	if createdb $argv[2] -T template0
		pg_restore -Ox1e -d $argv[2] $argv[1]
		or dropdb $argv[2]
	end
end
