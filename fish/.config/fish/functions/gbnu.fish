function gbnu
  if test (count $argv) -eq 0
    echo "Usage: gbnu <new branch name>"
    return 1
  end
  git fetch origin; or return 1

  set -l new_branch (slugify $argv)
  echo "$new_branch"

  git switch -c $new_branch --track origin/$new_branch; or return 1
  git pull; or return 1
  git push --set-upstream origin $new_branch; or return 1
end
