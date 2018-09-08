FROM telephoneorg/debian:jessie as builder
#Install dependencies
COPY install_build.sh /tmp/install_build.sh
RUN /tmp/install_build.sh

ARG SEMS_VERSION=1.7.72-3
ARG SEMS_YETI_VERSION=1.7.33-3p8
ARG MANAGEMENT_VERSION=1.2.1

#Build
COPY build.sh /tmp/build.sh
RUN /tmp/build.sh


FROM telephoneorg/debian:jessie

LABEL maintainer="Alexander Mustafin <mustafin.aleksandr@gmail.com>"

ARG SEMS_VERSION=1.7.72-3
ARG SEMS_YETI_VERSION=1.7.33-3p8
ARG MANAGEMENT_VERSION=1.2.1

ENV APP sems
ENV USER $APP
ENV HOME /etc/$APP

ENV SIP_ADDRESS eth0
ENV SIP_PORT 5061
ENV SIP_PUBLIC_ADDRESS eth0
ENV RTP_LOW_PORT 16000
ENV RTP_HIGH_PORT 32000
ENV PLUGINS "wav;ilbc;speex;gsm;adpcm;l16;g722;sctp_bus;yeti;session_timer;uac_auth;di_log;registrar_client;jsonrpc"
ENV FORK yes
ENV STDERR no
ENV REGISTRATION no
ENV MANAGEMENT_HOST 127.0.0.1
ENV MANAGEMENT_PORT 4444
ENV MANAGEMENT_TIMEOUT 1000
ENV NODE_ID 4
ENV JSONRPC_HOST 0.0.0.0
ENV JSONRPC_PORT 7080
ENV JSONRPC_THREADS 5
ENV LOG_LEVEL 3

#Set working directory
WORKDIR $HOME

SHELL ["/bin/bash", "-lc"]

COPY --from=builder /tmp/*.deb /tmp/
COPY install_main.sh /tmp/
RUN /tmp/install_main.sh

COPY entrypoint /

# The default command that gets ran will be to start the yeti-management daemon.
ENTRYPOINT ["/dumb-init", "--"]
CMD ["/entrypoint"]
