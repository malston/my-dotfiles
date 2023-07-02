[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PS1='$(kube_ps1)'$PS1

function print_current_foundation() {
  lt_blue='\e[1;34m'
  clear='\e[0m'
  if [ -n "$FOUNDATION" ]; then
    echo -ne "$lt_blue""${FOUNDATION} ""$clear"
  fi
}

# autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if command -v direnv 1>/dev/null 2>&1; then
  export PS1='$(print_current_foundation)'$PS1
  eval "$(direnv hook zsh)"
fi

if command -v stern 1>/dev/null 2>&1; then
  source <(stern --completion=zsh)
fi

if command -v kubectl 1>/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if [ -f /usr/local/opt/kube-ps1/share/kube-ps1.sh ]; then source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"; fi
if [ -f /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh ]; then source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"; fi

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

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi