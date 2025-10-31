#!/bin/bash
VERSION="$1"
cd "/share/BACKUP/$VERSION" || exit 1

chmod +x ./tailscale
./tailscale up
