#!/usr/bin/env zsh

# starship prompt
eval "$(starship init zsh)"

# command editing options
setopt NO_CASE_GLOB
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL
setopt CORRECT_IGNORE_FILE='.*'

# history options
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# key bindings
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# vim mode
export KEYTIMEOUT=1

bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

autoload -Uz surround
zle -N delete-surround surround
zle -N change-surround surround
zle -N add-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M vicmd S add-surround

# add `ghq cd` subcommand
function ghq() {
  if [[ "$1" == "cd" ]]; then
    if [[ -z "$2" ]]; then
      ROOT_PATH=$(command ghq root)
      cd "$ROOT_PATH"
      return 0
    fi

    REPO_PATHS=($(command ghq list --full-path --exact "$2"))

    if [[ "${#REPO_PATHS[@]}" -eq 0 ]]; then
      echo "ghq: could not find repository '$2'"
      return 1
    elif [[ "${#REPO_PATHS[@]}" -gt 1 ]]; then
      echo "ghq: ambiguous repository name '$2'"
      return 1
    fi

    cd "$REPO_PATHS[1]"
  else
    command ghq $*
  fi
}

# tab completions
setopt COMPLETE_IN_WORD

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall