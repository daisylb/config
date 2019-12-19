# Defined in /var/folders/y9/392rp7rx4vvf9v2_np4fkl700000gn/T//fish.X3rc32/isomysqld.fish @ line 2
function isomysqld
	set dbversion $argv[1]
	set dbname $argv[2]
	set datadir $HOME/Library/Application\ Support/mysql/$dbversion/$dbname
	set basedir /usr/local/opt/mysql@$dbversion
	set tmpdir (mktemp -d)
	if test ! -d $datadir
		mkdir -p $HOME/Library/Application\ Support/mysql/$dbversion
		set install_db_args --datadir=$datadir --basedir=$basedir
		if test $dbversion -gt 5.6
			set install_db_args --insecure $install_db_args
		end
		command $basedir/bin/mysql_install_db $install_db_args
		or return 1
	end
	command $basedir/bin/mysqld_safe --datadir=$datadir --tmpdir=$tmpdir --basedir=$basedir
end
