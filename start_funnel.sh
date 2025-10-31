#!/usr/bin/env bash
sudo tailscale funnel --bg --set-path=/szabfun localhost:3000
sudo tailscale funnel --bg --set-path=/cdn localhost:911
