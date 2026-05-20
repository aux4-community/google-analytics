#!/bin/bash
# Builds a GA4 realtime report request and calls the Analytics Data API.
# Usage: run-realtime.sh <propertyId> <metrics> [dimensions] [limit]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PROPERTY_ID="$1"
METRICS="$2"
DIMENSIONS="${3:-}"
LIMIT="${4:-100}"

BODY=$(jq -n \
  --arg dims "$DIMENSIONS" \
  --arg mets "$METRICS" \
  --argjson lim "$LIMIT" \
  '{
    metrics: [$mets | split(",") | .[] | select(. != "") | {name: .}],
    limit: $lim
  } + if $dims != "" then {dimensions: [$dims | split(",") | .[] | {name: .}]} else {} end')

"$SCRIPT_DIR/gapi.sh" POST "https://analyticsdata.googleapis.com/v1beta/properties/${PROPERTY_ID}:runRealtimeReport" "$BODY"
