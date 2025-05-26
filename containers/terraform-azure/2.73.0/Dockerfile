FROM armck/terraform:1.10.5

ARG AZURE_CLI_VERSION=2.73.0

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/container \
    && cd /tmp/container \
    # signing key locations
    && mkdir -p /etc/apt/keyrings \
    # supporting installs
    && apt update && apt install -y \
        libicu-dev \
    # microsoft signing keys & registry for azure-cli
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    # primary installs
    && apt update && ACCEPT_EULA=Y apt install -y  \
        azure-cli=${AZURE_CLI_VERSION}-1~$(lsb_release -cs) \
        jq \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# switch back to dialog for any ad-hoc use of apt 
ENV DEBIAN_FRONTEND=dialog
