FROM armck/ubuntu-base:latest

# Set Workspace directory
ARG WORKSPACE=/workspaces/containers
ENV WORKSPACE=${WORKSPACE}

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/dockerinstall && cd /tmp/dockerinstall \
    #  Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/dockerinstall

WORKDIR ${WORKSPACE}
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
