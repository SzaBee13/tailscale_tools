#!/bin/bash

TARGET="192.168.10.12"

# Wait until the host is reachable
while ! ping -c 1 -W 1 $TARGET >/dev/null 2>&1; do
    echo "$(date): $TARGET is down, waiting..."
    sleep 10
done

# Host is back up, restart the service
echo "$(date): $TARGET is back up, restarting remote-stuff..."
systemctl restart remote-tailscale.service
