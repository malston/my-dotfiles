# login shell or osx non-login shell, just run .bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

BREWP=$(brew --cellar)
if [[ -d "$BREWP" ]] ; then	# running on a M? Apple CPU
   unset dirs
   mapfile -t dirs < <( shopt -s globstar; ls -1d "${BREWP}"/**/libexec/gnubin; )
   export PATH=$(IFS=: ; echo "${dirs[*]}"):$PATH
fi

if command -v mise 1> /dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
