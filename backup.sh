#!/usr/bin/env bash
set -euo pipefail

goat() {
    go run github.com/bluesky-social/goat@latest "$@"
}

ACCOUNT="${1#@}"

rm -f "$ACCOUNT".car
goat repo export -o "$ACCOUNT".car "$ACCOUNT"
goat blob export "$ACCOUNT"
goat resolve "$ACCOUNT" > "$ACCOUNT".json
if jq -e '.id | startswith("did:plc:")' "$ACCOUNT".json; then
    goat plc data "$ACCOUNT" > "$ACCOUNT"_plc.json
    goat plc history "$ACCOUNT" > "$ACCOUNT"_plc_history.jsonc
fi
