#!/bin/bash
set -e

if ! pgrep -x dockerd >/dev/null 2>&1; then
    mkdir -p /var/log
    dockerd \
        --host=unix:///var/run/docker.sock \
        --storage-driver=vfs \
        >/var/log/dockerd.log 2>&1 &

    # Wait for the daemon socket to appear so docker commands work immediately.
    for i in $(seq 1 60); do
        if [ -S /var/run/docker.sock ]; then
            break
        fi
        sleep 1
    done

    if [ ! -S /var/run/docker.sock ]; then
        echo "dockerd failed to start. Last daemon log lines:" >&2
        tail -n 100 /var/log/dockerd.log >&2 || true
        exit 1
    fi
fi

exec "$@"