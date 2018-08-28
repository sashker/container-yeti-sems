#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

log::m-info "Installing essentials ..."
apt-get update -qq
apt-get install -yqq \
    ca-certificates \
    libssl-dev \
    libpqxx3-dev \
    libxml2-dev \
    libspandsp-dev \
    libsamplerate-dev \
    libcurl3-dev \
    libhiredis-dev \
    librtmp-dev \
    libzrtpcpp-dev \
    libev-dev \
    python-dev \
    libspeex-dev \
    libgsm1-dev \
    iputils-ping \
    build-essential \
    cmake \
    pkg-config \
    libmp3lame-dev \
    libopus-dev \
    libconfuse-dev \
    protobuf-compiler \
    libprotobuf-dev \
    libsctp-dev \
    libevent-dev \
    libnanomsg-dev \
    debhelper \
    pkg-kde-tools \
    git

# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"