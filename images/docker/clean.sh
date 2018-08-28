#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

log::m-info "Removing dependencies ..."
apt-get purge -y --auto-remove \
    ca-certificates \
    python-dev \
    iputils-ping \
    build-essential \
    cmake \
    pkg-config \
    protobuf-compiler \
    debhelper \
    git

log::m-info "Cleaning up ..."
apt-clean --aggressive
rm -rf /tmp/sems
rm -rf /tmp/yeti-management
rm -rf /tmp/sems-yeti

# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"