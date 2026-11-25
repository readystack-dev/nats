#!/bin/sh
# ReadyStack NATS entrypoint: client connections need a user name and password from the first start.
# NATS_PASSWORD (and NATS_USER, default nats) become the one user of the server's global account. They are written,
# quoted, into a runtime copy of /etc/nats/nats-server.conf readable only by the nats user, so the password is never on
# nats-server's command line (which `ps` on the Docker host shows to every host user) and is never re-parsed as NATS
# config syntax (a $VAR reference parses the value: a numeric or spaced password breaks the server's start).
# Without NATS_PASSWORD it exits with an error, unless ALLOW_NONE_AUTHENTICATION=yes, which starts without
# authentication. Arguments after the image name are passed to nats-server.
set -e
CONF=/etc/nats/nats-server.conf
if [ "${ALLOW_NONE_AUTHENTICATION:-no}" = "yes" ]; then
  echo "nats: ALLOW_NONE_AUTHENTICATION=yes: starting WITHOUT authentication; anyone who can reach port 4222 can publish and subscribe on every subject and use JetStream" >&2
  exec nats-server -c "$CONF" "$@"
fi
if [ -z "${NATS_PASSWORD:-}" ]; then
  echo "nats: set NATS_PASSWORD (clients then log in as ${NATS_USER:-nats} with it), or ALLOW_NONE_AUTHENTICATION=yes to run without authentication" >&2
  exit 1
fi
case "${NATS_USER:-nats}${NATS_PASSWORD}" in
  *'
'*) echo "nats: NATS_USER and NATS_PASSWORD must not contain a newline" >&2; exit 1 ;;
esac
q() { printf '%s' "$1" | sed 's/[\\"]/\\&/g'; }
RUN_CONF=/var/lib/nats/nats-server.conf
umask 077
{
  cat "$CONF"
  printf '\nauthorization {\n  user: "%s"\n  password: "%s"\n}\n' "$(q "${NATS_USER:-nats}")" "$(q "$NATS_PASSWORD")"
} > "$RUN_CONF"
exec nats-server -c "$RUN_CONF" "$@"
