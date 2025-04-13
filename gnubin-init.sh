#!/usr/bin/env bash

BREWP=$(brew --cellar)
if [[ -d "$BREWP" ]] ; then	# running on a M? Apple CPU
   unset dirs
   mapfile -t dirs < <( shopt -s globstar; ls -1d "${BREWP}"/**/libexec/gnubin; )
   export PATH=$(IFS=: ; echo "${dirs[*]}"):$PATH
fi

