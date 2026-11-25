# NATS v2.15.3 — ReadyStack release `v2.15.3-CE-ubuntu24.04-r4`

Generated 2026-11-22 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/nats:v2.15.3-CE-ubuntu24.04-r4` (linux/amd64). Index digest `sha256:cd22849d98dbef08a2a3bfe70f7b9d2ab8d05f197da9dae6ad72c69026e6e459` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:e5c217c74be63601239bfa718a66fb550f8c7181c006169ce5416157561a6edc` [`TARGET_DIGEST.txt`].
- **Upstream:** NATS v2.15.3 built from source at `v2.15.3` of https://github.com/nats-io/nats-server — upstream notes: https://github.com/nats-io/nats-server/releases/tag/v2.15.3 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `nats`.
- **Build:** `source-rebuild-go`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `v2.15.3-CE-ubuntu24.04-r3`.

## What changed in this release

- Upstream version unchanged (v2.15.3); ReadyStack rebuild.
- NATS v2.15.3 is unchanged from the release this supersedes (v2.15.3-CE-ubuntu24.04-r3); this release rebuilds it. Changes: the image is rebuilt on the current ubuntu:24.04 image (sha256:9c7f200c07e3…), which its maintainers updated after v2.15.3-CE-ubuntu24.04-r3 was built on sha256:2198e4c65076…. Settings, ports and data volumes are those of v2.15.3-CE-ubuntu24.04-r3: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-20)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `nats` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/nats:v2.15.3-CE-ubuntu24.04-r4` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Client traffic on port 4222 is plain TCP without TLS: the password and messages cross the network in clear text. Keep the port on a private network, or configure TLS with a configuration of your own.
- **Before exposing this service:** The HTTP monitoring port 8222 has no authentication: /varz, /connz and /subsz show server settings, client addresses and subscription counts to anyone who can reach it. Publish it only to a private network, or not at all.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:e5c217c74be63601239bfa718a66fb550f8c7181c006169ce5416157561a6edc`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 7 of 7 use cases passed (7 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- **medium** (upstream): Unauthenticated HTTP monitoring port 8222 by default [`RSD-nats-854f0791bd`]
- **low** (ReadyStack package): Admin handbook: The reading date of the upstream image's configuration is not a record of this release; the behaviour stated is true. [`RSD-nats-b3f24ab8b1`]

## Defects fixed

- 35 problems found before release and fixed before it shipped (35 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/nats:v2.15.3-CE-ubuntu24.04-r4
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

