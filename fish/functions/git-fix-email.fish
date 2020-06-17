function git-fix-email
	git filter-branch --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "'$argv[1]'" ]; then
     GIT_AUTHOR_EMAIL='$argv[2]';
     GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL;
fi' -- --all
end
