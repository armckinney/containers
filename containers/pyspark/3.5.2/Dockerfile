FROM armck/python:3.12.3

ARG SPARK_VERSION=3.5.2
ARG ZULU_VERSION=17.54.21
ARG JDK_VERSION=17.0.13

# avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive 

RUN mkdir /tmp/container \
    && cd /tmp/container \
    # install java major version to match databricks 16.4 runtime
    && curl -O https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JDK_VERSION}-linux_$(dpkg --print-architecture).deb \
    && apt update && apt -y install \
        ./zulu${ZULU_VERSION}-ca-jdk${JDK_VERSION}-linux_$(dpkg --print-architecture).deb \
    # install pyspark
    && pipx install pyspark==${SPARK_VERSION} \
    # cleanup
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/container

# switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog

ENV PYSPARK_PIN_THREAD=true
