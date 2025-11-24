FROM ubuntu:24.04

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
        wget \
        gnupg-agent \
        lsb-release \
        software-properties-common \
    # docker signing keys
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    # primary installs
    && apt update && apt install -y \
        docker-ce-cli \
        git \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# Install Antigravity server
ARG ANTIGRAVITY_COMMIT=afdb915a7890576374cec17dccf6d91249170a86
ARG ANTIGRAVITY_VERSION=1.11.5
RUN mkdir -p /root/.antigravity-server/bin/${ANTIGRAVITY_COMMIT} \
    && wget -q https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/${ANTIGRAVITY_VERSION}-${ANTIGRAVITY_COMMIT}/linux-arm/Antigravity-reh.tar.gz -O /tmp/vscode-server.tar.gz \
    && tar -xf /tmp/vscode-server.tar.gz -C /root/.antigravity-server/bin/${ANTIGRAVITY_COMMIT} --strip-components 1 \
    && rm /tmp/vscode-server.tar.gz

WORKDIR ${WORKSPACE}

# switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
