#!/bin/bash
VERSION="$1"
cd "/share/BACKUP/$VERSION" || exit 1

chmod +x ./tailscaled
STATE_FILE="/share/BACKUP/tailscale_state"
LOG_FILE="/tmp/tailscale-logs/tailscaled.log"

# start detached (double-fork for NAS shell)
( ./tailscaled --state="$STATE_FILE" --socket=/tmp/tailscale/tailscaled.sock >"$LOG_FILE" 2>&1 & ) &
sleep 2
