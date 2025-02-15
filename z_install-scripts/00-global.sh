#!/bin/bash

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# texts
att="${orange}** ${end}"
acc="${green}=> ${end}"
ok="${cyan}:: ${end}"
note="${blue}!! ${end}"
qus="${yellow}?? ${end}"
skip="${magenta}<> ${end}"
err="${red}>< oopss! an error${end}"

# prompt message function
info() {
    local action="$1"
    local msg="$2"

    case $action in
        at) printf "$att $msg\n"
        ;;
        ac) printf "$acc $msg\n"
        ;;
        ok) printf "$ok $msg\n"
        ;;
        nt) printf "$note $msg\n"
        ;;
        qs) printf "$qus $msg\n"
        ;;
        skp) printf "$skip $msg\n"
        ;;
        er) printf "$err\n   $msg\n"
        ;;
        *) echo "$msg"
        ;;
    esac
}

# Define installation functions
aur_helper=$(command -v yay || command -v paru) # Find the AUR helper

# Install using package manager
install() {
    if "$aur_helper" -Q $1 &> /dev/null; then
        info skp "Skipping $1. It's already there..."
    else
        info ac "Installing $1"
        sudo pacman -S --noconfirm "$1" &> /dev/null

        if "$aur_helper" -Q $1 &> /dev/null; then
            info ok "$1 was installed successfully!"
        else
            info err "Could not install $1.."
        fi
    fi
}
