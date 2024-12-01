#!/bin/bash

# Update package database and install required packages
sudo pacman -Sy git curl npm wget nano base-devel ufw autoconf automake openssh gnutls --noconfirm

# Install undollar globally using npm
sudo npm install undollar -g
sudo systemctl enable ufw
sudo systemctl enable sshd

# Install yay package manager
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

# Install Docker and Docker Compose
sudo pacman -S docker docker-compose --noconfirm
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

# Refresh groups to apply docker group change
newgrp docker

# Launch COSMOS CLOUD
sudo docker run -d --network host --privileged \
    --name cosmos-server -h cosmos-server \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
    -v /:/mnt/host -v /var/lib/cosmos:/config \
    azukaar/cosmos-server:latest

echo "Setup complete!"
