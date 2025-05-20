FROM armck/ubuntu:24.04

ARG DOTNET_VERSION=8.0

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/container \
    && cd /tmp/container \
    && apt-get update \
    # supporting installs
    && apt-get install -y \
        apt-transport-https \
        wget \
    # add microsoft package signing key
    && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    # install .net
    && apt-get update \
    && ACCEPT_EULA=Y apt-get -y install --no-install-recommends \
        dotnet-sdk-${DOTNET_VERSION}  \
    # cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
