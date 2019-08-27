function freeze-install
	pip-compile --output-file requirements-dev.txt requirements-dev.in
pip-compile --output-file requirements.txt requirements.in 
pip install -r requirements.txt -r requirements-dev.txt
end
