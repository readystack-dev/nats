# GENERATED L-009 hermetic build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases from BASE_IMAGE_DIGESTS.lock; vendored Go tree + debs from Dockerfile.vendor.
FROM golang:1.27.4-bookworm@sha256:4fa7c968ba93f1635670522dbb01a2c78150443e1385746924566079f36570ea AS build_nats-server
WORKDIR /src
COPY vendored/nats-src/ .
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161145
RUN go build -trimpath -ldflags='-w -X github.com/nats-io/nats-server/v2/server.gitCommit=2a9066e -X github.com/nats-io/nats-server/v2/server.serverVersion=v2.15.3' -o /nats-server . && /nats-server --version > /tmp/nats-server.version 2>&1; cat /tmp/nats-server.version; grep -qF 'nats-server: v2.15.3' /tmp/nats-server.version || { echo 'nats-server --version does not report nats-server: v2.15.3'; exit 1; } && \
    { readelf -lW /nats-server | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /nats-server | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /nats-server.needs
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.27.4-bookworm@sha256:4fa7c968ba93f1635670522dbb01a2c78150443e1385746924566079f36570ea AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161145
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rootfs
ARG SOURCE_DATE_EPOCH=1795161145
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'nats:x:999:999::/var/lib/nats:/bin/sh\n' >> /rootfs/etc/passwd && printf 'nats:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/var/lib/nats /rootfs/data && chown -R 999:999 /rootfs/var/lib/nats /rootfs/data
COPY --from=build_nats-server /nats-server /rootfs/usr/bin/nats-server
COPY --from=build_nats-server /nats-server.needs /tmp/needs/nats-server
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY nats-server.conf /rootfs/etc/nats/nats-server.conf
COPY readystack-entrypoint.sh /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN chmod 755 /rootfs/usr/bin/nats-server /rootfs/usr/local/bin/rs-probe && \
    chown 999:999 /rootfs/etc/nats/nats-server.conf && \
    chown 999:999 /rootfs/usr/local/bin/readystack-entrypoint.sh && \
    chmod 0644 /rootfs/etc/nats/nats-server.conf && \
    chmod 0755 /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1795161145
COPY --from=rootfs /rootfs/ /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.title="NATS"
LABEL org.opencontainers.image.description="NATS is a fast, lightweight messaging system for services, devices and edge applications: publish/subscribe, request/reply and, with JetStream, persistent streams and key-value stores. This image runs one NATS server with JetStream on, and client connections need a password from the first start."
LABEL org.opencontainers.image.source="https://github.com/nats-io/nats-server"
LABEL org.opencontainers.image.version="v2.15.3-CE-ubuntu24.04-r4"
LABEL org.opencontainers.image.revision="2a9066eb57ff4aa50d8e6a979bdfbd6a8b9db251"
HEALTHCHECK --interval=5s --timeout=10s --start-period=15s \
  CMD /usr/local/bin/rs-probe http://127.0.0.1:8222/healthz || exit 1
WORKDIR /var/lib/nats
USER nats
EXPOSE 4222 8222
ENTRYPOINT ["/usr/local/bin/readystack-entrypoint.sh"]
