FROM mono:6.4.0.198

# Should correspond to the image tag
ARG IMAGE_VERSION
ENV IMAGE_VERSION=${IMAGE_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
    # Cleanup cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/repo
