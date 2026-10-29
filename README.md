# dotfiles

My macOS setup: zsh, git, Starship, gh, VS Code and Homebrew.

## Install

```sh
git clone git@github.com:danielvanginneken/dotfiles.git ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile
brew bundle --file ~/dotfiles/Brewfile.personal   # or Brewfile.work
~/dotfiles/install.sh
```

`Brewfile` holds what every machine gets. `Brewfile.personal` and
`Brewfile.work` hold the rest per machine.

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
| `ssh/config`             | `~/.ssh/config`                                        |
| `vscode/settings.json`   | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `vscode/snippets/`       | `~/Library/Application Support/Code/User/snippets/`    |

## Rectangle

`rectangle/RectangleConfig.json` is copied, not linked: Rectangle imports
`~/Library/Application Support/Rectangle/RectangleConfig.json` on launch and then
renames it. Changed a shortcut in Rectangle's settings? Export it over the repo
file, or the next `install.sh` run puts the old one back.

All shortcuts use ⌃⌥ (Control + Option):

| Keys                  | Action                                         |
| :-------------------- | :--------------------------------------------- |
| ← → ↑ ↓               | Half. Press again: 2/3, then 1/3               |
| U I / J K             | Top-left, top-right / bottom-left, bottom-right |
| D F G                 | First, center, last third                      |
| E R T                 | First, center, last two-thirds                 |
| Return                | Maximize                                       |
| ⇧ Return              | Maximize height                                |
| C                     | Center                                         |
| − =                   | Smaller, larger                                |
| Delete                | Restore                                        |
| ⇧ ← → ↑ ↓             | Move to that edge, keep the size               |
| ⌘ ← →                 | Previous, next display                         |

## Machine-specific config

Anything tied to one machine (email, tokens, work tooling) lives in local files
that are never committed:

- `~/.zshrc.local`: sourced at the end of `.zshrc`
- `~/.ssh/config.local`: included first by `ssh/config` (hosts, keys, agent, legacy ciphers)
- `~/.gitconfig.local`: included from `.gitconfig` (`user.email`, commit signing, credential helper)
- `~/Brewfile.local`: extra packages, `brew bundle --file ~/Brewfile.local`

## Secret check

This repo is public. `.githooks/pre-commit` (enabled by `install.sh`) blocks
commits that stage `*.local` / `.env` / key files, token-shaped strings, or any
word listed in `~/.dotfiles-denylist` (one per line, never committed: put
company or internal names there). It prints file names only, never the match.
Bypass with `git commit --no-verify` when you are sure.
