<!-- header -->
<div align="center">
    <p>
    <!-- Header -->
        <img width="100px" src="https://img.stackshare.io/stack/979421/default_7b21deccd8ef4e667218f8a46721601eec9455f4.png"  alt="Containers" />
        <h2>Containers</h2>
        <p><i>A layered image vault.</i></p>
    </p>
    <p>
    <!-- Shields -->
        <a href="https://github.com/armckinney/containers/LICENSE.txt">
            <img alt="License" src="https://img.shields.io/github/license/armckinney/containers.svg" />
        </a>
        <a href="https://github.com/armckinney/containers/actions">
            <img alt="Tests Passing" src="https://github.com/armckinney/containers/workflows/Test/badge.svg" />
        </a>
        <a href="https://codecov.io/gh/armckinney/containers">
            <img src="https://codecov.io/gh/armckinney/containers/branch/master/graph/badge.svg" />
        </a>
        <a href="https://github.com/armckinney/containers/issues">
            <img alt="Issues" src="https://img.shields.io/github/issues/armckinney/containers" />
        </a>
        <a href="https://github.com/armckinney/containers/pulls">
            <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/armckinney/containers" />
        </a>
        <a href="https://stackshare.io/armck/containers">
            <img alt="StackShare.io" src="http://img.shields.io/badge/tech-stack-0690fa.svg?label=StackShare.io">
        </a>
    </p>
    <p>
    <!-- Links -->
        <a href="https://github.com/armckinney/containers/issues/new/choose">Report Bug</a>
        ·
        <a href="https://github.com/armckinney/containers/issues/new/choose">Request Feature</a>
    </p>
</div>
<br>
<br>

<!-- Description -->
Containers is a repository of standardized `Dockerfiles` that are built into images and hosted on [DockerHub](https://hub.docker.com/).
Many of these images are built on top of each other (i.e. `Ubuntu` > `Python` > `Pyspark`).

I utilize these images as well as various GitHub `template-repositories` in order to spin up standardized projects quick and seemless!

### Quick Start

Use these hosted images in your Dockerfile by identifying the desired base image; follows standard image syntax `<dockerhub-account>/<image>:<tag>`.

###### Dockerfile:
```dockerfile
FROM armck/ubuntu:24.04

RUN other_cool_things.exe
...
```

View all of these images hosted at my dockerhub account, [armck](https://hub.docker.com/u/armck).

### Usage

These images can be manually copied or downloaded from GitHub for individual use, or you can just build on top of them with the publicly hosted iamges.

### Contributing
When adding new images to the repository, ensure the `image` and `version` are both defined in the [DockerPush](.github\workflows\docker-push.yml) workflow.

A brief documentation summary should also be included in [docs](containers\README.md).
