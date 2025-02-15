#!/bin/bash

# log files
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/other-packages_$(date +%d-%m-%y_).log"
mkdir -p "$log_dir" && touch "$log"

source "$dir/00-global.sh"

other_packages=(
    btop
    brightnessctl
    curl
    fastfetch
    ffmpeg
    imagemagick
    kvantum
    kvantum-qt5
    libinput
    lxappearance
    network-manager-applet
    networkmanager
    ntfs-3g
    nvtop
    os-prober
    pacman-contrib
    pamixer
    pavucontrol
    python-pywal
    wget
    xdotool
    xorg-xinput
    yad
)

# installing packages

for pkgs in "${other_packages[@]}"; do
    install "$pkgs" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
done
sleep 1 && clear
#_________ end _________#
