FROM node:13.1.0-buster-slim

# Should correspond to the image tag
ARG IMAGE_VERSION
ENV IMAGE_VERSION=${IMAGE_VERSION}

ENTRYPOINT [ "bash" ]