#!/bin/bash

REMOTE="admin@192.168.10.12"
VERSION="tailscale_1.90.4"
REMOTE_DIR="/share/BACKUP/$VERSION"
MAX_RETRIES=3
RETRY_DELAY=60

# Kill old tailscaled / tailscale processes
ssh -o ConnectTimeout=10 "$REMOTE" "
  ps | grep 'tailscaled' | grep -v grep | awk '{print \$1}' | xargs kill 2>/dev/null || true
  ps | grep 'tailscale up' | grep -v grep | awk '{print \$1}' | xargs kill 2>/dev/null || true
  sleep 2
"

attempt=1
while (( attempt <= MAX_RETRIES )); do
  echo "[$(date)] Attempt $attempt: starting remote tailscaled ($VERSION)..."

  # Start tailscaled detached
  ssh -o ConnectTimeout=10 "$REMOTE" "bash -s" < /usr/local/bin/tailscaled_script_one.sh "$VERSION"
  sleep 3  # wait for daemon to initialize

  # Bring up the interface using persistent state
  ssh -o ConnectTimeout=10 "$REMOTE" "bash -s" < /usr/local/bin/tailscaled_script_two.sh "$VERSION"

  # Check if tailscaled socket exists (simple health check)
  if ssh "$REMOTE" "[ -S /tmp/tailscale/tailscaled.sock ]"; then
    echo "[$(date)] Remote tailscale $VERSION started successfully."
    exit 0
  else
    echo "[$(date)] SSH connection or daemon failed, retrying in $RETRY_DELAY seconds..."
    ((attempt++))
    sleep $RETRY_DELAY
  fi
done

echo "[$(date)] All $MAX_RETRIES attempts failed for $VERSION."
exit 1
