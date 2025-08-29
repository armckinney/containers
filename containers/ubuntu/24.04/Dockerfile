FROM ubuntu:24.04

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/container \
    && cd /tmp/container \
    && apt update \
    # primary installs
    && apt -y install --no-install-recommends \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        curl \
        dialog \
        git \
        gnupg \
        lsb-release \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
