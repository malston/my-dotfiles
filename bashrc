#!/usr/bin/env bash

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

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

if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then source "$HOME/.sdkman/bin/sdkman-init.sh"; fi

if [ -d "$HOME/.jenv/bin" ]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

export BASH_SILENCE_DEPRECATION_WARNING=1

function print_current_foundation() {
  lt_blue='\e[1;34m'
  clear='\e[0m'
  if [ -n "$FOUNDATION" ]; then
    echo -ne "$lt_blue""${FOUNDATION} ""$clear"
  fi
}

# enable direnv
if command -v direnv &> /dev/null; then
  export PS1='$(print_current_foundation)'$PS1
  eval "$(direnv hook bash)"
fi

# Go
if [ -d /usr/local/go ]; then
  export PATH=~/bin:~/.bin:~/go/bin:/usr/local/go/bin:$PATH
  export GOPATH=$HOME/workspace/go
  export PATH=$GOPATH/bin:$PATH
  # enable ginkgo focus in editors
  export GINKGO_EDITOR_INTEGRATION=true
fi

# GNU sed
if [ -d "$(brew --prefix)/opt/gnu-sed/libexec/gnubin" ]; then
  PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
fi

# GNU grep
if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
  PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
fi

# GNU find
if [ -d "$(brew --prefix)/opt/findutils/libexec/gnubin" ]; then
  PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"
fi

# Python
# See https://github.com/pyenv/pyenv
# See https://github.com/pyenv/pyenv-virtualenv
if command -v pyenv 1> /dev/null 2>&1; then
  eval "$(pyenv init -)"
  # We want to regularly go to our virtual environment directory
  # export WORKON_HOME=~/.virtualenvs

  # If in a given virtual environment, make a virtual environment directory
  # If one does not already exist
  # mkdir -p $WORKON_HOME

  # Activate the new virtual environment by calling this script
  # The workon and mkvirtualenv functions are in here
  # test -e "${HOME}/.pyenv/versions/$(pyenv version-name)/bin/virtualenvwrapper.sh" && source "${HOME}/.pyenv/versions/$(pyenv version-name)/bin/virtualenvwrapper.sh"
  eval "$(pyenv virtualenv-init -)"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if command -v op 1> /dev/null 2>&1; then
  source <(op completion bash)
fi
if command -v mise 1> /dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
