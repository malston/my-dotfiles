#!/usr/bin/env bash

# brew reinstall act
# brew reinstall argo
# brew reinstall argocd
# brew reinstall asdf
# brew reinstall aws-iam-authenticator
# brew reinstall awscli
# brew reinstall azure-cli
# brew reinstall bandwhich
# brew reinstall bash
# brew reinstall black
# brew reinstall c-ares
# brew reinstall cabal-install
# brew reinstall cffi
# brew reinstall civo/tools/civo
# brew reinstall commitlint
# brew reinstall cryptography
# brew reinstall curl
# brew reinstall doctl
# brew reinstall eslint
# brew reinstall eza
# brew reinstall fd
# brew reinstall ffmpeg
# brew reinstall freetds
# brew reinstall freetype
# brew reinstall fzf
# brew reinstall gh
# brew reinstall ghc
# brew reinstall git
# brew reinstall git-delta
# brew reinstall glab
# brew reinstall gnupg
# brew reinstall go
# brew reinstall goenv
# brew reinstall golangci-lint
# brew reinstall govc
# brew reinstall gpgme
# brew reinstall helm
# brew reinstall imagemagick
# brew reinstall k3d
# brew reinstall carvel-dev/carvel/kctrl
# brew reinstall kubefirst/tools/kubefirst
# brew reinstall kubernetes-cli
# brew reinstall kubescape
# brew reinstall kustomize
# brew reinstall ldns
# brew reinstall libassuan
# brew reinstall libavif
# brew reinstall libheif
# brew reinstall libpq
# brew reinstall libssh
# brew reinstall libx11
# brew reinstall luajit
# brew reinstall lz4
# brew reinstall mackup
# brew reinstall minio-mc
# brew reinstall mongodb-atlas-cli
# brew reinstall mongosh
# brew reinstall mpg123
# brew reinstall msgpack
# brew reinstall ncdu
# brew reinstall neovim
# brew reinstall node
# brew reinstall nss
# brew reinstall openjdk
# brew reinstall pandoc
# brew reinstall php
# brew reinstall php-code-sniffer
# brew reinstall pinentry
# brew reinstall pipx
# brew reinstall podman
# brew reinstall poppler
# brew reinstall pre-commit
# brew reinstall python-setuptools
# brew reinstall python@3.12
# brew reinstall readline
# brew reinstall ruby-build
# brew reinstall sdl2
# brew reinstall skaffold
# brew reinstall sqlite
# brew reinstall starship
# brew reinstall steampipe
# brew reinstall stylelint
# brew reinstall svt-av1
# brew reinstall syncthing
# brew reinstall tektoncd-cli
# brew reinstall telnet
# brew reinstall hashicorp/tap/terraform
# brew reinstall tflint
# brew reinstall typescript
# brew reinstall unbound
# brew reinstall vale
# brew reinstall vercel-cli
# brew reinstall video-compare
# brew reinstall vim
# brew reinstall webpack
# brew reinstall wp-cli
# brew reinstall yq
# brew reinstall yt-dlp

# brew uninstall yt-dlp
# brew uninstall php-code-sniffer
# brew uninstall wp-cli
# brew uninstall php
# brew uninstall vercel-cli
# brew uninstall video-compare
# brew uninstall syncthing
# brew uninstall mongodb-atlas-cli
# brew uninstall mongosh
# brew uninstall civo/tools/civo

# brew uninstall defbro
# brew uninstall apple-juice
# brew uninstall bartender
# brew uninstall cleanshot
# brew uninstall commandq
# brew uninstall contexts
# brew uninstall espanso
# brew uninstall karabiner-elements
# brew uninstall keepingyouawake
# brew uninstall little-snitch
# brew uninstall eloston-chromium
# brew uninstall tripmode
# brew uninstall home-assistant
# brew uninstall notion
# brew uninstall spotify
# brew uninstall todoist
# brew uninstall charles
# brew uninstall jupyterlab
# brew uninstall local
# brew uninstall mongodb-compass
# brew uninstall mqtt-explorer
# brew uninstall utm
# brew uninstall xcodes
# brew uninstall around
# brew uninstall audacity
# brew uninstall beardedspice
# brew uninstall blockblock
# brew uninstall calibre
# brew uninstall captin
# brew uninstall deckset
# brew uninstall descript
# brew uninstall dhs
# brew uninstall elgato-control-center
# brew uninstall elgato-stream-deck
# brew uninstall figma
# brew uninstall gimp
# brew uninstall gray
# brew uninstall ha-menu
# brew uninstall keybase
# brew uninstall keycastr
# brew uninstall kindle
# brew uninstall knockknock
# brew uninstall logitech-presentation
# brew uninstall LyricsX
# brew uninstall microsoft-teams
# brew uninstall muzzle
# brew uninstall nordvpn
# brew uninstall obs
# brew uninstall opera
# brew uninstall opera-gx
# brew uninstall pika
# brew uninstall raspberry-pi-imager
# brew uninstall reikey
# brew uninstall vlc
# brew uninstall whatsyoursign
# brew uninstall epic-games
# brew uninstall openemu
# brew uninstall monolingual
# brew uninstall app-tamer


for app in $(brew list --cask); do 
  cver="$(brew info --cask "${app}" | head -n 1 | cut -d " " -f 2)"
  if ivers=$(ls -1 "/opt/homebrew-cask/Caskroom/${app}/.metadata/" 2>/dev/null | tr '\n' ' ' | sed -e 's/ $//'); then
    aivers=("${ivers}")
    echo "[*] Found ${app} in cask list. Latest available version is ${cver}. You have installed version(s): ${ivers}"
    nvers="${#aivers[@]}"
    if [[ ${nvers} -eq 1 ]]; then 
      echo "${ivers}" | grep -q "^${cver}$" && { echo "[*] Latest version already installed :) Skipping changes ..."; continue; }
    fi
    echo "[+] Fixing from ${ivers} to ${cver} ..."
    # brew cask uninstall "${app}" --force
    # brew cask install "${app}"
  else
    echo "No .metadata found"
  fi
done