#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix

set -euo pipefail

latest_tag="$(
  curl -sIL https://github.com/cake-tech/cake_wallet/releases/latest |
    awk -F': ' '/^location:/I {print $2}' |
    tr -d '\r' |
    tail -n1
)"

version="${latest_tag##*/}"
version="${version#v}"

tarball_url="https://github.com/cake-tech/cake_wallet/releases/download/v${version}/Cake_Wallet_v${version}_Linux.tar.xz"

if ! curl -sfI "$tarball_url" >/dev/null; then
  echo "Tarball not found for version $version, skipping update"
  exit 0
fi

hash="$(nix-prefetch-url --type sha256 "$tarball_url")"

update-source-version cake-wallet "$version" "$hash"
