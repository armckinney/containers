FROM armck/ubuntu:24.04

ARG TERRAFORM_VERSION=1.10.5

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/container \
    && cd /tmp/container \
    # signing key locations
    && mkdir -p /etc/apt/keyrings \
    # supporting installs
    && apt update && apt install -y \
        software-properties-common \
    # terraform keys & registry
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o etc/apt/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    # primary installs
    && apt update && ACCEPT_EULA=Y apt install -y  \
        terraform=${TERRAFORM_VERSION}-1 \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
