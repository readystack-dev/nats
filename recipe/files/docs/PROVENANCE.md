# Provenance — NATS (`v2.15.3-CE-ubuntu24.04-r4`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/nats-io/nats-server
- Revision built: `v2.15.3` (commit `2a9066eb57ff4aa50d8e6a979bdfbd6a8b9db251`)
- Source tree: `5b9cc2ec65654263c7b6900c150bd7fcbc5496b880f245a3d82459e96b491718` over 598 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-go`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795161145` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/nats:v2.15.3-CE-ubuntu24.04-r4` — index digest `sha256:cd22849d98dbef08a2a3bfe70f7b9d2ab8d05f197da9dae6ad72c69026e6e459` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:e5c217c74be63601239bfa718a66fb550f8c7181c006169ce5416157561a6edc` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/nats:v2.15.3-CE-ubuntu24.04-r4`

## Pinned inputs, and why

- 20 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 3, image digests 2, dependency versions readystack sets 1, pins in the kit's dockerfiles 5, readystack's build engine 5, dependencies upstream chose 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.trail.json`, published beside this archive and signed with the release key (`ReadyStack-nats-v2.15.3-CE-ubuntu24.04-r4.trail.json.sigstore`), and readable at https://readystack.dev/products/nats/trail/v2.15.3-CE-ubuntu24.04-r4.

