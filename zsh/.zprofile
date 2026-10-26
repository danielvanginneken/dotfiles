# Docker Desktop CLI
export PATH="$PATH:$HOME/.docker/bin"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
