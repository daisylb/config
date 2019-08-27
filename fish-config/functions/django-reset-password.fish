function django-reset-password
	set script "from django.contrib.auth.models import User
u = User.objects.filter(is_superuser=True).first()
u.set_password('password')
print(f'{u.username} / password')"
if test -f Pipfile
echo $script | pipenv run python manage.py shell
else
echo $script | python manage.py shell
end
end
