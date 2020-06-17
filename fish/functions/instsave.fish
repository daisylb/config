function instsave
	pip install $argv[1]
pip freeze | grep -i "^$argv[1]==" >> requirements.txt
end
