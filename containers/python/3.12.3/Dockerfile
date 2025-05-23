FROM armck/ubuntu:24.04

ARG PYTHON_VERSION=3.12.3
ARG UV_VERSION=0.7.6

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive 

RUN mkdir /tmp/container \
    && cd /tmp/container \
    # supporting installs
    && apt update && apt -y install \
        build-essential \
        gettext-base \
        git \
        libbz2-dev \
        libffi-dev \
        libgdbm-dev \
        libncurses5-dev \
        libnss3-dev \
        libreadline-dev \
        libssl-dev \
        unixodbc-dev \
        unzip \
        zip \
        zlib1g-dev \
    # install python
    && curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz \
    && tar -xf Python-$PYTHON_VERSION.tar.xz \
    && cd Python-$PYTHON_VERSION && ./configure --enable-optimizations \
    && make install \
    # install pipx
    && apt update && apt -y install \
        pipx \
        python3-venv \
    && pipx ensurepath \
    # install uv
    && pipx install uv==${UV_VERSION} \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

ENV PATH=$PATH:/root/.local/bin/

# switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
