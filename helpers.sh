#!/usr/bin/env zsh

source $HOME/.zshrc

#
# - run this script with "zsh macsetup.sh"
# - to erase correctly previous laptop disk, use the command: "diskutil secureErase 4 /dev/disk0"
#

#########################
#                       #
# Script Configurations #
#                       #
#########################

email="marktalston@gmail.com"
workemail="mark.alston@broadcom.com"
username="malston"
macusername="ma001038"

#
# Cache password
#
#echo "Caching password..."
#sudo -K
#sudo true;

#
# Load the colors function from ZSH
#
autoload colors; colors

#
# Pause the script until the user hit ENTER & display information to the user
#
# @param message for the user
#
function pausethescript {
    echo $fg[yellow]"$1"$reset_color
    echo "Press ENTER to continue the installation script"
    read -r < /dev/tty
}

#
# Open file without knowing their exact file name.
#
# @param part of the file name
#
function openfilewithregex {
    local file=$(findfilewithregex "$1")
    open "${file}"
    pausethescript "Wait for the $file installtion to end before continuing."
    rm "${file}"
}

#
# Find a filename without knowing the exact file name
#
# @param part of the file name
#
function findfilewithregex {
    echo $(find . -maxdepth 1 -execdir echo {} ';'  | grep "$1")
}

#
# Detect if a GUI application has been installed
#
# @param the application name
#
# @return true if installed, false if not
#
function isAppInstalled {
    if [[ $(osascript -e "id of application \"$1\"" 2>/dev/null) ]]; then
        print $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color  >&2
	    echo true
    else
        print $fg[blue]"Starting the installation of $1"$reset_color  >&2
        echo false
    fi
}

#
# Install a Homebrew Keg, if not already installed
#
# @param the application name
#
function installkeg {
    local alreadyInstalled=$(brew list "$1" 2>&1 | grep "No such keg")

    if [[ -n "$alreadyInstalled" ]]; then
        echo $fg[blue]"Starting the installation of $1"$reset_color
        brew install "$1"
    else
	    echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    fi
}

function installfont {
    local alreadyInstalled=$(brew list "$1" 2>&1 | grep "No such keg")

    if [[ -n "$alreadyInstalled" ]]; then
        echo $fg[blue]"Starting the installation of $1"$reset_color
        brew install --cask "$1"
    else
	    echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    fi
}

#
# Detect if a Node.js package has been installed globally
#
# @param the package name
#
# @return true if installed, false if not
#
function isNodePackageInstalled {
    if npm list -g $1 --depth=0 > /dev/null; then
        echo true
    else
        echo false
    fi
}

#
# Install the Node.js package globally, if not already installed
#
# @param Node.js package name
#
function installNodePackages {
    if [[ "$(isNodePackageInstalled $1)" = "false" ]]; then
        echo $fg[blue]"Starting the installation of $1"$reset_color
        npm install -g "$1"
        rehash
    else
        echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    fi
}

#
# Install a Homebrew Cask, if not already installed
#
# @param the application name
#
function installcask {
    if [[ "$(isAppInstalled $1)" = "false" ]]; then
        brew install --cask $1
    else
       return 1
    fi
}

#
# Install a App Store application, if not already installed
#
# @param the application ID
#
function installFromAppStore {
    if [[ "$(isAppInstalled $1)" = "false" ]]; then
        mas install "$2"
    else
        return 1
    fi
}

#
# Obtain the full path of a GUI application
#
# @param the application name
#
# @return the full path of the application, empty if it does not exist
#
function getAppFullPath {
    mdfind -name 'kMDItemFSName=="'"$1"'.app"' -onlyin /Applications -onlyin /System/Applications
}

#
# Detect if a CLI application has been installed
#
# @param the application name
#
# @return true if installed, false if not
#
function isCLAppInstalled {
    if which "$1" > /dev/null; then
        print $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color  >&2
        echo true
    else
        print $fg[blue]"Starting the installation of $1"$reset_color  >&2
        echo false
    fi
}

#
# Install a Python package, if not already installed
#
# @param the package name
#
function installPythonPackage {
    local package=$(pip list | grep "$1")

    if [[ -n "$package" ]]; then
        echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
    else
        echo $fg[blue]"Installing the Python package $1"$reset_color
        pip install "$1"
    fi
}

#
# Install a Python application, if not already installed
#
# @param the application name
#
function installPythonApp {
    local package=$(pipx list | grep "$1")

    if [[ -n "$package" ]]; then
        echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    else
        echo $fg[blue]"Installing the Python application $1"$reset_color
        pipx install "$1"
    fi
}

#
# Overwrite of the sudo command to give more context on why it's needed within the script
#
# @param the command to be executed with sudo
#
function sudo {
    local needpass=$(/usr/bin/sudo -nv 2>&1 | grep "Input required")
    #For whatever reason, chalk doesn't play well with $@,
    # but is fine if the value is stored in another variable
    local command=$@

    if [[ "$needpass" ]]; then
        echo $fg[blue]"The script need to use root (sudo) to run the $fg[green]$command$fg[blue] command"$reset_color
    else
        echo $fg[blue]"Using previously root (sudo) access to run the $fg[green]$command$fg[blue] command"$reset_color
    fi
    /usr/bin/sudo $@
}

#
# Use Mackup to restore a specific application settings
#
# @param the application name from Mackup
#
function restoreAppSettings {
    echo "[storage]\nengine = icloud\n\n[applications_to_sync]\n$1" > $HOME/.mackup.cfg
    mackup restore
    echo "[storage]\nengine = icloud\n" > $HOME/.mackup.cfg
}

#
# Install the application from PKG inside of a DMG
#
# @param DMG filename
#
function installPKGfromDMG {
    hdiutil attach "$1"
    local volume="/Volumes/$(hdiutil info | grep /Volumes/ | sed 's@.*\/Volumes/@@' | tail -1)"
    local pkg=$(/bin/ls "$volume" | grep .pkg)

    installPKG "$volume/$pkg"

    hdiutil detach "$volume"
    rm "$1"
}

# Install the application from a PKG
#
# @param DMG filename
#
function installPKG {
    sudo installer -pkg "$1" -target /

    # Cannot delete the pkg from inside a volume (happen when run from installPKGfromDMG)
    if [[ "$1" != "/Volumes/"* ]]; then
        rm "$1"
    fi
}

#
# Install the application from a DMG image when you just need to move the
# application into the macOS Applications folder
#
# @param DMG filename
# @param delete the DMG or not
#
function installDMG {
    hdiutil attach "$1"
    local volume="/Volumes/$(hdiutil info | grep /Volumes/ | sed 's@.*\/Volumes/@@')"
    local app=$(/bin/ls "$volume" | grep .app)
    mv "$volume/$app" /Applications
    hdiutil detach "$volume"

    if [[ "$2" = "true" ]]; then
        rm "$1"
    fi
}

#
# Reload .zshrc in the current shell
#
function reload {
    source $HOME/.zshrc
}

#
# Create a csreq blob for a specific application
#
# @param app name
#
# @return csreq blob in hexadecimal
#
# Notes:
# - Process taken from https://stackoverflow.com/a/57259004/895232
#
function getCsreqBlob {
    local app=$(getAppFullPath "$1")
    # Get the requirement string from codesign
    local req_str=$(codesign -d -r- "$app" 2>&1 | awk -F ' => ' '/designated/{print $2}')
    echo "$req_str" | csreq -r- -b /tmp/csreq.bin
    local hex_blob=$(xxd -p /tmp/csreq.bin  | tr -d '\n')
    rm /tmp/csreq.bin
    echo "$hex_blob"
}

#
# Get the application bundle identifier
#
# @param app name
#
# @return the application bundle identifier
#
function getAppBundleIdentifier {
    local app=$(getAppFullPath "$1")
    mdls -name kMDItemCFBundleIdentifier -r "$app"
}

#
# Give Full Disk Access Permission for a specific application
#
# @param app name
#
function giveFullDiskAccessPermission {
    updateTCC "kTCCServiceSystemPolicyAllFiles" "$1"
}

#
# Give Screen Recording Permission for a specific application
#
# @param app name
#
function giveScreenRecordingPermission {
    updateTCC "kTCCServiceScreenCapture" "$1"
}

#
# Give Accessibility Permission for a specific application
#
# @param app name
#
function giveAccessibilityPermission {
    updateTCC "kTCCServiceAccessibility" "$1"
}

#
# Update the access table in the TCC database with the new permission
#
# @param service for permission
# @param application identifier
# @param application csreq blob
#
# Notes:
# - More information on TCC at https://www.rainforestqa.com/blog/macos-tcc-db-deep-dive
#
function updateTCC {
    local app_identifier=$(getAppBundleIdentifier "$2")
    local app_csreq_blob=$(getCsreqBlob "$2")

    # Columns:
    # - service: the service for the permission (ex.: kTCCServiceSystemPolicyAllFiles for Full Disk Access permission)
    # - client: app bundle identifier
    # - client_type: 0 since it's the bundle identifier
    # - auth_value: 2 for allowed
    # - auth_reason: 3 user set
    # - auth_version: always 1 for now
    # - csreq: binary code signing requirement blob that the client must satisfy in order for access to be granted
    # - policy_id: null, related to MDM
    # - indirect_object_identifier_type: 0 since it's the bundle identifier
    # - indirect_object_identifier: UNUSED since it's not needed for this permission
    # - indirect_object_code_identity: same as csreq policy_id, so NULL
    # - flags: not sure, always 0
    # - last_modifified: last time entry was modified

    local exist=$(sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "select count(service) from access where service = '$1' and client = '$app_identifier';")
    if [[ exist ]]; then
        sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "update access SET auth_value=2 where service = '$1' and client = '$app_identifier';"
    else
        sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "insert into access values('$1', '$app_identifier', 0, 2, 3, 1, '$app_csreq_blob', NULL, 0, 'UNUSED', NULL, 0, CAST(strftime('%s','now') AS INTEGER));"
    fi

}

#
# Get the license key from 1Password & copy it to the clipboard
#
# @param the application we want the license key
#
function getLicense {
    op item get "$1" --fields label="license key" | pbcopy
    pausethescript "Add the license key from the clipboard to $1 before continuing"
}

#
# Get the license file from 1Password & open it
#
# @param the application we want the license key
# @param the filename of the license (will automate that when 1Password let you get the document file name)
#
function getLicenseFile {
    op document get "$1" --output="$2"
    open "$2"
    pausethescript "Wait for $1 license to be added properly"
    rm "$2"
}

#
# Remove an application from the Dock, if it's there
#
# @param the application we want to remove
#
function removeAppFromDock {
    if [[ $(dockutil --list | grep "$1") ]]; then
        echo $fg[blue]"Removing $1 from the Dock. The Dock will flash, it's normal."$reset_color
        dockutil --remove "$1" --allhomes
    fi
}

#
# Confirm running or not the command
#
# @param the text for the confirmation
# @param the command to run if accepted
#
function confirm {
    vared -p "$1 [y/N]: " -c ANSWER
    if [[ "$ANSWER" = "Y" ]] || [[ "$ANSWER" = "y" ]] || [[ "$ANSWER" = "yes" ]] || [[ "$ANSWER" = "YES" ]]; then
        eval $2
    fi
}

#
# Remove a pre-installed application
#
# @param application name
#
function removeApp {

    local app=$(getAppFullPath "$1")

    if [[ "$app" ]]; then
        echo $fg[blue]"Removing $1 from your computer."$reset_color
        sudo rm -rf "$app"
    fi
}

#
# Display the section information for the script section being run
#
# @param section name
#
function displaySection {
    local length=${#1}+4

    print "\n"

    for (( i=1; i<=$length; i++ )); do
        print -n "$fg[magenta]#";
    done

    print -n "\n#"

    for (( i=1; i<=$length-2; i++ )); do
        print -n " ";
    done

    print "#"

    print "# $1 #"

    print -n "#"

    for (( i=1; i<=$length-2; i++ )); do
        print -n " ";
    done

    print "#"

    for (( i=1; i<=$length; i++ )); do
        print -n "#";
    done

    print "\n$reset_color"
}

#
# Install a Rust application, if not already installed
#
# @param the application name
#
function installRustApp {
    local package=$(cargo install --list | grep "$1")

    if [[ -n "$package" ]]; then
        echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    else
        echo $fg[blue]"Installing the Python application $1"$reset_color
        cargo install "$1"
        reload
    fi
}

#
# Install asdf plugin, and a specific version of the plugin while setting it as the global version
#
# @param plugin name
# @param version of the plugin to instal
#
function installAsdfPlugin {
    if [[ $(asdf current $1) ]]; then
        echo $fg[green]"Skipped asdf plugin $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    else
        echo $fg[blue]"Installing the asdf plugin $1 & its version $2"$reset_color
        asdf plugin-add $1
        asdf install $1 $2
        asdf global $1 $2
        reload
    fi
}

#
# Install Go applications
#
# @param application name
# @param version of the application (default to latest)
#
function installGoApp {
    if [[ "$(isCLAppInstalled $1)" = "true" ]]; then
        echo $fg[green]"Skipped $fg[blue]$1$fg[green] already installed"$reset_color
        return 1
    else
        version=$2
        if [[ "$version" = "" ]]; then
            version="latest"
        fi

        echo $fg[blue]"Installing the version $version of the Go application $1"$reset_color
        go install "${1}"@"$version"
        asdf reshim golang
    fi
}

#
# Get macOS codename (Monterey, Ventura, Sonoma...)
#
# @return macOS codename
#
function getmacOSCodename {
    sed -nE '/SOFTWARE LICENSE AGREEMENT FOR/s/.*([A-Za-z]+ ){5}|\\$//gp' /System/Library/CoreServices/Setup\ Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf
}
