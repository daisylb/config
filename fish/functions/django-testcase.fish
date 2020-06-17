function django-testcase
	set uuid (uuidgen)
mkdir ~/django-testcase-$uuid
cd ~/django-testcase-$uuid
vf new -p (pyenv prefix 3.6.2)/bin/python django-testcase-$uuid
pip install django psycopg2
django-admin startproject myproject
cd myproject
django-admin startapp myapp
# TODO: add myapp to INSTALLED_APPS, set up DB in settings.py
end
