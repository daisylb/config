# Defined in - @ line 0
function sha3-512 --description alias\ sha3-512\ python3.6\ -c\ \"from\ hashlib\ import\ sha3_512\;\ import\ sys\;\ f\ =\ open\(sys.argv\[1\],\ \'rb\'\)\;\ s\ =\ sha3_512\(\)\;\ s.update\(f.read\(\)\)\;\ print\(s.hexdigest\(\)\)\"
	python3.6 -c "from hashlib import sha3_512; import sys; f = open(sys.argv[1], 'rb'); s = sha3_512(); s.update(f.read()); print(s.hexdigest())" $argv;
end
