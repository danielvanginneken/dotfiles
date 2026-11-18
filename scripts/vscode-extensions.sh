#!/usr/bin/env bash
# Compares the vscode lines in the Brewfile with the extensions VS Code has installed.
# Exits 1 on drift, so it can run before a commit. Extension ids are case-insensitive.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

wanted="$(sed -n 's/^vscode "\(.*\)"/\1/p' "$DOTFILES/Brewfile" | tr '[:upper:]' '[:lower:]' | sort)"
installed="$(code --list-extensions | tr '[:upper:]' '[:lower:]' | sort)"

extra="$(comm -13 <(echo "$wanted") <(echo "$installed"))"
missing="$(comm -23 <(echo "$wanted") <(echo "$installed"))"

show() {
  echo "$1"
  while IFS= read -r id; do echo "  $id"; done <<<"$2"
}

[ -z "$extra" ]   || show "installed, not in Brewfile:" "$extra"
[ -z "$missing" ] || show "in Brewfile, not installed:" "$missing"

if [ -z "$extra$missing" ]; then
  echo "ok      Brewfile and VS Code extensions match"
else
  exit 1
fi
