# Defined in - @ line 0
function logout_test_account --description alias\ logout_test_account\ sudo\ kill\ -9\ \(ps\ awwwwux\ \|\ awk\ \'/test/\ \&\&\ /loginwind\[o\]w/\ \{print\ \$2\}\'\)
	sudo kill -9 (ps awwwwux | awk '/test/ && /loginwind[o]w/ {print $2}') $argv;
end
