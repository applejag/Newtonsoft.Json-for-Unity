FROM mono:6.4.0.198

# Should correspond to the image tag
ENV IMAGE_VERSION=v1

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        jq

# Cleanup cache
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

