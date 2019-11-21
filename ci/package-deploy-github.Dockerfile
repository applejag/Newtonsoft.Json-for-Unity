FROM debian:10.1-slim

# Should correspond to the image tag
ARG IMAGE_VERSION
ENV IMAGE_VERSION=${IMAGE_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq=1.5+dfsg-2+b1 \
        git=1:2.20.1-2 \
    # Cleanup cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
