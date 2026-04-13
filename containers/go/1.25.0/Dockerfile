FROM ghcr.io/armckinney/ubuntu:24.04

ARG GO_VERSION=1.25.0

ENV GOPATH=/go
ENV PATH=/usr/local/go/bin:${GOPATH}/bin:${PATH}

# make non-interactive for build
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/container \
    && cd /tmp/container \
    # supporting installs
    && apt update && apt install -y --no-install-recommends \
        wget \
        build-essential \
    # primary installs
    # install go
    && curl -L "https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz" | tar -C /usr/local -xz \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

WORKDIR ${WORKSPACE}

# restore dialog for interactive use
ENV DEBIAN_FRONTEND=dialog
