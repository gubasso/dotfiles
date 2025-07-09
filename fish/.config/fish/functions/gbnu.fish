function gbnu
  if test (count $argv) -eq 0
    echo "Usage: gbnu <new branch name>"
    return 1
  end
  git fetch origin; or return 1

  set -l new_branch (slugify $argv)

  # just check if remote branch exists
  if not git rev-parse --verify --quiet "origin/$new_branch" >/dev/null
    echo "Remote branch origin/$new_branch not found"
    return 1
  end

  git switch -c $new_branch; or return 1
  git pull --set-upstream origin $new_branch; or return 1
  git push --set-upstream origin $new_branch; or return 1
end
