#!/usr/bin/env bash
set -euo pipefail

#Bash internal second counter reset
SECONDS=0

elapsed_time () {
    local calling_func=$1
    local seconds=$2
    echo "Execution time of $calling_func: $((seconds/3600))h $(((seconds/60)%60))m $((seconds%60))s"
}

### The compilation process of Emacs 28 requires manual compilation of 'libgccjit' and 'emacs-git'

install_yay () {
    (
    #Resetting `SECONDS` counter in this subshell
    SECONDS=0
    echo "Cloning yay..."
    git clone https://aur.archlinux.org/yay.git ~/yay
    echo "Installing yay and dependencies..."
    cd ~/yay; makepkg --syncdeps --install --noconfirm --needed --clean \
        1>/dev/null

    
    elapsed_time "${FUNCNAME[0]}" SECONDS
    )
}

# Uninstall emacs27
echo "Removing emacs 27..."
sudo pacman --remove --noconfirm emacs \
    1>/dev/null

#This package is interesting because
# 1) It's kept up-to-date
# 2) Combines --pgtk and native-comp compiler flags, and is delivered as a binary
install_emacs-gcc-wayland-devel-bin () {
    (
    #Resetting `SECONDS` counter in this subshell
    SECONDS=0
    echo "Intalling emacs-gcc-wayland-devel-bin..."
    yay --sync --noconfirm --needed --quiet emacs-gcc-wayland-devel-bin \
        1>/dev/null

    elapsed_time "${FUNCNAME[0]}" SECONDS
    )
}

#Executing defined functions
install_yay
install_emacs-gcc-wayland-devel-bin

elapsed_time "Entire script" SECONDS
