function fixpb --description "Fix pasteboard contents from Office:mac and other sources"
	pbpaste | tr '\r\n' '\n' | tr '\r' '\n' | tr '•' '-' | tr '“' '"' | tr '”' '"' | tr '​' '\t' | pbcopy
end