# fzf
# ----- central ignore list -----
set -l fzf_skip_dirs \
  # VCS
  .git .hg .svn \
  # Python
  __pycache__ .venv venv .mypy_cache .pytest_cache .ruff_cache .tox .nox .pytype .pyre .hypothesis .ipynb_checkpoints __pypackages__ \
  # Python PMs / env managers (home or project state)
  .poetry .pdm .pyenv .conda .mamba .micromamba \
  # Node / JS tooling caches & deps (no build outputs)
  node_modules .yarn .yarn/cache .yarn/unplugged .pnpm .pnpm-store .npm .bun .parcel-cache .turbo .vite jspm_packages .node-gyp .deno \
  # Rust toolchains & caches (no 'target/')
  .cargo .rustup \
  # Go caches live under ~/.cache/go-build and $GOPATH/pkg/mod (name-only match is tricky)
  # (covered by '.cache' below; avoid excluding generic 'pkg' by name) \
  # JVM / Scala / Kotlin build & dep caches
  .gradle .m2 .ivy2 .sbt .coursier \
  # .NET / NuGet caches
  .nuget \
  # Infra / IaC
  .terraform .terragrunt-cache .ansible \
  # Containers / K8s / VMs
  .docker .kube .minikube .vagrant \
  # Editors / IDE
  .idea .vscode .vscode-server .emacs.d .doom.d \
  # Build accelerators / compilers
  .ccache \
  # Shell/env & generic caches
  .direnv .cache \
  # Linux system-ish names that are safe to skip by NAME
  proc sys dev lost+found \
  # Desktop runtime caches (home)
  .nv .var \
  # XDG ~/.local (name-only safe subset)
  Trash flatpak pipx virtualenvs Steam

# Build args for fd (-E dir …) and a comma list for fzf’s walker
set -l fd_excludes
for d in $fzf_skip_dirs
  set -a fd_excludes -E $d
end
set -l walker_skip (string join , $fzf_skip_dirs)

# Preview helpers
set -l tree_cmd 'eza --tree --all --git-ignore --ignore-glob ".git" --color=always'
set -l bat_cmd  "bat -n --color=always"

# Source command for fzf (used by Ctrl-T and generally)
# fd respects .gitignore/.ignore by default; we add explicit excludes for noisy dirs
set -x FZF_DEFAULT_COMMAND "fd --hidden --follow --color=always $fd_excludes"

# Global fzf opts; walker-skip only applies when fzf’s internal walker is used
# removed those flags: --select-1 --exit-0
set -x FZF_DEFAULT_OPTS "
  --walker-skip \"$walker_skip\"
  --no-height
  --layout=reverse
  --ansi
  --inline-info"

## CTRL_T (files)
set -l preview "begin; $bat_cmd {} 2>/dev/null; or $tree_cmd {} 2>/dev/null; end | head -200"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_CTRL_T_OPTS "--preview \"$preview\""

## ALT_C (dirs)
# Reuse the same fd source but restrict to directories; excludes still apply
set -x FZF_ALT_C_COMMAND "$FZF_DEFAULT_COMMAND -t d"
set -x FZF_ALT_C_OPTS "--preview \"$tree_cmd {} | head -200\""

## CTRL_R (history)
set -x FZF_CTRL_R_OPTS "
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {} | xclip -selection clipboard)+abort'
  --color header:italic
  --header 'Press ^y to copy command into clipboard'"

# fzf keybindings for fish
fzf --fish | source
