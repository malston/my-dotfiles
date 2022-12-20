#!/usr/bin/env bash

LINK_DOTFILES=false
INIT_VIM=false
INSTALL_HOOKS=false

flag=$1
if [[ "$flag" = "" ]]; then
    flag="-a"
fi

if [[ "$flag" = "-a" ]]; then
    LINK_DOTFILES=true
    INIT_VIM=true
    INSTALL_HOOKS=true
elif [[ "$flag" = "-h" ]]; then
    INSTALL_HOOKS=true
elif [[ "$flag" = "-l" ]]; then
    LINK_DOTFILES=true
elif [[ "$flag" = "-p" ]]; then
    INIT_VIM=true
fi

all_dotfiles="zshrc bashrc bash_darwin bash_profile common_profile tmux.conf vimrc vim aliases git-authors gitconfig alacritty.yml"

function link {
    echo Attempting to link $1
    ln -is $PWD/$1 $HOME/.$1
}

function print_error {
    echo Failed to link $1
}

function link_all_dotfiles {
    for dotfile in $all_dotfiles; do
        if [[ -f $HOME/.$1 ]];
        then
            # file exists
            print_error $dotfile
        else
            # file does not exist
            link $dotfile
        fi
    done
    if [[ ! -f $HOME/.dir_colors ]]; then
        git clone --recursive https://github.com/seebi/dircolors-solarized.git
        ln -is ./dircolors-solarized/dircolors.256dark .dir_colors
    fi
}

function update_submodules {
    git submodule update --init --recursive
}

function initialize_vim_plugins {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # install vim plugins with vundle
    vim +PluginInstall +qall
    # install_powerline
}

function install_hooks {
    hook=$(pwd)/hooks/no-push-master
    for repo in $(find ~/workspace -name .git -type d); do
        for protected in loggregator-release loggregator-agent-release cf-syslog-drain-release log-cache-release cf-drain-cli noisy-neighbor-nozzle log-cache-cli service-metrics-release; do
            pushd $repo > /dev/null
                repo_url=$(git config --get remote.origin.url)
                if [[ $repo_url = *"${protected}" || $repo_url = *"${protected}.git" ]]; then
                    echo "installing pre-push hook in $repo_url..."
                    cp $hook hooks/pre-push
                fi
            popd > /dev/null
        done
    done
}

function install_powerline {
    pip install powerline-shell
    git clone https://github.com/powerline/fonts.git
    pushd fonts
    ./install.sh
    popd
    rm -rf fonts
    # bash-it enable plugin powerline
}

update_submodules
if [[ "$LINK_DOTFILES" = "true" ]]; then
    link_all_dotfiles
fi
if [[ "$INIT_VIM" = "true" ]]; then
    initialize_vim_plugins
fi
if [[ "$INSTALL_HOOKS" = "true" ]]; then
    install_hooks
fi
