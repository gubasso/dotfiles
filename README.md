# gubasso's dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), enhanced with the `dots` wrapper script.

## Quick Start

```bash
# Clone repositories
git clone https://github.com/gubasso/dotfiles.git ~/.dotfiles
git clone git@gitlab.com:gubasso/dotfiles-private.git ~/.dotfiles-private  # optional

# Deploy the dots command first
cd ~/.dotfiles && stow -vt ~ bin

# Sync all packages
dots --sync

# Or deploy individual packages
dots fish nvim starship
```

## The `dots` Command

The `dots` script wraps GNU Stow with features tailored for this dotfiles setup.

### Basic Usage

```bash
dots <package>...           # Stow packages
dots -D <package>...        # Unstow packages
dots -R <package>...        # Restow (unstow + stow)
dots --list                 # List available packages
dots --sync                 # Stow all packages
```

### Options

| Option | Description |
|--------|-------------|
| `-n, --dry-run` | Preview changes without applying |
| `-y, --yes` | Skip confirmation prompt |
| `-q, --quiet` | Minimal output (still prompts unless `-y`) |
| `-v, --verbose` | Verbose output (repeatable: `-vv`) |
| `-p, --public` | Only operate on `~/.dotfiles` |
| `-P, --private` | Only operate on `~/.dotfiles-private` |
| `--no-hooks` | Skip hook scripts and dependency resolution |
| `--version` | Show version |
| `-h, --help` | Show help |

### Examples

```bash
# Preview what would happen
dots -n fish

# Stow with verbose output
dots -v nvim kitty

# Only stow from public repo
dots -p fish

# Restow after editing configs
dots -R fish

# Silent execution for scripts
dots -q -y fish nvim
```

### Features

**Ignores documentation files**: All `*.md` files (README, CLAUDE.md, etc.) are automatically excluded.

**Auto-detects target**: Packages containing `etc/`, `usr/`, `var/`, or `opt/` directories are automatically stowed to `/` (with sudo). All others stow to `~`.

**Dual-repo merge**: When both `~/.dotfiles` and `~/.dotfiles-private` have the same package, `dots` automatically resolves conflicts by converting stow's "folded" directory symlinks into real directories with individual file symlinks.

### Hooks

Packages can include a `.hooks/` directory with:

| File | Purpose |
|------|---------|
| `depends` | List of package dependencies (one per line) |
| `pre-stow` | Script run before stowing |
| `post-stow` | Script run after stowing |
| `pre-unstow` | Script run before unstowing |
| `post-unstow` | Script run after unstowing |

Dependencies are automatically resolved for `stow` and `sync` operations. Use `--no-hooks` to skip all hook processing.

**Example `.hooks/depends`:**
```
shell
starship
```

## Repository Structure

Each top-level directory is a stow "package" that mirrors the target filesystem:

```
~/.dotfiles/
├── fish/
│   └── .config/fish/       → ~/.config/fish/
├── nvim/
│   └── .config/nvim/       → ~/.config/nvim/
├── bin/
│   └── .local/bin/         → ~/.local/bin/
├── shell/
│   └── .profile            → ~/.profile
└── greetd/                  # System package
    └── etc/greetd/         → /etc/greetd/
```

### Package Types

| Type | Example Structure | Target | Requires |
|------|-------------------|--------|----------|
| User | `.config/`, `.local/`, `.*` | `~` | User |
| System | `etc/`, `usr/` | `/` | sudo |

### Dual Repository Setup

- **`~/.dotfiles`** (public): Configs safe to share publicly
- **`~/.dotfiles-private`** (private): Secrets, API keys, machine-specific overrides

Both use the same structure. Private configs can extend or override public ones for the same package.

## Manual Stow

For edge cases, you can use stow directly:

```bash
cd ~/.dotfiles

# Preview changes
stow -nvt ~ <package>

# Apply symlinks
stow -vt ~ <package>

# System-level package
sudo stow -vt / <package>

# Adopt existing files into repo
stow -vt ~ --adopt <package>
```
