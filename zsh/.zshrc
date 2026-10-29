# Shared across machines. Anything that only exists on one machine is guarded,
# so a missing tool is skipped instead of printing an error.
# Homebrew is set up in .zprofile; machine-only extras go in ~/.zshrc.local.

# Shell behaviour
setopt INTERACTIVE_COMMENTS    # allow comments at the prompt
setopt AUTO_CD                 # type a directory name to cd into it

# History: large and shared across tabs
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY        # save a timestamp with every command
setopt APPEND_HISTORY          # append instead of overwriting
setopt SHARE_HISTORY           # share history across sessions
setopt HIST_IGNORE_ALL_DUPS    # drop older duplicates
setopt HIST_IGNORE_SPACE       # skip commands typed with a leading space
setopt HIST_REDUCE_BLANKS      # strip superfluous blanks

# Completions
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit -C                    # -C skips the security check for a faster start
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive

# .NET
[ -d /usr/local/share/dotnet ] && export PATH="$PATH:/usr/local/share/dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

# Java (Homebrew openjdk@21)
if [ -d /opt/homebrew/opt/openjdk@21 ]; then
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
fi

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$HOME/.npm-global/bin:$PATH"

# bun
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# TeX Live (TinyTeX): pdflatex, xelatex, latexmk, tlmgr
[ -d "$HOME/Library/TinyTeX" ] && export PATH="$HOME/Library/TinyTeX/bin/universal-darwin:$PATH"

# Vite+ again, after .zprofile's Homebrew PATH, so its node wins over brew's node.
# Safe to re-source (it dedupes PATH) and it adds vp completions after compinit.
[ -f "$HOME/.config/vite-plus/env" ] && . "$HOME/.config/vite-plus/env"

command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# fzf: Ctrl-R history, Ctrl-T files, Alt-C cd; fd for file lists (respects .gitignore)
command -v fzf >/dev/null && source <(fzf --zsh)
command -v fd >/dev/null && export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git" FZF_CTRL_T_COMMAND="fd --type f --hidden --exclude .git"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Defaults
alias mkdir="mkdir -pv"

# Listing: eza when installed, plain ls with colours otherwise
if command -v eza >/dev/null; then
  alias ls="eza" ll="eza -l --git" la="eza -la --git" lt="eza --tree --level=2 --git-ignore"
else
  alias ls="ls -G" ll="ls -lhaG"
fi

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

# Typescript
alias dev="pnpm dev"

# Docker
alias dps="docker ps"
alias dcu="docker compose up"
alias dcd="docker compose down"

# macOS
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

# List what's installed but in none of this machine's Brewfiles (only lists, never removes).
# DOTFILES_MACHINE (personal or work) is set in ~/.zshrc.local.
brewcheck() {
  cat ~/dotfiles/Brewfile "$HOME/dotfiles/Brewfile.${DOTFILES_MACHINE:?set DOTFILES_MACHINE in ~/.zshrc.local}" \
    ~/Brewfile.local 2>/dev/null | HOMEBREW_NO_AUTO_UPDATE=1 brew bundle cleanup --file=- |
    sed '/^Would `brew cleanup`/,$d'   # drop the cache-cleanup listing after it
}

# Machine-specific config (work tooling, tokens). Not in this repo.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Plugins (brew install zsh-autosuggestions zsh-syntax-highlighting).
# syntax-highlighting has to be sourced after everything that defines widgets.
BREW_SHARE="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
[ -f "$BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh" ] &&
  source "$BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] &&
  source "$BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset BREW_SHARE

# Starship prompt (must stay last so it owns PROMPT)
command -v starship >/dev/null && eval "$(starship init zsh)"
