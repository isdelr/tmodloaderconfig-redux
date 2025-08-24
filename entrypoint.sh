#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# Define the data directory and the user's home directory
TMOD_DIR="/home/tml/.local/share/Terraria/tModLoader"
TML_HOME="/home/tml"

# Ensure the directories exist and set correct permissions.
# This script runs as root, so it can fix the ownership of the mounted volume and home dir.
echo ">> Ensuring correct permissions on data directory: $TMOD_DIR"
mkdir -p "$TMOD_DIR"
chown -R tml:tml "$TML_HOME" # Change ownership of the entire home directory

# Drop root privileges and execute the command passed to the container (the CMD or docker-compose command).
# The "$@" represents all arguments passed to this script.
echo ">> Dropping root privileges and executing command..."
exec su-exec tml "$@"