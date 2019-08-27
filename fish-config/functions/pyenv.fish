function pyenv
	if test $argv[1] = "install"
env CFLAGS="-I"(brew --prefix openssl)"/include" \
LDFLAGS="-L"(brew --prefix openssl)"/lib" \
command pyenv $argv
else
command pyenv $argv
end
end
