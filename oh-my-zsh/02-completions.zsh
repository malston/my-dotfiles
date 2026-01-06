autoload -U +X bashcompinit && bashcompinit
setopt completealiases

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if command -v stern 1>/dev/null 2>&1; then
  source <(stern --completion=zsh)
fi

if command -v kubectl 1>/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if command -v flux 1>/dev/null 2>&1; then
  . <(flux completion zsh)
fi

if command -v terraform 1>/dev/null 2>&1; then
  # complete -C /opt/homebrew/bin/terraform terraform
  complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

if command -v op 1>/dev/null 2>&1; then
  eval "$(op completion zsh)"
  compdef _op op
fi

if command -v gh 1>/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
  compdef _gh gh
fi

# Setup autocomplete for kubectl commands
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function print_current_foundation() {
  lt_blue='\e[1;34m'
  clear='\e[0m'
  if [ -n "$FOUNDATION" ]; then
    echo -ne "$lt_blue""${FOUNDATION} ""$clear"
  fi
}

if command -v direnv 1>/dev/null 2>&1; then
  export PS1='$(print_current_foundation)'$PS1
  eval "$(direnv hook zsh)"
fi

# asdf
# shellcheck source=/dev/null
if [ -d "$(brew --prefix)/opt/asdf" ]; then
  . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
  . "$(brew --prefix)/opt/asdf/etc/bash_completion.d/asdf.bash"
fi

# autojump
# shellcheck source=/dev/null
[ -f "$(brew --prefix)/etc/profile.d/autojump.sh" ] && . "$(brew --prefix)/etc/profile.d/autojump.sh"

# Python
# See https://github.com/pyenv/pyenv
# See https://github.com/pyenv/pyenv-virtualenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  # We want to regularly go to our virtual environment directory
  # export WORKON_HOME=~/.virtualenvs

  # If in a given virtual environment, make a virtual environment directory
  # If one does not already exist
  # mkdir -p $WORKON_HOME

  # Activate the new virtual environment by calling this script
  # The workon and mkvirtualenv functions are in here
  # test -e "${HOME}/.pyenv/versions/$(pyenv version-name)/bin/virtualenvwrapper.sh" && source "${HOME}/.pyenv/versions/$(pyenv version-name)/bin/virtualenvwrapper.sh"
  eval "$(pyenv virtualenv-init -)"
fi

if command -v fzf 1>/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v claudeup 1>/dev/null 2>&1; then
  source <(claudeup completion zsh)

  cu() { claudeup "$@"; }
  cup() { claudeup "$@"; }
  clup() { claudeup "$@"; }

  compdef _claudeup cu
  compdef _claudeup cup
  compdef _claudeup clup
fi
