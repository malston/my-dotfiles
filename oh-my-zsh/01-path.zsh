# homebrew
export PATH="$(brew --prefix)/bin:${PATH}"

# Home bin
export PATH="$HOME/bin:$PATH"

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# Created by `pipx` on 2024-01-04 03:26:13
export PATH="$PATH:/Users/$USER/.local/bin"

# Golang GOROOT
if [ -f ~/.asdf/plugins/golang/set-env.zsh ]; then
  . ~/.asdf/plugins/golang/set-env.zsh
fi

# Go
export PATH="$HOME/bin:$HOME/go/bin:$PATH"
export GOPATH=$HOME/workspace/go
export PATH="${GOBIN:-$(brew --prefix)/opt/go/bin}:$PATH"

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

# My scripts
export PATH="$HOME/workspace/my-scripts:$PATH"
export PATH="$HOME/workspace/k8s-scripts:$PATH"
