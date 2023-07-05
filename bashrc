export EDITOR=vim
export SHELL=/usr/bin/bash
export TERM=xterm-256color

# platform specific script comes first!
platform_script=~/.bash_`uname | awk '{ print tolower($0) }'`
[ -f $platform_script ] && . $platform_script
unset platform_script

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

# Load bash completions
enable_completions

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
