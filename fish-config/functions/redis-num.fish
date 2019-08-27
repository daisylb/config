function redis-num
	set name $argv[1]
set dbnum (redis-cli get "dbnum.$name")
if test $dbnum != ""
echo "redis:///$dbnum"
else
set dbnum (redis-cli incr dbnum.__unused)
redis-cli set dbnum.$name $dbnum
echo "redis:///$dbnum"
end
end
