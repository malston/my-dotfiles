#!/usr/bin/env bash

# in case you want to change ps1 from a direnv file
export PS1='${CUSTOM_PS1}'$PS1

# Kubernetes prompt
if [ -f "$HOME/kube-ps1/kube-ps1.sh" ]; then
  # shellcheck disable=SC1091
  source "$HOME/kube-ps1/kube-ps1.sh"
  PS1=$PS1'$(kube_ps1)\$ '
fi

if [ -f "$HOME/.bash_extras" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.bash_extras"
fi
