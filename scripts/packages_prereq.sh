#!/usr/bin/env bash
set -euo pipefail

#This package is not installed
#sudo pacman -R virtualbox-guest-utils-nox --noconfirm

#Bash internal second counter reset
SECONDS=0

elapsed_time () {
     local calling_func=$1
     local seconds=$2
     echo "Execution time of $calling_func: $((seconds/3600))h $(((seconds/60)%60))m $((seconds%60))s"
}

emacs_pre_reqs () {
     (
          #Resetting `SECONDS` counter in this subshell
          SECONDS=0

          echo "Installing emacs pre-reqs (X, fonts, tools for lsp i.a.)..."
          sudo pacman --quiet --sync --refresh --noconfirm --needed \
               virtualbox-guest-utils emacs vim xorg-server xorg-xinit xterm git cmake fd llvm ripgrep aspell aspell-en languagetool pandoc \
               ttf-jetbrains-mono ttc-iosevka-etoile ttc-iosevka-aile otf-overpass noto-fonts-extra ttf-dejavu bash-language-server shellcheck sbcl \
               i3-wm dmenu \
               1>/dev/null

          elapsed_time "${FUNCNAME[0]}" SECONDS
     )
}

#Executing defined functions
emacs_pre_reqs

#Last steps
mkdir -p /home/vagrant/.gnupg
echo "keyserver keyserver.ubuntu.com" > /home/vagrant/.gnupg/gpg.conf

elapsed_time "Entire script" SECONDS
