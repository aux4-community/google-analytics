#!/bin/bash
# Builds a GA4 report request and calls the Analytics Data API.
# Usage: run-report.sh <propertyId> <startDate> <endDate> <dimensions> <metrics> [limit]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PROPERTY_ID="$1"
START_DATE="$2"
END_DATE="$3"
DIMENSIONS="$4"
METRICS="$5"
LIMIT="${6:-10000}"

BODY=$(jq -n \
  --arg sd "$START_DATE" \
  --arg ed "$END_DATE" \
  --arg dims "$DIMENSIONS" \
  --arg mets "$METRICS" \
  --argjson lim "$LIMIT" \
  '{
    dateRanges: [{startDate: $sd, endDate: $ed}],
    dimensions: [$dims | split(",") | .[] | select(. != "") | {name: .}],
    metrics: [$mets | split(",") | .[] | select(. != "") | {name: .}],
    limit: $lim
  }')

"$SCRIPT_DIR/gapi.sh" POST "https://analyticsdata.googleapis.com/v1beta/properties/${PROPERTY_ID}:runReport" "$BODY"
