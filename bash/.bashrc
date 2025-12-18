# ~/.bashrc

# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# vi editing mode (interactive only)
set -o vi

# prompt (interactive only)
PS1='\W > '
export PS1

# fzf (interactive only)
# Guard in case fzf is not installed in some environments (containers)
if [ -r /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
fi
if [ -r /usr/share/fzf/completion.bash ]; then
  source /usr/share/fzf/completion.bash
fi

# aliyun-cli completion (only if installed)
if command -v aliyun >/dev/null 2>&1; then
  complete -C "$(command -v aliyun)" aliyun
fi
