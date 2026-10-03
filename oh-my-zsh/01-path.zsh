# homebrew
export PATH="$(brew --prefix)/bin:${PATH}"
export PATH="$(brew --prefix)/sbin:${PATH}"

# Home bin
export PATH="$HOME/bin:$PATH"

# Java
export JAVA_HOME="/opt/homebrew/opt/openjdk"
if [ -f "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk" ]; then
  export JAVA_HOME=/opt/homebrew/opt/openjdk@25
fi
# point the java wrappers and IDEs at it
# sudo ln -sfn /opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-25.jdk
# or put it first on your PATH
export PATH="$JAVA_HOME/bin:$PATH"

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

# LibreOffice
if [ -f "/Applications/LibreOffice.app/Contents/MacOS/soffice" ]; then
  export PATH="/Applications/LibreOffice.app/Contents/MacOS/soffice:$PATH"
fi

# Caveman CLI (real binaries, not the mise-managed node global install)
if [ -d "$HOME/.caveman/bin" ]; then
  export PATH="$HOME/.caveman/bin:$PATH"
fi
