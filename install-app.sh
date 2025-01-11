#!/usr/bin/env zsh

source $HOME/my-dotfiles/helpers.sh

#
# iTerm2
# iTerm2 Shell Integration
#
# Terminal replacement
#
# https://github.com/gnachman/iTerm2
# https://iterm2.com/documentation-shell-integration.html
#
if [[ "$(isAppInstalled iTerm)" = "false" ]]; then
    installcask iterm2
    giveFullDiskAccessPermission iTerm
    dockutil --add /Applications/iTerm.app/ --allhomes
    cp prefs/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

    curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
    open -a iTerm
    echo $fg[yellow]"You can now close the Terminal app, and continue on iTerm"$reset_color
    exit
else
    cp preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
fi

exit 0
#
# mas-cli
#
# Unofficial macOS App Store CLI
#
# https://github.com/mas-cli/mas
#
# Notes: Need to install before Xcode
#
if [[ "$(isCLAppInstalled mas)" = "false" ]]; then
    installkeg mas
    open -a "App Store"
    pausethescript "Sign in into the App Store before continuing"
fi

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

#
# Visual Studio Code
#
# Code editor
#
# https://github.com/microsoft/vscode
#
if [[ "$(isAppInstalled "Visual Studio Code")" = "false" ]]; then
    installcask visual-studio-code
    dockutil --add /Applications/Visual\ Studio\ Code.app/ --allhomes

    npm config set editor code

    duti -s com.microsoft.VSCode public.css all #CSS
    duti -s com.microsoft.VSCode public.comma-separated-values-text all #CSV
    duti -s com.microsoft.VSCode com.netscape.javascript-source all #JavaScript
    duti -s com.microsoft.VSCode public.json all #json
    duti -s com.microsoft.VSCode dyn.ah62d4rv4ge8027pb all #lua
    duti -s com.microsoft.VSCode com.apple.log all #log
    duti -s com.microsoft.VSCode net.daringfireball.markdown all #Markdown
    duti -s com.microsoft.VSCode public.php-script all #php
    duti -s com.microsoft.VSCode com.apple.property-list all # Plist
    duti -s com.microsoft.VSCode public.python-script all # Python
    duti -s com.microsoft.VSCode public.rtf all #RTF
    duti -s com.microsoft.VSCode public.ruby-script all #Ruby
    duti -s com.microsoft.VSCode com.apple.terminal.shell-script all #SH
    duti -s com.microsoft.VSCode public.shell-script all #Shell script
    duti -s com.microsoft.VSCode dyn.ah62d4rv4ge81g6pq all #SQL
    duti -s com.microsoft.VSCode dyn.ah62d4rv4ge81k3u all #terraform tf
    duti -s com.microsoft.VSCode dyn.ah62d4rv4ge81k3xxsvu1k3k all #terraform tfstate
    duti -s com.microsoft.VSCode dyn.ah62d4rv4ge81k3x0qf3hg all #terraform tfvars
    duti -s com.microsoft.VSCode public.plain-text all #txt
    duti -s public.mpeg-2-transport-stream all #TypeScript (there's no official UTI, so using the recognized one as I never have MPEG .ts files)
    duti -s com.microsoft.VSCode public.xml all #xml
    duti -s com.microsoft.VSCode public.yaml all #YAML
    duti -s com.microsoft.VSCode public.zsh-script all #ZSH
fi
