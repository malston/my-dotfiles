# login shell or osx non-login shell, just run .bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

[[ -s "$HOME/my-dotfiles/gnubin-init.sh" ]] && source "$HOME/my-dotfiles/gnubin-init.sh"

if command -v mise 1> /dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
