#!/usr/bin/env bash
# Compares the vscode lines in the Brewfile with the extensions VS Code has installed.
# Exits 1 on drift, so it can run before a commit. Extension ids are case-insensitive.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

wanted="$(sed -n 's/^vscode "\(.*\)"/\1/p' "$DOTFILES/Brewfile" | tr '[:upper:]' '[:lower:]' | sort)"
installed="$(code --list-extensions | tr '[:upper:]' '[:lower:]' | sort)"

extra="$(comm -13 <(echo "$wanted") <(echo "$installed"))"
missing="$(comm -23 <(echo "$wanted") <(echo "$installed"))"

[ -z "$extra" ]   || { echo "installed, not in Brewfile:"; echo "$extra" | sed 's/^/  /'; }
[ -z "$missing" ] || { echo "in Brewfile, not installed:"; echo "$missing" | sed 's/^/  /'; }

if [ -z "$extra$missing" ]; then
  echo "ok      Brewfile and VS Code extensions match"
else
  exit 1
fi
