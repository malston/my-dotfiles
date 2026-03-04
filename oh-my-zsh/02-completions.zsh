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

if command -v sinesync 1>/dev/null 2>&1; then
  . <(sinesync completion zsh)
fi

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

unalias cu 2>/dev/null
unalias cup 2>/dev/null
unalias clup 2>/dev/null
if command -v claudeup 1>/dev/null 2>&1; then
  source <(claudeup completion zsh)

  cu() { claudeup "$@"; }
  cup() { claudeup "$@"; }
  clup() { claudeup "$@"; }

  compdef _claudeup cu
  compdef _claudeup cup
  compdef _claudeup clup
fi

# Erk completion
if command -v erk 1>/dev/null 2>&1; then
  source <(erk completion zsh)
fi

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Erk shell integration
# Erk shell integration for zsh
# This function wraps the erk CLI to provide seamless worktree switching

erk() {
  # Don't intercept if we're doing shell completion
  [ -n "$_ERK_COMPLETE" ] && { command erk "$@"; return; }

  local script_path exit_status
  script_path=$(ERK_SHELL=zsh command erk __shell "$@")
  exit_status=$?

  # Passthrough mode: run the original command directly
  [ "$script_path" = "__ERK_PASSTHROUGH__" ] && { command erk "$@"; return; }

  # Source the script file if it exists, regardless of exit code.
  # This matches Python handler logic: use script even if command had errors.
  # The script contains important state changes (like cd to target dir).
  if [ -n "$script_path" ] && [ -f "$script_path" ]; then
    source "$script_path"
    local source_exit=$?

    # Clean up unless ERK_KEEP_SCRIPTS is set
    if [ -z "$ERK_KEEP_SCRIPTS" ]; then
      rm -f "$script_path"
    fi

    return $source_exit
  fi

  # Only return exit_status if no script was provided
  [ $exit_status -ne 0 ] && return $exit_status
}

