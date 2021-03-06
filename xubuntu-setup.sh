#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install -y automake build-essential pkg-config libncurses5-dev \
  libevent-dev vim git ruby cmake libfreetype6-dev libfontconfig1-dev xclip curl \
  chromium-browser python python-gtk2 python-xlib python-dbus python-wnck python-setuptools \
  htop python-pip openssh-server virtualbox-qt bash-completion libcurl3 \
  libcurl3-openssl-dev libssl1.0 libssl-dev libxml2 libxml2-dev ca-certificates

curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

if [ ! -d ~/workspace ]; then
    mkdir ~/workspace
fi

pushd ~/workspace
  # Install alacritty
  git clone https://github.com/jwilm/alacritty.git
  pushd alacritty
    cargo build --release
    sudo cp target/release/alacritty /usr/local/bin
    cp Alacritty.desktop ~/.local/share/applications
  popd
  rm -rf alacritty

  # Install lpass cli
  git clone https://github.com/lastpass/lastpass-cli.git
  pushd lastpass-cli
    make
    sudo cp build/lpass /usr/local/bin
  popd
  rm -rf lastpass-cli

  # Install tmux
  wget https://github.com/tmux/tmux/releases/download/3.0/tmux-3.0.tar.gz
  tar xzvf tmux-3.0.tar.gz
  pushd tmux-3.0
    ./configure
    make
    sudo make install
  popd
  rm tmux-3.0.tar.gz
  rm -rf tmux-3.0

  # Install chruby
  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  pushd chruby-0.3.9/
    sudo make install
  popd
  rm chruby-0.3.9.tar.gz
  rm -rf chruby-0.3.9

  wget -O ruby-install-0.6.1.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
  tar -xzvf ruby-install-0.6.1.tar.gz
  pushd ruby-install-0.6.1/
    sudo make install
  popd
  rm ruby-install-0.6.1.tar.gz
  rm -rf ruby-install-0.6.1

  # Install Go
  wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
  tar xzvf go1.11.2.linux-amd64.tar.gz
  sudo mv go /usr/local/go
  rm go1.11.2.linux-amd64.tar.gz

  # Install dotfiles
  ./install.sh

  # Install VeraCrypt
  wget https://launchpad.net/veracrypt/trunk/1.21/+download/veracrypt-1.21-setup.tar.bz2
  mkdir veracrypt-setup
  tar xvfj veracrypt-1.21-setup.tar.bz2 -C veracrypt-setup/
  pushd veracrypt-setup
    ./veracrypt-1.21-setup-gui-x64
  popd
  rm veracrypt-1.21-setup.tar.bz2
  rm -rf veracrypt-setup

  # Install quicktile
  sudo pip install https://github.com/ssokolow/quicktile/archive/master.zip

  # Install git-duet
  mkdir git-duet
  pushd git-duet
    wget https://github.com/git-duet/git-duet/releases/download/0.5.2/linux_amd64.tar.gz
    tar xzvf linux_amd64.tar.gz
    cp git-* ~/bin/.
  popd

  git clone https://github.com/wting/autojump
  pushd autojump
    ./install.py
  popd
popd
