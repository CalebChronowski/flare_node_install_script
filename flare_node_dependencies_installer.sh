#!/bin/bash

# Config
FLARE_GIT_REPO="https://gitlab.com/flarenetwork/flare"
GO_VERSION="14.13"
GO_TAR_URL="https://golang.org/dl/" #The tar file names have this format: go1.xx.xx.linux-amd64.tar.gz
NODEJS_URL="https://deb.nodesource.com/setup_10.x"


# Opening message and warning
echo "============="
echo "   WARNING   "
echo "============="
printf "This will load all software dependencies for running your own FLare node on the compton 2 testnet.\nIt was developped April 2021 and may no longer be up to date.\nThis script was only tested on a headless 64-bit Ubuntu Server 20.14 and assumes that the system has not been modified from the default installation in anyway. If you have already tried to partially set up a Flare node on your machine, wipe it and give it a brand new installation prior to using this script. Proceed with caution."


# y/n prompt to run
while true; do
    read -r -p "Start dependencies installation? [Y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
            echo "Installing dependencies."
            break
            ;;
        [nN][oO]|[nN])
            echo "Cancelling installation."
            exit 2
                ;;
        *)
        echo "Invalid input"
        ;;
    esac
done


# Check if sudo
if [[ "$EUID" != 0 ]]; then
    echo "Script must be performed with root privileges."
    echo "Try again."
    exit 2
fi


# Download Go
cd ~/
echo "Downloading Go version ${GO_VERSION} from ${GO_TAR_URL}"
wget "${GO_TAR_URL}/go1.${GO_VERSION}.linux-amd64.tar.gz"

# Install Go
echo "Unpacking go1.${GO_VERSION}.linux-amd64.tar.gz"
rm -rf /usr/local/go && tar -xzf go1.14.13.linux-amd64.tar.gz -C /usr/local
rm -f go1.${GO_VERSION}.linux-amd64.tar.gz


# Add Go to PATH
echo "Adding Go to path"
echo 'export PATH=/usr/local/go/bin:$PATH' >>~/.bash_profile


# Install NodeJS
echo "Installing NodeJS."
echo "=============================="
echo "Warning: On screen prompts will guide you through installing additional dependencies. Read them carefully"
echo "=============================="
curl -fsSL $NODEJS_URL | sudo -E bash -
sudo apt-get install -y nodejs

# Clean up system
sudo apt-get install build-essential
sudo apt-get update
sudo apt-get upgrade


# Clone Git repo
git clone $FLARE_GIT_REPO


# Complete
echo "Flare node dependencies installation complete."