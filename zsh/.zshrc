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
alias gss="git status --short"
alias gd="git diff"
alias gds="git diff --staged"
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

alias ga="git add"
alias gaa="git add --all"
alias gau="git add --update"
alias gapa="git add --patch"

alias gc="git commit --verbose"
alias gca="git commit --verbose --all"
alias gcmsg="git commit --message"
alias gcam="git commit --all --message"
alias 'gcn!'="git commit --verbose --amend --no-edit"

alias gco="git checkout"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswm="git switch main"
alias gb="git branch"
alias gba="git branch --all"
alias gbd="git branch --delete"
alias gbgd='LANG=C git branch --no-color -vv | grep ": gone]" | cut -c 3- | awk "{print \$1}" | xargs git branch -d'

alias gf="git fetch"
alias gfa="git fetch --all --tags --prune"
alias gl="git pull"
alias gp="git push"
alias gpsup='git push --set-upstream origin "$(git branch --show-current)"'

alias gm="git merge"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gmff="git merge --ff-only"
alias gmom="git merge origin/main"

alias gsta="git stash push"
alias gstu="git stash --include-untracked"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gstaa="git stash apply"
alias gstd="git stash drop"
alias gsts="git stash show --patch"

alias gwip='git add --all && git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git log -1 --format=%s | grep -q -- "--wip--" && git reset HEAD~1'

alias grb="git rebase"
alias grbi="git rebase --interactive"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias grbs="git rebase --skip"
alias grbm="git rebase main"
alias grbom="git rebase origin/main"
alias gpf="git push --force-with-lease"

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
