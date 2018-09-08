# Containerized version of SEMS as a part of Yeti Switch Project
You may know what SEMS does in Yeti. If not - it's the crusial part which handles all SIP and media traffic. The robust and flexible
VoIP switch which makes Yeti so powerful.

Since SEMS has to open lots of random UDP ports for handling RTP, the only option to run in a Docker container is using --net=host. Otherwise (if you try to define a bunch of forwarded ports) it's gonna be a way slow, but you can try :)

# How to run
By default you can run it just using a command (though, there is not much practical sense )
    docker run -it -name yeti-sems -d sashker/container-yeti-sems:1.7.72-3

You have to define all essential environment variables so that SEMS could be run properly.
At least, specify next variables 
    docker run -it -name yeti-sems -d -e ENV NODE_ID 4 -e ENV MANAGEMENT_HOST 127.0.0.1 -e sashker/container-yeti-sems:1.7.72-3

# Debug mode
You alway may run a container in **debug** mode and look for errors in configuration
    docker run -it -name yeti-sems -d sashker/container-yeti-sems:1.7.72-3 sems -D3 -E

# Environment variables
A list of environment variables which are used for a making a configuration of SEMS. Most of them are self-descriptive and for others you my rely on default values, like the original configuration does.

SIP_ADDRESS eth0
SIP_PORT 5061
SIP_PUBLIC_ADDRESS eth0
RTP_LOW_PORT 16000
RTP_HIGH_PORT 32000
PLUGINS "wav;ilbc;speex;gsm;adpcm;l16;g722;sctp_bus;yeti;session_timer;uac_auth;di_log;registrar_client;jsonrpc"
FORK yes
STDERR no
REGISTRATION no
MANAGEMENT_HOST 127.0.0.1
MANAGEMENT_PORT 4444
MANAGEMENT_TIMEOUT 1000
NODE_ID 4
JSONRPC_HOST 0.0.0.0
JSONRPC_PORT 7080
JSONRPC_THREADS 5
LOG_LEVEL 3