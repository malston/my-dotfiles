# homebrew
export PATH="$(brew --prefix)/bin:${PATH}"

# Home bin
export PATH="$HOME/bin:$PATH"

# Golang GOROOT
if [ -f ~/.asdf/plugins/golang/set-env.zsh ]; then
  . ~/.asdf/plugins/golang/set-env.zsh
  export ASDF_GOLANG_MOD_VERSION_ENABLED=true
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
