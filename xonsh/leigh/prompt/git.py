def get_git_status(pwd):
    return ""
    commit = response.commit_hash[:7]
    branch = response.local_branch
    staged = "" if response.staged_count == "0" else f"S{response.staged_count}"
    unstaged = "" if response.unstaged_count == "0" else f"U{response.unstaged_count}"
    conflict = "" if response.conflict_count == "0" else f"C{response.conflict_count}"
    untracked = (
        "" if response.untracked_count == "0" else f"?{response.untracked_count}"
    )
    return " ".join(
        x for x in (commit, branch, staged, unstaged, conflict, untracked) if x
    )
