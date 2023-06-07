eval "$(direnv hook zsh)"
# eval "$(service-instance-migrator completion zsh)"
# eval "$(app-migrator completion zsh)"
source <(stern --completion=zsh)
source <(kubectl completion zsh)
if [ -f /usr/local/opt/kube-ps1/share/kube-ps1.sh ]; then source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"; fi
if [ -f /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh ]; then source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"; fi

# Python
# See https://github.com/pyenv/pyenv
# See https://github.com/pyenv/pyenv-virtualenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# We want to regularly go to our virtual environment directory
# export WORKON_HOME=~/.virtualenvs

# If in a given virtual environment, make a virtual environment directory
# If one does not already exist
# mkdir -p $WORKON_HOME

# Activate the new virtual environment by calling this script
# The workon and mkvirtualenv functions are in here
# test -e "${HOME}/.pyenv/versions/$(pyenv version-name)/bin/virtualenvwrapper.sh" && source "${HOME}/.pyenv/versions/$(pyenv version-name)/bin/virtualenvwrapper.sh"
eval "$(pyenv virtualenv-init -)"
