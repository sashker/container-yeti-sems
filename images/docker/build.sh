#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

log::m-info "Cloning the project repo ..."
cd /tmp
git clone https://github.com/yeti-switch/sems.git
git clone https://github.com/yeti-switch/yeti-management.git
git clone https://github.com/yeti-switch/sems-yeti.git

log::m-info "Patches..."
cat > /usr/lib/x86_64-linux-gnu/pkgconfig/libsctp.pc <<EOF
prefix=/usr
exec_prefix=${prefix}
libdir=${prefix}/lib/x86_64-linux-gnu
includedir=${prefix}/include

Name: sctp
Description: User-level SCTP API library
Version: 1.0.16
Libs: -L${libdir} -lsctp
Cflags: -I${includedir}
EOF

log::m-info "Making SEMS ..."
cd /tmp/sems
bash package.sh
dpkg -i /tmp/libsems1_1.7.58-2_amd64.deb
dpkg -i /tmp/libsems1-dev_1.7.58-2_amd64.deb

log::m-info "Making yeti-management ..."
cd /tmp/yeti-management
mkdir build && cd build
cmake ..
make
make deb
dpkg -i /tmp/yeti-management/build/packages/client/libyeticc_1.0.17_amd64.deb
dpkg -i /tmp/yeti-management/build/packages/client-dev/libyeticc-dev_1.0.17_amd64.deb
cp /tmp/yeti-management/build/packages/client/libyeticc_1.0.17_amd64.deb /tmp/
cp /tmp/yeti-management/build/packages/client-dev/libyeticc-dev_1.0.17_amd64.deb /tmp/
cp /tmp/yeti-management/build/packages/server/*.deb /tmp/

log::m-info "Preparing sems-yeti ..."
cd /tmp/sems-yeti
bash package.sh

# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"