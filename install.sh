#!/usr/bin/env bash

INIT_VIM_PLUGINS=false
INSTALL_HOOKS=false
INSTALL_ZSH_PLUGINS=false
INSTALL_BREW=false
INSTALL_POWERLINE=false
LINK_DOTFILES=false
ZSH_CUSTOM="$HOME/my-dotfiles/oh-my-zsh"

flag=$1
if [[ "$flag" = "" ]]; then
    flag="-a"
fi

if [[ "$flag" = "-a" ]]; then
    INIT_VIM_PLUGINS=true
    LINK_DOTFILES=true
    INSTALL_HOOKS=true
    INSTALL_ZSH_PLUGINS=true
    INSTALL_BREW=true
    INSTALL_POWERLINE=true
elif [[ "$flag" = "-h" ]]; then
    INSTALL_HOOKS=true
elif [[ "$flag" = "-l" ]]; then
    LINK_DOTFILES=true
elif [[ "$flag" = "-p" ]]; then
    INSTALL_POWERLINE=true
elif [[ "$flag" = "-v" ]]; then
    INIT_VIM_PLUGINS=true
elif [[ "$flag" = "-z" ]]; then
    INSTALL_ZSH_PLUGINS=true
fi

all_dotfiles=(zprofile zshrc bashrc bash_darwin bash_profile bash_extras common_profile tmux.conf vimrc vim aliases git-authors gitconfig ssh/config)
protected_repos=(homelab home-vpn)

function link {
    echo Attempting to link "$1"
    ln -is "$PWD/$1" "$HOME/.$1"
}

function print_error {
    2>&1 echo "$@"
}

function die() {
    print_error
    exit 1
}

function backup_dotfile {
    dotfile=$1
    if [[ -f "$HOME/.$dotfile" && ! -L "$HOME/.$dotfile" ]]; then
        echo "Copying $dotfile to $HOME/.${dotfile}.bak"
        cp "$HOME/.$dotfile" "$HOME/.${dotfile}.bak"
    fi
}

function link_dotfile {
    local dotfile=$1
    backup_dotfile "$dotfile"
    if [[ -L "$HOME/.$dotfile" ]]; then
        # link exists
        print_error "WARN: $dotfile already linked"
    else
        # link does not exist
        link "$dotfile"
    fi
}

function link_dotfiles {
    local dotfiles=(zprofile zshrc aliases tmux.conf)
    for dotfile in "${dotfiles[@]}"; do
        link_dotfile "$dotfile"
    done
}

function link_all_dotfiles {
    for dotfile in "${all_dotfiles[@]}"; do
        link_dotfile "$dotfile"
    done
}

function update_submodules {
    git submodule update --init --recursive
}

function initialize_vim_plugins {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # install vim plugins with vundle
    vim +PluginInstall +qall
}

function initialize_zsh_plugins {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubectx" ]; then
        git clone https://github.com/unixorn/kubectx-zshplugin "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubectx"
    else
        cd "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubectx" && git pull &>/dev/null && cd - &>/dev/null
    fi
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z" ]; then
        git clone https://github.com/agkozak/zsh-z "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z"
    else
        cd "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z" && git pull &>/dev/null && cd - &>/dev/null
    fi
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    else
        cd "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" && git pull &>/dev/null && cd - &>/dev/null
    fi
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    else
        cd "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" && git pull &>/dev/null && cd - &>/dev/null
    fi
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin" ]; then
        git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin"
    else
        cd "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin" && git pull &>/dev/null && cd - &>/dev/null
    fi
}

function install_hooks {
    hook=$(pwd)/hooks/no-push-master
    while IFS= read -r repo; do
        for protected in "${protected_repos[@]}"; do
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

update_submodules

if [[ "$LINK_DOTFILES" == "true" ]]; then
    # link_dotfiles
    link_all_dotfiles
fi

if [[ "$INIT_VIM_PLUGINS" == "true" ]]; then
    initialize_vim_plugins
fi

if [[ "$INSTALL_POWERLINE" == "true" ]]; then
    install_powerline
fi

if [[ "$INSTALL_HOOKS" == "true" ]]; then
    install_hooks
fi

if [[ "$INSTALL_ZSH_PLUGINS" == "true" ]]; then
    initialize_zsh_plugins
fi

if [[ $INSTALL_BREW == true ]]; then
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    brew install --cask iterm2
    brew install fzf
    brew install eza
    brew install kubectx

    # Install all nerd fonts
    brew tap homebrew/cask-fonts
    brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
    brew install --cask font-fira-code

    brew install starship
    brew tap microsoft/git
    brew install --cask git-credential-manager
    brew install --cask visual-studio-code
    brew install vim
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

if [ ! -f ~/.config/starship.toml ]; then
    mkdir -p ~/.config
    cp "$HOME/my-dotfiles/starship.toml" ~/.config/starship.toml
fi
