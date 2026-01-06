# homebrew
export PATH="$(brew --prefix)/bin:${PATH}"
export PATH="$(brew --prefix)/sbin:${PATH}"

# Home bin
export PATH="$HOME/bin:$PATH"

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# Created by `pipx` on 2024-01-04 03:26:13
export PATH="$PATH:/Users/$USER/.local/bin"

# Golang GOROOT
# if [ -f ~/.asdf/plugins/golang/set-env.zsh ]; then
#   . ~/.asdf/plugins/golang/set-env.zsh
#   export ASDF_GOLANG_MOD_VERSION_ENABLED=true
# fi

# Go
export PATH="$HOME/bin:$HOME/go/bin:$PATH"
export PATH="${GOBIN:-$(brew --prefix)/opt/go/bin}:$PATH"
if [ -d "$HOME/workspace" ]; then
  GOPATH=$HOME/workspace/go
else
  GOPATH=$HOME/go
fi

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

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

# ged
# GNU ed (ged) is a line-oriented text editor.
if [ -d "$(brew --prefix)/opt/ed/bin" ]; then
  PATH="/opt/homebrew/opt/ed/bin:$PATH"
fi

# VMware OVF Tool
if [ -d "/Applications/VMware OVF Tool" ]; then
  PATH="/Applications/VMware OVF Tool:$PATH"
fi

if [ -d "$HOME/workspace/my-scripts" ]; then
  PATH="$HOME/workspace/my-scripts:$PATH"
fi

if [ -d "$HOME/workspace/k8s-scripts" ]; then
  PATH="$HOME/workspace/k8s-scripts:$PATH"
fi

if [ -d "$HOME/workspace/homelab/scripts" ]; then
  PATH="$HOME/workspace/homelab/scripts:$PATH"
fi

# bun
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi
