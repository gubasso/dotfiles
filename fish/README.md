# dotfiles: fish

## Vendor completions

E.g. Poetry

```sh
# system/vendor:
# at: ~/.local/share/fish/vendor_completions.d/poetry.fish
poetry completions fish > ~/.local/share/fish/vendor_completions.d/poetry.fish
```

## Config structure

```
~/.config/fish/
├── config.fish
├── env/
│   ├── public/
│   │   ├── common.fish              # shared everywhere
│   │   └── hosts/
│   │       ├── tumblesuse.fish
│   │       └── valinor.fish
│   └── private/
│       ├── common.fish              # private everywhere (e.g. API keys)
│       └── hosts/
│           ├── tumblesuse.fish
│           └── valinor.fish
├── abbreviations/
│   ├── public/
│   │   ├── common.fish
│   │   └── hosts/
│   │       ├── tumblesuse.fish
│   │       └── valinor.fish
│   └── private/
│       ├── common.fish
│       └── hosts/
│           ├── tumblesuse.fish
│           └── valinor.fish
│
│     (below this line fish will auto-source conf.d, functions, completions)
│
├── conf.d/                           # snippets that fish will source automatically
│   ├── aliases.fish                  # any small `alias …` or `abbr --add …`
│   ├── completions.fish              # extra completions you want globally
│   └── fish_user_key_bindings.fish   # your fish_user_key_bindings function
├── functions/                        # larger reusable pieces of logic
│   ├── git-status.fish               # e.g. `function gs; git status; end`
│   └── fish_vi_key_bindings.fish
└── completions/                      # drop in third‐party completions here
    ├── docker.fish
    └── terraform.fish
```

