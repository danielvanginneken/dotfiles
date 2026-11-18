# dotfiles

My macOS setup: zsh, git, Starship, gh, VS Code and Homebrew.

## Install

```sh
git clone git@github.com:danielvanginneken/dotfiles.git ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile
~/dotfiles/install.sh
```

`install.sh` symlinks every file into place. Existing files are moved to
`<file>.bak-<timestamp>` first, so it is safe to re-run.

## Layout

| Repo path                | Linked to                                              |
| :----------------------- | :----------------------------------------------------- |
| `zsh/.zshenv`            | `~/.zshenv`                                            |
| `zsh/.zprofile`          | `~/.zprofile`                                          |
| `zsh/.zshrc`             | `~/.zshrc`                                             |
| `git/.gitconfig`         | `~/.gitconfig`                                         |
| `git/ignore`             | `~/.config/git/ignore`                                 |
| `starship/starship.toml` | `~/.config/starship.toml`                              |
| `gh/config.yml`          | `~/.config/gh/config.yml`                              |
| `vscode/settings.json`   | `~/Library/Application Support/Code/User/settings.json` |

## Machine-specific config

Anything tied to one machine (email, tokens, work tooling) lives in local files
that are never committed:

- `~/.zshrc.local`: sourced at the end of `.zshrc`
- `~/.gitconfig.local`: included from `.gitconfig` (put `user.email` here)
- `~/Brewfile.local`: extra packages, `brew bundle --file ~/Brewfile.local`

## VS Code

The repo is the source of truth. `vscode/settings.json` is linked into place and
VS Code's own Settings Sync is off for settings, so the two cannot overwrite each other.
Extensions are listed in the `Brewfile`; check for drift with:

```sh
scripts/vscode-extensions.sh
```

Extensions you only want on one machine go in `~/Brewfile.local`. VS Code profiles are
not covered: only the default profile is managed here.
