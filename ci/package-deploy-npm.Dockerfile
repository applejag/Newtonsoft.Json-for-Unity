FROM node:13.1.0-buster-slim

# Should correspond to the image tag
ARG IMAGE_VERSION
ENV IMAGE_VERSION=${IMAGE_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git=1:2.20.1-2 \
        ssh=1:7.9p1-10+deb10u1 \
        jq=1.5+dfsg-2+b1 \
    # Cleanup cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "bash" ]
