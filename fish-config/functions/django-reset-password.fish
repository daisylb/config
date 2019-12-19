function django-reset-password
	set script "from django.contrib.auth import get_user_model

User = get_user_model()
for n in ('leigh', 'lbrenecki', 'adam', 'abrenecki'):
	try:
		u = User.objects.get(username=n)
	except User.DoesNotExist:
		continue
	else:
		break
else:
	u = User.objects.filter(is_superuser=True).first()
u.set_password('password')
u.is_active = True
u.save()
print(f'{u.username} / password')"
	if test -f Pipfile
		echo $script | pipenv run python manage.py shell
	else
		echo $script | python manage.py shell
	end
end
