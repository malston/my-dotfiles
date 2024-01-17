ZSH_DISABLE_COMPFIX=true
# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/opt/homebrew/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
export ZSH_CUSTOM="$HOME/my-dotfiles/oh-my-zsh"

# Use fzf to search your command history and do file searches.
FZF_BASE="$HOME/.fzf"
export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore --files -g "!.git/"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
  autojump
  brew
  bundler
  colored-man-pages
  colorize
  dotenv
  fzf
  git
  kubectl
  kubectx
  kube-ps1
  macos
  rake
  rbenv
  ruby
  pip
  python
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Setup autocomplete for kubectl commands
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
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

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

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

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Created by `pipx` on 2024-01-04 03:26:13
export PATH="$PATH:/Users/$USER/.local/bin"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

function powerline_precmd() {
    PS1=""
}

function install_powerline_precmd() {
  for s in ""; do
    if [ "" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "xterm-256color" != "linux" -a -x "" ]; then
    install_powerline_precmd
fi
function powerline_precmd() {
    PS1=""
}

function install_powerline_precmd() {
  for s in ""; do
    if [ "" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "xterm-256color" != "linux" -a -x "" ]; then
    install_powerline_precmd
fi

if command -v op 1>/dev/null 2>&1; then
  eval "$(op completion zsh)"; compdef _op op
fi