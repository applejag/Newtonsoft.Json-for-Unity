FROM mcr.microsoft.com/dotnet/sdk:5.0.201-buster-slim-amd64

# Should correspond to the image tag
ARG IMAGE_VERSION
ENV IMAGE_VERSION=${IMAGE_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq=1.5+dfsg-2+b1 \
        xmlstarlet=1.6.1-2 \
    # Cleanup cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

