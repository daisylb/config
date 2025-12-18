abbr --position command gcan -- git commit --amend --no-edit
abbr --position command gfs -- git fetch origin master:master\; and git switch master -c
abbr --position command gfr -- git fetch origin master:master\; and git rebase master
abbr --position command gs -- git switch
abbr --position command gpf -- git push --force-with-lease
function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item
abbr --position command dbsetting -- ktdb run-template kraken-db-settings group:krakencore-prod group:krakencore-test --key
