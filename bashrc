export EDITOR=vim
export SHELL=/usr/bin/bash
export TERM=xterm-256color

# platform specific script comes first!
platform_script=~/.bash_`uname | awk '{ print tolower($0) }'`
[ -f $platform_script ] && . $platform_script
unset platform_script

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

# Load bash completeions
enable_completions
