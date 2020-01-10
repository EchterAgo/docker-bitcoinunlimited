#!/bin/sh

set -e

umask u=rwx,g=rwx,o=

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bitcoind"
  set -- bitcoind "$@"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  chown -R $(id -u):$(id -g) "$BITCOIN_DATA"
  echo "$0: setting data directory to $BITCOIN_DATA"
  set -- "$@" -datadir="$BITCOIN_DATA"
fi

exec "$@"
