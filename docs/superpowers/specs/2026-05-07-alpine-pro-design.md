# Alpine Pro Design

## Goal

Build a small Alpine-based container image for Forgejo Actions deployment jobs. The image removes the repeated runtime `apk add` step currently needed by deployment workflows.

## Image Contents

The image is based on a pinned Alpine release and includes only the deployment tools confirmed for current use:

- `ca-certificates`
- `git`
- `openssh-client`
- `rsync`
- `curl`

## Runner Integration

Forgejo Runner should expose a dedicated label named `alpine-pro`:

```yaml
runner:
  labels:
    - alpine-pro:docker://10.0.0.130:3000/chius/alpine-pro:3.20
```

Deployment workflows can then use:

```yaml
runs-on: alpine-pro
```

## Publishing

The image is published to Forgejo's container registry using the standard OCI naming format:

```text
10.0.0.130:3000/chius/alpine-pro:<tag>
```

Because this Forgejo instance is reachable over plain HTTP on port `3000`, Docker must configure `10.0.0.130:3000` as an insecure registry on the build host and on the Forgejo Runner host.

The recommended stable tag is the Alpine version, such as `3.20`. `latest` may be pushed for convenience, but runner configuration should prefer a version tag or digest because runner-pulled images are cached.

## Verification

A smoke test builds the image locally and verifies that `git`, `ssh`, `rsync`, `curl`, and CA certificates are available inside the container.
