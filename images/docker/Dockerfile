FROM telephoneorg/debian:jessie as builder
#Install dependencies
COPY install_build.sh /tmp/install_build.sh
RUN /tmp/install_build.sh

ARG SEMS_VERSION=1.7.72-6
ARG SEMS_YETI_VERSION=1.7.34-1
ARG MANAGEMENT_VERSION=1.2.1

#Build
COPY build.sh /tmp/build.sh
RUN /tmp/build.sh


FROM telephoneorg/debian:jessie

LABEL maintainer="Alexander Mustafin <mustafin.aleksandr@gmail.com>"

ARG SEMS_VERSION=1.7.72-6
ARG SEMS_YETI_VERSION=1.7.34-1
ARG MANAGEMENT_VERSION=1.2.1

ENV APP sems
ENV USER $APP
ENV HOME /etc/$APP

ENV SEMS_SIP_IP eth0
ENV SEMS_SIP_PORT 5061
ENV SEMS_SIP_PUBLIC_IP eth0
ENV SEMS_RTP_LOW_PORT 16000
ENV SEMS_RTP_HIGH_PORT 31999
ENV SEMS_PLUGINS "wav;ilbc;speex;gsm;adpcm;l16;g722;sctp_bus;yeti;session_timer;uac_auth;di_log;registrar_client;jsonrpc"
ENV SEMS_FORK yes
ENV SEMS_STDERR no
ENV SEMS_REGISTRATIONS_ENABLED no
ENV SEMS_MANAGEMENT_IP 127.0.0.1
ENV SEMS_MANAGEMENT_PORT 4444
ENV SEMS_MANAGEMENT_TIMEOUT 1000
ENV SEMS_NODE_ID 4
ENV SEMS_JSONRPC_IP 0.0.0.0
ENV SEMS_JSONRPC_PORT 7080
ENV SEMS_JSONRPC_THREADS 5
ENV SEMS_LOG_LEVEL 3

#Set working directory
WORKDIR $HOME

SHELL ["/bin/bash", "-lc"]

COPY --from=hairyhenderson/gomplate:v3.0.0-slim /gomplate /bin/gomplate
COPY --from=builder /tmp/*.deb /tmp/
COPY install_main.sh /tmp/
COPY templates/ /templates
RUN /tmp/install_main.sh

COPY entrypoint /

# The default command that gets ran will be to start the yeti-management daemon.
ENTRYPOINT ["/dumb-init", "--"]
CMD ["/entrypoint"]
