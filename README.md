# NATS: ReadyStack build kit

The offline build kit for the Docker image `readystack/nats:v2.15.3-CE-ubuntu24.04-r4`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v2.15.3-CE-ubuntu24.04-r4](https://github.com/readystack-dev/nats/releases/tag/v2.15.3-CE-ubuntu24.04-r4)
- Image: [`docker.io/readystack/nats:v2.15.3-CE-ubuntu24.04-r4`](https://hub.docker.com/r/readystack/nats/tags), manifest digest `sha256:e5c217c74be63601239bfa718a66fb550f8c7181c006169ce5416157561a6edc`
- Product page: https://readystack.dev/products/nats
- Source and build recipe: https://readystack.dev/products/nats/recipe
- Build trail: https://readystack.dev/products/nats/trail/v2.15.3-CE-ubuntu24.04-r4
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=nats

## The image

A single container running one NATS server (nats-server, one static Go binary) as the non-root nats user, with JetStream on. JetStream state is files under /data/jetstream; there is no separate database, no sidecar and no web UI. The nats command-line client is not in the image: use it (or any NATS client library) from outside, or the HTTP monitoring endpoints on port 8222.

## Who uses NATS and why

Developers and platform teams who connect services, edge devices and IoT systems through messaging.

NATS is a simple, secure, open-source messaging system. Applications connect to a NATS server and exchange messages by subject, without knowing each other's network addresses.

A typical use: A team splits an application into small services. Instead of each service keeping a list of the others' addresses, services publish and subscribe on named NATS subjects; a new service joins by subscribing, and nothing else has to be reconfigured.

From the upstream project's own description: https://github.com/nats-io/nats-server, https://docs.nats.io/nats-concepts/what-is-nats.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-22 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 11 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`nats`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-22; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/nats.

NATS is distributed under its upstream licence (Apache-2.0); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v2.15.3-CE-ubuntu24.04-r4 release](https://github.com/readystack-dev/nats/releases/tag/v2.15.3-CE-ubuntu24.04-r4): `ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.tar.gz` (440.7 MB), SHA-256 `e1222cbc4a09052a09880ad5c417c4c6a17e81d68c9a22f25bf744ece605a000`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.rebuild.json.sigstore ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.tar.gz
cd v2.15.3-CE-ubuntu24.04-r4
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/nats/recipe. The complete kit is the release download. Each release is a tag here.

— ReadyStack · https://readystack.dev
