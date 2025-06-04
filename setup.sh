#!/bin/bash

# This script automates the setup of a comprehensive development environment
# on Debian-based Linux systems (like Ubuntu or Kali Linux).
# It includes Rust, essential build tools, and Docker with Docker Compose.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting development environment setup..."

# --- 1. Install Rust Programming Language ---
echo "--- Installing Rust Programming Language ---"
# Install rustup and the Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Update your shell environment for the current session
# This ensures cargo and rustc commands are immediately available
source "$HOME/.cargo/env"
echo "Rust installation complete. PATH updated for current session."

# --- 2. Install Essential Build Tools ---
echo "--- Installing Essential Build Tools ---"
# Update package lists
sudo apt update

# Install build-essential (includes gcc, g++, make)
sudo apt install -y build-essential
echo "Build essential tools installed."

# --- 3. Install Additional Development Dependencies ---
echo "--- Installing Additional Development Dependencies (Perl, OpenSSL dev, pkg-config) ---"
sudo apt-get install -y \
    perl \
    perl-base \
    perl-modules \
    libssl-dev \
    pkg-config
echo "Additional development dependencies installed."

# --- 4. Install libudev-dev ---
echo "--- Installing libudev-dev ---"
sudo apt-get install -y libudev-dev
echo "libudev-dev installed."

# --- 5. Install Docker ---
echo "--- Installing Docker ---"
# Install necessary packages for Docker's repository
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "Docker GPG key added."

# Set up the stable Docker repository
# Note: The 'echo' command for adding the repository was duplicated in the original input.
# This script includes it only once.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Docker repository added."

# Update apt package index again after adding the new repository
sudo apt-get update

# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
echo "Docker Engine installed."

# Add user to docker group
sudo usermod -aG docker "$USER"
echo "User '$USER' added to the 'docker' group. IMPORTANT: You must log out and log back in (or reboot) for this change to take effect."

# --- 6. Install Docker Compose ---
echo "--- Installing Docker Compose ---"
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose

# Change ownership (optional but good practice)
sudo chown "$USER" /usr/local/bin/docker-compose
echo "Docker Compose downloaded and permissions set."

# Verify Docker Compose installation
echo "Verifying Docker Compose installation:"
docker-compose --version

echo "Development environment setup complete!"
echo "Remember to log out and log back in (or reboot) to apply Docker group changes."
