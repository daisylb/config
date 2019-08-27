function n
	set OLD_PATH $PATH
set PATH ./node_modules/.bin $PATH
eval $argv
set PATH $OLD_PATH
end
