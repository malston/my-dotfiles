# login shell or osx non-login shell, just run .bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

complete -C /opt/homebrew/bin/terraform terraform
