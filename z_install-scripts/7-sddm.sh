#!/bin/bash

# log files
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/sddm_$(date +%d-%m-%y_).log"
mkdir -p "$log_dir" && touch "$log"

source "$dir/00-global.sh"

sddm_pkgs=(
    qt6-5compat 
    qt6-declarative 
    qt6-svg
    sddm
)

login_managers=(
    gdm 
    lightdm
    lxdm 
    lxdm-gtk3
)

# check if any login manager is installed...
for login_manager in "${login_managers[@]}"; do
    if sudo pacman -Q "$login_manager" &> /dev/null; then
        info ac "Disabling $login_manager.."
        sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
    fi
done

info at "Installing required packages.\n"
for sddm_pkg in "${sddm_pkgs[@]}"; do
    install "$sddm_pkg" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    
done

sudo systemctl enable sddm.service 2>&1 | tee -a "$log" &> /dev/null

info at "Now setting up sddm theme.."

sddm_conf_dir=/etc/sddm.conf.d
[[ ! -d "$sddm_conf_dir" ]] && { info at "$sddm_conf_dir was not found, creating."; sudo mkdir -p "$sddm_conf_dir"; }

clear
    
# SDDM-themes

# Install THEME
theme="$parent_dir/assets/minimal_sddm.tar.gz"
theme_dir=/usr/share/sddm/themes

# creating sddm theme dir
if [ ! -d "$theme_dir" ]; then
    msg att "Sddm theme dir was not found, creatint it..."
    sudo mkdir -p "$theme_dir"
fi

# Set up SDDM
msg act "Setting up the Login Screen..."
sddm_conf_dir=/etc/sddm.conf.d
[ ! -d "$sddm_conf_dir" ] &&  sudo mkdir -p "$sddm_conf_dir"


sudo tar -xf "$theme" -C "$theme_dir"
echo -e "[Theme]\nCurrent=minimal_sddm" | sudo tee "$sddm_conf_dir/theme.conf.user" &> /dev/null

if [ -d "$theme_dir/minimal_sddm" ]; then
    msg dn "Sddm theme was installed successfully!"
fi

sleep 1 && clear
