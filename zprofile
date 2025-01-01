if [ -d "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# MacPorts Installer addition on 2024-01-06_at_07:49:59: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Python
# See https://realpython.com/intro-to-pyenv/
if command -v pyenv 1> /dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

if [ -d "$HOME/Library/Application Support/multipass/bin" ]; then
  PATH="$PATH:$HOME/Library/Application Support/multipass/bin"
fi
