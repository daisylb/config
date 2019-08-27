function javav
	if test (count $argv) -eq 1
        set -gx JAVA_HOME (/usr/libexec/java_home -v $argv)
    else
        set -e JAVA_HOME
    end
end
