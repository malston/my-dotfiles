#!/usr/bin/env bash

set -o errexit
set -o pipefail

ALL_DOTFILES=(zprofile zshrc bashrc bash_darwin bash_profile bash_extras common_profile tmux.conf vimrc nvimrc vim nvim aliases git-authors gitconfig ssh/config)
PROTECTED_REPOS=(homelab home-vpn)
ZSH_CUSTOM="$PWD/oh-my-zsh"

usage() {
    cat <<EOF
Usage: $0 [-a] [-h] [-l] [-p] [-v] [-z]
  -a  Install all components
  -h  Install hooks
  -l  Link dotfiles
  -p  Install powerline
  -v  Initialize vim plugins
  -z  Install zsh plugins
EOF
}

function link {
    echo Attempting to link "$1"
    ln -is "$PWD/$1" "$HOME/.$1"
}

function print_error {
    echo "$@" >&2
}

function die() {
    print_error "$@"
    exit 1
}

function backup_dotfile {
    dotfile=$1
    if [[ -f "$HOME/.$dotfile" && ! -L "$HOME/.$dotfile" ]]; then
        echo "Copying $dotfile to $HOME/.${dotfile}.bak"
        if [[ -f "$HOME/.${dotfile}.bak" ]]; then
            rm -f "$HOME/.${dotfile}.bak"
        fi
        cp "$HOME/.$dotfile" "$HOME/.${dotfile}.bak"
    fi
}

# Function to link dotfiles
function link_dotfile {
    if [[ -f "$HOME/.$1" && -L "$HOME/.$1" ]]; then
        echo "$HOME/.$1 already exists, skipping."
    else
        backup_dotfile "$1"
        echo "Linking $1"
        ln -is "$PWD/$1" "$HOME/.$1"
    fi
}

# Function to link all dotfiles
function link_all_dotfiles {
    for dotfile in "${ALL_DOTFILES[@]}"; do
        if [ -e "$PWD/$dotfile" ]; then
            link_dotfile "$dotfile"
        else
            echo "File $dotfile does not exist, skipping."
        fi
    done
}

# Function to update submodules
function update_submodules {
    git submodule update --init --recursive
}

# Function to initialize vim plugins
function initialize_vim_plugins {
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        nvim +PlugInstall +qall
    else
        echo "Vim plugins already initialized, skipping."
    fi
}

# Function to initialize zsh plugins
function initialize_zsh_plugins {
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh already installed, skipping."
    fi

    local plugins=(
        "kubectx https://github.com/unixorn/kubectx-zshplugin"
        "zsh-z https://github.com/agkozak/zsh-z"
        "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "fzf-zsh-plugin https://github.com/unixorn/fzf-zsh-plugin.git"
    )

    for plugin in "${plugins[@]}"; do
        local name="${plugin%% *}"
        local url="${plugin##* }"
        local plugin_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$name"

        if [ ! -d "$plugin_dir" ]; then
            git clone "$url" "$plugin_dir"
        else
            cd "$plugin_dir" && git pull &>/dev/null && cd - &>/dev/null
        fi
    done
}

function install_hooks {
    hook=$(pwd)/hooks/no-push-master
    while IFS= read -r repo; do
        for protected in "${PROTECTED_REPOS[@]}"; do
            pushd "$repo" > /dev/null || exit 1
                repo_url=$(git config --get remote.origin.url)
                if [[ $repo_url = *"${protected}" || $repo_url = *"${protected}.git" ]]; then
                    echo "Installing pre-push hook in $repo..."
                    cp "$hook" hooks/pre-push
                    chmod 700 hooks/pre-push
                fi
            popd > /dev/null || exit 1
        done
    done <   <(find ~/workspace -name .git -type d)
}

function install_powerline {
    python3 -m pip install powerline-shell
    git clone https://github.com/powerline/fonts.git
    pushd fonts > /dev/null || exit 1
      ./install.sh
    popd > /dev/null || exit 1
    rm -rf fonts
    cat >> ~/.zshrc <<EOF
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" -a -x "$(command -v powerline-shell)" ]; then
    install_powerline_precmd
fi
EOF
}

while getopts "ahlpvz" opt; do
  case ${opt} in
    a )
      INIT_VIM_PLUGINS=true
      LINK_DOTFILES=true
      INSTALL_HOOKS=true
      INSTALL_ZSH_PLUGINS=true
      INSTALL_BREW=true
      INSTALL_POWERLINE=true
      ;;
    h )
      INSTALL_HOOKS=true
      ;;
    l )
      LINK_DOTFILES=true
      ;;
    p )
      INSTALL_POWERLINE=true
      ;;
    v )
      INIT_VIM_PLUGINS=true
      ;;
    z )
      INSTALL_ZSH_PLUGINS=true
      ;;
    \? )
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

update_submodules

# Main script execution
if [ "$LINK_DOTFILES" = true ]; then
    link_all_dotfiles
fi

if [ "$INIT_VIM_PLUGINS" = true ]; then
    initialize_vim_plugins
fi

if [ "$INSTALL_ZSH_PLUGINS" = true ]; then
    initialize_zsh_plugins
fi

if [ "$INSTALL_HOOKS" = true ]; then
    install_hooks
fi

if [[ "$INSTALL_POWERLINE" == "true" ]]; then
    install_powerline
fi

if [[ $INSTALL_BREW == true ]]; then
    (echo; echo "eval \"$("$(brew --prefix)/bin/brew" shellenv)\"") >> "$HOME/.zprofile"
    eval "$("$(brew --prefix)/bin/brew" shellenv)"

    brew install --cask iterm2
    brew install fzf
    brew install eza
    brew install kubectx
    brew install tree

    # Install all nerd fonts
    brew tap homebrew/cask-fonts
    brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
    brew install --cask font-fira-code

    brew install starship
    brew tap microsoft/git
    brew install --cask git-credential-manager
    brew install --cask visual-studio-code
    brew install neovim
    brew install --cask flycut
    brew install --cask rectangle
    brew install dockutil
    dockutil --list | awk -F\t '{print "dockutil --remove \""$1"\" --no-restart"}' | sh
    dockutil --add /Applications/Google\ Chrome.app --no-restart
    dockutil --add /Applications/iTerm.app
fi

if [[ ! -f $HOME/.dir_colors ]]; then
    git clone --recursive https://github.com/seebi/dircolors-solarized.git ~/dircolors-solarized
    ln -is ~/dircolors-solarized/dircolors.256dark ~/.dir_colors
fi

if [ ! -f "$HOME/.config/starship.toml" ]; then
    mkdir -p "$HOME/.config"
    cp "$PWD/starship.toml" "$HOME/.config/starship.toml"
fi
