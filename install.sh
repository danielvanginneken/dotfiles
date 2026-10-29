#!/usr/bin/env bash
# Symlinks the files in this repo into $HOME.
# Existing real files are moved to <file>.bak-<timestamp> first; re-running is safe.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak-$STAMP"
    echo "backup  $dest -> $dest.bak-$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "linked  $dest -> $src"
}

link zsh/.zshenv             "$HOME/.zshenv"
link zsh/.zprofile           "$HOME/.zprofile"
link zsh/.zshrc              "$HOME/.zshrc"
link git/.gitconfig          "$HOME/.gitconfig"
link git/ignore              "$HOME/.config/git/ignore"
link starship/starship.toml  "$HOME/.config/starship.toml"
link gh/config.yml           "$HOME/.config/gh/config.yml"
link ssh/config              "$HOME/.ssh/config"
link vscode/settings.json    "$HOME/Library/Application Support/Code/User/settings.json"
link vscode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
link vscode/snippets         "$HOME/Library/Application Support/Code/User/snippets"

# Rectangle imports this file on launch and then renames it, so copy instead of link.
mkdir -p "$HOME/Library/Application Support/Rectangle"
cp "$DOTFILES/rectangle/RectangleConfig.json" "$HOME/Library/Application Support/Rectangle/RectangleConfig.json"
echo "copied  Rectangle config (quit and reopen Rectangle to import it)"

# Local files are never in the repo; create empty ones so the includes resolve.
[ -f "$HOME/.zshrc.local" ]     || touch "$HOME/.zshrc.local"
[ -f "$HOME/.ssh/config.local" ] || touch "$HOME/.ssh/config.local"
[ -f "$HOME/.gitconfig.local" ] || printf '[user]\n\temail = you@example.com\n' > "$HOME/.gitconfig.local"

# Secret check for this (public) repo: hooks live in .githooks, not .git/hooks.
git -C "$DOTFILES" config core.hooksPath .githooks
echo "hooks   $DOTFILES/.githooks active"
