# platform specific script comes first!
platform_script=~/.bash_`uname | awk '{ print tolower($0) }'`
[ -f $platform_script ] && . $platform_script
unset platform_script

export EDITOR=vim
export TERM=screen-256color

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# source bash_completion.d
if [ -d /usr/local/etc/bash_completion.d ]; then
    for line in $(echo /usr/local/etc/bash_completion.d/*.sh); do
        source $line
    done
fi

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

eval $(dircolors ~/.dir_colors)
eval "$(direnv hook bash)"

# chsh -s $(which zsh)
zsh

