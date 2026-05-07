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

Log in to the Forgejo container registry first:

```sh
docker login 10.0.0.130:3000
```

Build and push the version tag:

```sh
REGISTRY=10.0.0.130:3000 OWNER=chius TAG=3.20 sh scripts/build-and-push.sh
```

Optionally also push `latest`:

```sh
REGISTRY=10.0.0.130:3000 OWNER=chius TAG=3.20 PUSH_LATEST=1 sh scripts/build-and-push.sh
```

If Forgejo is served over plain HTTP, Docker must trust it as an insecure registry on both the build host and the Forgejo Runner host:

```json
{
  "insecure-registries": ["10.0.0.130:3000"]
}
```

After changing Docker daemon configuration, restart Docker and log in again.

## Forgejo Runner Label

Use a dedicated label so deployment jobs do not affect existing `alpine` jobs:

```yaml
runner:
  labels:
    - alpine-pro:docker://10.0.0.130:3000/chius/alpine-pro:3.20
```

Use it in workflows:

```yaml
runs-on: alpine-pro
```

Prefer a version tag or digest in runner configuration. Forgejo Runner caches pulled images, so `latest` is convenient for publishing but not ideal as the runner's stable runtime reference.
