#!/usr/bin/env bash

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

function print_current_foundation() {
  lt_blue='\e[1;34m'
  clear='\e[0m'
  if [ -n "$FOUNDATION" ]; then
    echo -ne "$lt_blue""${FOUNDATION} ""$clear"
  fi
}
export -f print_current_foundation

# platform specific script comes first!
platform_script=~/.bash_$(uname | awk '{ print tolower($0) }')
[ -f "$platform_script" ] && . "$platform_script"
unset platform_script

export EDITOR=vim
export TERM=screen-256color

# source aliases if present
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Arrow search history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Turn off bracketed paste
bind 'set enable-bracketed-paste off'

source "${__DIR}/completions"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
