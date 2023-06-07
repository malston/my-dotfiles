export PATH="/opt/homebrew/opt/go@1.17/bin:$PATH"
export PATH="/Users/malston/bin:/Users/malston/go/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# export KUBECONFIG="$HOME/workspace/tanzu-quickstart/homelab_kubeconfig.yaml"

ARM_HOMEBREW_PREFIX="/opt/homebrew"
INTEL_HOMEBREW_PREFIX="/usr/local"
case "$(uname -m)" in
  "arm64")
    HOMEBREW_PREFIX=${ARM_HOMEBREW_PREFIX}
    echo "Start Home Brew as ARM64 M1 Sillicon ✅"
  ;;
  "i386"|"x86_64")
    HOMEBREW_PREFIX=${INTEL_HOMEBREW_PREFIX}
    echo "Start Home Brew under Rosetta 2 Intel Emulation x86_64 🤔"
  ;;
  *)
    echo "Which Processor Architecture is that? [$(uname -m)]"
  ;;
esac
export PATH=${HOMEBREW_PREFIX}/bin:${PATH}
