#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

log::m-info "Installing essentials ..."
apt-get update -qq
apt-get install -yqq \
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
    libspeex-dev \
    libgsm1-dev \
    iputils-ping \
    libmp3lame-dev \
    libopus-dev \
    libconfuse-dev \
    libprotobuf-dev \
    libsctp-dev \
    libevent-dev \
    libnanomsg-dev \
    libc-ares2

log::m-info "Installing packages ..."
cd /tmp
env
dpkg -i libsems1_${SEMS_VERSION}_amd64.deb
dpkg -i sems_${SEMS_VERSION}_amd64.deb
dpkg -i sems-sounds_${SEMS_VERSION}_amd64.deb
dpkg -i libyeticc_{$MANAGEMENT_VERSION}_amd64.deb
dpkg -i sems-modules-base_${SEMS_VERSION}_amd64.deb
dpkg -i sems-modules-yeti_${SEMS_YETI_VERSION}_amd64.deb

#Patch which creates directories if they don't exist
log::m-info "Creating necessary directories..."
if [[ ! -d /var/spool/sems ]]
echo "There are no dirictories in /var/spool/sems. Let's create some"
then
  for dir in "cdrs/completed" "dump" "record" "logdump"
    do
            mkdir -p /var/spool/sems/$dir
    done
  chown -R $USER:$USER "/var/spool/sems"
fi

log::m-info "Writing $APP config ..."
cat > /etc/sems/sems.conf <<EOF
interfaces=first
use_raw_sockets=no #глобально включаем raw сокеты если нужно

sip_ip_first=$SIP_ADDRESS
public_ip_first=$SIP_PUBLIC_ADDRESS
sip_port_first=$SIP_PORT
#sig_sock_opts_input = use_raw_sockets
media_ip_first=$SIP_ADDRESS
rtp_low_port_first=$RTP_LOW_PORT
rtp_high_port_first=$RTP_HIGH_PORT
media_sock_opts_first = use_raw_sockets #raw режим для rtp

plugin_path=/usr/lib/sems/plug-in/
load_plugins=$PLUGINS
application = yeti
plugin_config_path=/etc/sems/etc/
fork=$FORK
stderr=$STDERR
syslog_loglevel=2
max_shutdown_time = 100

session_processor_threads=50
media_processor_threads=2
session_limit="4000;509;Node overloaded"
shutdown_mode_reply="508 Node in shutdown mode"
options_session_limit="900;503;Warning, server soon overloaded"
# cps_limit="100;503;Server overload"
use_raw_sockets=yes
sip_timer_B = 8000
default_bl_ttl=0
registrations_enabled=yes

use_default_signature=no
signature="YETI SBC"
EOF

log::m-info "Writing $APP management config ..."
cat > /etc/sems/etc/yeti.conf <<EOF
node_id = $NODE_ID
cfg_timeout = $MANAGEMENT_TIMEOUT

cfg_urls = main
cfg_url_main = tcp://$MANAGEMENT_HOST:$MANAGEMENT_PORT
core_options_handling=yes
EOF

log::m-info "Writing $APP jsonrpc config ..."
cat > /etc/sems/etc/jsonrpc.conf <<EOF
# jsonrpc_listen  - json-rpc interface address to listen on
jsonrpc_listen=$JSONRPC_HOST
# jsonrpc_port  - json-rpc server port to listen on
jsonrpc_port=$JSONRPC_PORT
# server_threads  - json-rpc server threads to start
server_threads=$JSONRPC_THREADS
EOF

log::m-info "Cleaning up ..."
apt-clean --aggressive
rm -rf /tmp/*.deb

# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"
