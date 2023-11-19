#!/bin/bash

echo "Updating the system..."
sudo apt update -y

echo "Check if Docker is already installed..."
if [ -f /tmp/docker_installed ]; then
    echo "Docker is already installed!"
    exit 0
fi

echo "Installing curl..."
sudo apt install curl -y


echo "Installing net-tools..."
sudo apt-get install net-tools -y

echo "Installing Docker..."

{
    sudo apt install apt-transport-https ca-certificates gnupg2 software-properties-common -y
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add 
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt update -y
    sudo apt install docker-ce -y 
} || {
    echo "Error installing Docker! Exiting..."
    exit 1
}


echo "Adding user to docker group..."
sudo groupadd docker

echo "Docker installed successfully!"dock

echo "Create a file to confirm the installation..."
touch /tmp/docker_installed