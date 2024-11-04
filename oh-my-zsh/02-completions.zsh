autoload -U +X bashcompinit && bashcompinit

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if command -v stern 1> /dev/null 2>&1; then
  source <(stern --completion=zsh)
fi

if command -v kubectl 1> /dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if command -v flux 1> /dev/null 2>&1; then
  . <(flux completion zsh)
fi

if command -v terraform 1> /dev/null 2>&1; then
  # complete -C /opt/homebrew/bin/terraform terraform
  complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi
