# PS4='+ $EPOCHREALTIME\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

# login shell or osx non-login shell, just run .bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

enable_bash_it
# enable_completions

# set +x
# exec 2>&3 3>&-