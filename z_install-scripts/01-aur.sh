#!/bin/bash

# log files
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/aur-helper_$(date +%d-%m-%y_).log"
mkdir -p "$log_dir" && touch "$log"

source "$dir/00-global.sh"
[ -e "$dir/.cache/aur" ] && aur=$(cat "$dir/.cache/aur")

clear

info ac "Installing $aur.."

git clone --depth=1 "https://aur.archlinux.org/${aur}.git" 2>&1 | tee -a "$log" &> /dev/null
cd "$aur"
makepkg -si --noconfirm 2>&1 | tee -a "$log"
sleep 1
cd "$dir"
sudo rm -rf ${aur}

if [[ -n "$(command -v $aur)" ]]; then
    info ok "$aur was installed successfully!" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    sleep 1
    clear && sleep 1
else
    info er "Sorry, cound not install the $aur. exiting the script here..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    sleep 1

    exit 1
fi
