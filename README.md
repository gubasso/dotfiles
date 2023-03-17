# gubasso's dotfiles

My personal dotfiles, managed with [stow](https://www.gnu.org/software/stow/).[^1]

Common command:

- create all symlink from `.dotfiles` to `~`, for every dir inside dotfiles `*`

```
at ~/.dotfiles
---
stow -vt ~ *
```

**FLAGS:**

- `-n`: for checking, no do, just show before, simulation mode
- `-v`: verbose
- `-`: target directory must be `~`
- `*`: everything... all dirs inside .dotfiles
- `--adopt`: adopt all the conflicts... it moves the original under home dir, and copies it to our .dotfile directory

stow never overrides anything

## References:

[1]: [Sync your .dotfiles with git and GNU #Stow like a pro! - DevInsideYou](https://www.youtube.com/watch?v=CFzEuBGPPPg)
