
# Possible alterations of UNITY_VERSION argument, using example 2018.3.11f1:
# 2018.3.11f1				: all modules
# 2018.3.11f1-windows		: Windows module
# 2018.3.11f1-mac			: Mac OS X module
# 2018.3.11f1-ios			: iOS module
# 2018.3.11f1-android		: Android module
# 2018.3.11f1-webgl			: WebGL module
# 2018.3.11f1-facebook		: Facebook module
ARG UNITY_VERSION=2019.2.8f1
FROM gableroux/unity3d:${UNITY_VERSION}

# Should correspond to the image tag
ENV IMAGE_VERSION=v1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
    # Cleanup cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/repo