FROM alpine:3.20

RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    openssh-client \
    rsync \
    && update-ca-certificates
