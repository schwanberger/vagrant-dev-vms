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

install_libgccjit () {
    (
    #Resetting `SECONDS` counter in this subshell
    SECONDS=0
    echo "Compiling and installing libgccjit - and as a depencency gcc..."
    yay --sync --noconfirm --needed --quiet libgccjit \
        1>/dev/null


    elapsed_time "${FUNCNAME[0]}" SECONDS
    )
}

# Uninstall emacs27
echo "Removing emacs 27..."
sudo pacman --remove --noconfirm emacs \
    1>/dev/null

compile_install_emacs-git () {
    (
    #Resetting `SECONDS` counter in this subshell
    SECONDS=0
    echo "Compiling and installing emacs-git, checkout 28 release branch (with JIT-feature, AOT)..."
    yay -G emacs-git; cd emacs-git; cp /c/Projects/vagrant-dev-vms/scripts/emacs29_git_jit_aot_29.50.PKGBUILD PKGBUILD; makepkg --syncdeps --install --noconfirm --needed --clean \
        1>/dev/null

    elapsed_time "${FUNCNAME[0]}" SECONDS
    )
}


#Executing defined functions
#install_yay # Outcommented - yay included in newest vagrant box and breaking this
install_libgccjit
compile_install_emacs-git

elapsed_time "Entire script" SECONDS
