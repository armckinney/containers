FROM ghcr.io/armckinney/ubuntu:24.04

# set workspace directory
ARG WORKSPACE=/workspaces/containers
ENV WORKSPACE=${WORKSPACE}

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/container \
    && cd /tmp/container \
    # signing key locations
    && mkdir -p /etc/apt/keyrings \
    # supporting installs
    && apt update && apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        lsb-release \
        nodejs \
        npm \
        software-properties-common \
        wget \
    # primary installs
    && apt update && apt install -y \
        git \
    # install devcontainer cli
    && npm install -g @devcontainers/cli \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# standard config path used by copilot feature, required for testing
RUN mkdir -p /root/.config/gh

WORKDIR ${WORKSPACE}

# switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
