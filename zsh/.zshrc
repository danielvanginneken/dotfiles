setopt INTERACTIVE_COMMENTS

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# fnm
eval "$(fnm env --use-on-cd)"

# History
HISTSIZE=100000
SAVEHIST=100000

# Git
alias gs="git status"
alias gp="git push"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline --graph --decorate -20"
alias gsw="git switch"
alias gswc="git switch -c"
alias gpl="git pull --ff-only"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Typescript
alias dev="pnpm dev"

# Docker
alias dps="docker ps"
alias dcu="docker compose up"
alias dcd="docker compose down"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Docker CLI completions
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit

command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# Machine-specific config (work tooling, tokens). Not in this repo.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Starship prompt (must stay last so it owns PROMPT)
eval "$(starship init zsh)"
