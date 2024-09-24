# export PATH="/opt/homebrew/opt/go@1.17/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Golang GOROOT
if [ -f ~/.asdf/plugins/golang/set-env.zsh ]; then
  . ~/.asdf/plugins/golang/set-env.zsh
fi
export GOPATH=$HOME/workspace/go
export PATH="${GOBIN:-/opt/homebrew/opt/go/bin}:$PATH"

# GNU Sed
if [ -d /opt/homebrew/opt/gnu-sed/libexec/gnubin ]; then
  PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
fi

ARM_HOMEBREW_PREFIX="/opt/homebrew"
INTEL_HOMEBREW_PREFIX="/usr/local"
case "$(uname -m)" in
  "arm64")
    HOMEBREW_PREFIX=${ARM_HOMEBREW_PREFIX}
    # echo "Start Home Brew as ARM64 M1/M2 Silicon ✅"
    ;;
  "i386" | "x86_64")
    HOMEBREW_PREFIX=${INTEL_HOMEBREW_PREFIX}
    echo "Start Home Brew under Rosetta 2 Intel Emulation x86_64 🤔"
    ;;
  *)
    echo "Which Processor Architecture is that? [$(uname -m)]"
    ;;
esac
export PATH=${HOMEBREW_PREFIX}/bin:${PATH}
