FROM ubuntu:18.04

# Should correspond to the image tag
ARG IMAGE_VERSION
ENV IMAGE_VERSION=${IMAGE_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq=1.5+dfsg-2 \
        git=1:2.17.1-1ubuntu0.7 \
        ssh=1:7.6p1-4ubuntu0.3 \
        gpg=2.2.4-1ubuntu1.2 \
        gpg-agent=2.2.4-1ubuntu1.2 \
        ca-certificates=20180409 \
    # Cleanup cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
