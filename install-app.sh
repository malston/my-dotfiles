#!/usr/bin/env zsh

source $HOME/my-dotfiles/helpers.sh

#
# 1Password + 1Password CLI + git-credential-1password + Safari Extension
#
# Password manager
# CLI for 1Password
# Safari integration
#
# https://1password.com
# https://1password.com/downloads/command-line/
# https://apps.apple.com/us/app/1password-for-safari/id1569813296
#
if [[ "$(isAppInstalled 1Password)" = "false" ]]; then
    installcask 1password
    giveScreenRecordingPermission 1Password
    dockutil --add /Applications/1Password.app --allhomes
    installkeg 1password-cli
    open -a 1Password
    pausethescript "Open 1Password settings, and check 'Connect with 1Password CLI' & click the 'Set up SSH Agent' button in the 'Developer' tab before continuing"
    restoreAppSettings ssh
    eval $(op signin)
    pausethescript "Sign in to 1Password before continuing"
    brew tap develerik/tools
    installFromAppStore "1Password Safari Extension" 1569813296
    open -a Safari
    pausethescript "Open Safari Settings, and in the Extensions tab, check the box for '1Password for Safari' before continuing"
fi