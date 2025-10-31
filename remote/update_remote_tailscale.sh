#!/bin/bash
set -e

# Destination folder
DEST="/mnt/nas/backup"
mkdir -p "$DEST"

# Clean old tailscale folders and tgz
echo "Cleaning old Tailscale versions..."
find "$DEST" -maxdepth 1 -type d -name "tailscale_*" ! -name "tailscale_state" -exec rm -rf {} +
find "$DEST" -maxdepth 1 -type f -name "tailscale_*.tgz" -delete

# Determine version
if [ -n "$1" ]; then
    VERSION="$1"  # Use argument directly
    echo "Using version from argument: $VERSION"
else
    # Get latest stable version from GitHub
    LATEST=$(curl -s https://api.github.com/repos/tailscale/tailscale/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    VERSION="${LATEST#v}"  # remove leading 'v'
    echo "Latest stable version: $VERSION"
fi

# Construct download URL
URL="https://pkgs.tailscale.com/stable/tailscale_${VERSION}_amd64.tgz"
echo "Downloading from: $URL"

# Download with curl, follow redirects, force TLS1.2
curl -L -k "$URL" -o "$DEST/tailscale_${VERSION}_amd64.tgz"

# Create folder for extraction
EXTRACT_DIR="$DEST/tailscale_$VERSION"
mkdir -p "$EXTRACT_DIR"

# Extract into versioned folder
tar -xzf "$DEST/tailscale_${VERSION}_amd64.tgz" -C "$EXTRACT_DIR" --strip-components=1

# Remove the tgz after extraction
rm -f "$DEST/tailscale_${VERSION}_amd64.tgz"

echo "Tailscale $VERSION downloaded and unpacked to $EXTRACT_DIR"

# Update start_remote_tailscale.sh
sed -i "s|^\(VERSION\s*=\s*\).*|\1\"tailscale_$VERSION\"|" "/usr/local/bin/start_remote_tailscale.sh"
echo "Systemd config file successfully edited to newest version"

# Restart service
systemctl restart remote-tailscale.service
echo "Systemd remote service restarted with new config"
