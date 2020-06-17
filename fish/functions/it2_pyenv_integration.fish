function it2_pyenv_integration --on-variable PWD --on-variable PYENV_VERSION
	iterm2_set_user_var pyenvVersion (pyenv version-name|tr ":" " ")
end
