#!/bin/bash
# Script to add Homebrew GNU utilities to PATH
# Compatible with both zsh and bash

BREWP=$(brew --cellar)
if [[ -d "$BREWP" ]]; then  # running on a system with Homebrew installed
    # Detect shell type and use appropriate array handling
    dirs=()
    while IFS= read -r dir; do
        dirs+=("$dir")
    done < <(find "${BREWP}" -path "*/libexec/gnubin" -type d 2>/dev/null)

    # Add the GNU directories to PATH if any were found
    if (( ${#dirs[@]} > 0 )); then
        # Join array with colons for PATH
        gnu_paths=$(IFS=:; echo "${dirs[*]}")
        export PATH="${gnu_paths}:$PATH"
    fi
fi
