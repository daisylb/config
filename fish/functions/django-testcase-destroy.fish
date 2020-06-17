function django-testcase-destroy
	if test (count $argv) -ne 1
echo "Usage: django-testcase-destroy <uuid>"
return 1
end
rm -rf ~/django-testcase-$argv
dropdb django-testcase-$argv
if set -q VIRTUAL_ENV; and test (basename $VIRTUAL_ENV) = django-testcase-$uuid
vf deactivate
end
vf rm django-testcase-$uuid
end
