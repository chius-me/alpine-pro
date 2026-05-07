#!/bin/sh
set -eu

: "${REGISTRY:?REGISTRY is required, for example 10.0.0.130}"
: "${OWNER:?OWNER is required, for example chius}"

IMAGE="${IMAGE:-alpine-pro}"
TAG="${TAG:-3.20}"
PUSH_LATEST="${PUSH_LATEST:-0}"
REF="${REGISTRY}/${OWNER}/${IMAGE}:${TAG}"

docker build -t "${REF}" .
docker push "${REF}"

if [ "${PUSH_LATEST}" = "1" ]; then
  latest_ref="${REGISTRY}/${OWNER}/${IMAGE}:latest"
  docker tag "${REF}" "${latest_ref}"
  docker push "${latest_ref}"
fi
