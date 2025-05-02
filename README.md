# gubasso's dotfiles

My personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## Overview

Managing your shell and application configurations (“dotfiles”) with Stow allows you to:

* Keep configurations versioned in Git.
* Easily deploy consistent setups across machines.
* Modularize per-application configs.

This guide covers both non-root (“user”) and root (“system”) setups.

## Prerequisites

1. **Git**: for cloning this repo.
2. **GNU Stow**:

   ```bash
    # Debian/Ubuntu
    sudo apt update
    sudo apt install stow

    # Arch Linux
    sudo pacman -Syu stow

    # macOS (Homebrew)
    brew install stow
   ```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/gubasso/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Stowing Packages (User-Level)

* **Dry run** to preview changes:

  ```bash
  stow -nvt ~ *
  ```

  * `-n`/`--no` : show what would happen (don't apply).
  * `-v`/`--verbose` : detailed output.
  * `-t ~`/`--target=~` : where to create symlinks.
  * `*` : all packages (every directory).

* **Apply** symlinks:

  ```bash
  stow -vt ~ *
  ```

## Usage Examples

* Link a single package (e.g., Alacritty):

  ```bash
  stow -vt ~ alacritty
  ```

  This creates symlinks from:

  ```text
  ~/.dotfiles/alacritty/.config/alacritty/*.yml → ~/.config/alacritty/*.yml
  ```

* Link multiple packages:

  ```bash
  stow -vt ~ bash nvim git
  ```

## System-Level (Root) Setup

When you need to manage system configs (e.g., services in `/etc/systemd`), perform Stow under root:

**Stow to `/`**:

   ```bash
   sudo stow -vt / systemd_root bin_root shell_root
   ```

   * `-t /` : target is the filesystem root.
   * `--adopt` : (optional) move existing files into the repo before linking:

     ```bash
     sudo stow -vt / --adopt systemd_root
     ```

## Real-World Examples

Based on your repository tree:

* **Alacritty**:

  ```bash
  cd ~/.dotfiles
  stow -vt ~ alacritty
  ```

* **Custom Scripts** (`bin`):

  ```bash
  stow -vt ~ bin
  ```

* **User Shell Configs** (`bash`, `zsh`):

  ```bash
  stow -vt ~ bash zsh
  ```

* **Systemd Services** (`systemd_root`):

  ```bash
  sudo stow -vt / systemd_root
  ```

* **Root Shell Environments** (`shell_root`):

  ```bash
  sudo stow -vt / shell_root
  ```

## Troubleshooting

* **Conflict Detected**:
  If Stow reports existing files not owned by it, you can:

  ```bash
  stow -nvt ~ --adopt bash
  ```

  to move originals into `~/.dotfiles/bash/` then retry.

* **Inspecting Symlinks**:

  ```bash
  find ~/.config -maxdepth 2 -type l
  ```
---

## References

[^1]: [Sync your .dotfiles with Git and GNU Stow like a pro! - DevInsideYou](https://www.youtube.com/watch?v=CFzEuBGPPPg)
