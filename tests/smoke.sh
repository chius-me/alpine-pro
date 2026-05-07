#!/bin/sh
set -eu

image="${IMAGE_NAME:-alpine-pro:test}"

if [ ! -f Dockerfile ]; then
  printf '%s\n' 'Dockerfile is required' >&2
  exit 1
fi
docker build -t "${image}" .
docker run --rm "${image}" sh -ec '
  test -f /etc/ssl/certs/ca-certificates.crt
  git --version
  ssh -V
  rsync --version >/dev/null
  curl --version >/dev/null
'
