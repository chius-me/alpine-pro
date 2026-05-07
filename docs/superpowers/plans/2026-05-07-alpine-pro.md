# Alpine Pro Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reusable Alpine deployment image for Forgejo Actions jobs.

**Architecture:** The repository contains a minimal Dockerfile, a smoke test that builds and validates the image, a push script for Forgejo Container Registry, and README usage instructions. Forgejo Runner consumes the image through the dedicated `alpine-pro` label.

**Tech Stack:** Alpine Linux, Docker/OCI image, POSIX shell, Forgejo Container Registry, Forgejo Runner labels.

---

## File Structure

- Create: `Dockerfile` to define the runtime image.
- Create: `tests/smoke.sh` to build and validate the image.
- Create: `scripts/build-and-push.sh` to publish version and optional `latest` tags.
- Modify: `README.md` to document build, push, and runner usage.
- Create: `docs/superpowers/specs/2026-05-07-alpine-pro-design.md` to record the approved design.

### Task 1: Smoke Test

**Files:**
- Create: `tests/smoke.sh`

- [ ] **Step 1: Write the failing smoke test**

```sh
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh tests/smoke.sh`
Expected: FAIL because `Dockerfile` does not exist yet.

### Task 2: Docker Image

**Files:**
- Create: `Dockerfile`

- [ ] **Step 1: Write minimal Dockerfile**

```dockerfile
FROM alpine:3.20

RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    openssh-client \
    rsync \
    && update-ca-certificates
```

- [ ] **Step 2: Run smoke test to verify it passes**

Run: `sh tests/smoke.sh`
Expected: PASS and prints tool versions.

### Task 3: Publish Helper

**Files:**
- Create: `scripts/build-and-push.sh`

- [ ] **Step 1: Add publishing script**

```sh
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
```

- [ ] **Step 2: Validate shell syntax**

Run: `sh -n scripts/build-and-push.sh`
Expected: PASS with no output.

### Task 4: Documentation

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Document usage**

```md
# alpine-pro

Small Alpine-based deployment image for Forgejo Actions jobs.

Included tools:

- `ca-certificates`
- `git`
- `openssh-client`
- `rsync`
- `curl`

## Test

```sh
sh tests/smoke.sh
```

## Build And Push

```sh
docker login 10.0.0.130:3000
REGISTRY=10.0.0.130:3000 OWNER=chius TAG=3.20 PUSH_LATEST=1 sh scripts/build-and-push.sh
```

## Forgejo Runner Label

```yaml
runner:
  labels:
    - alpine-pro:docker://10.0.0.130:3000/chius/alpine-pro:3.20
```

Use it in workflows:

```yaml
runs-on: alpine-pro
```
```

- [ ] **Step 2: Validate docs are readable**

Run: `git diff -- README.md`
Expected: README contains package list, smoke test command, push command, and runner label.

### Task 5: Final Verification

**Files:**
- Verify all files in repository

- [ ] **Step 1: Run all checks**

Run: `sh tests/smoke.sh && sh -n scripts/build-and-push.sh`
Expected: PASS.

- [ ] **Step 2: Inspect git status**

Run: `git status --short`
Expected: changed files are limited to the Docker image project files.

## Self-Review

- Spec coverage: Image contents, runner label, publishing, and verification are all covered by tasks.
- Placeholder scan: No placeholders remain.
- Type consistency: Shell variable names and file paths are consistent across tasks.
