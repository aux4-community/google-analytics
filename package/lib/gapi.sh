#!/bin/bash
# Google API helper — authenticates using gws credentials and calls REST APIs.
# Usage: gapi.sh <METHOD> <URL> [JSON_BODY]

set -euo pipefail

METHOD="$1"
URL="$2"
BODY="${3:-}"

# Use pre-set token if available
if [ -n "${GOOGLE_WORKSPACE_CLI_TOKEN:-}" ]; then
  TOKEN="$GOOGLE_WORKSPACE_CLI_TOKEN"
else
  CREDS=$(gws auth export --unmasked 2>/dev/null) || {
    echo '{"error": {"message": "No credentials found. Run: aux4 google auth login --scopes https://www.googleapis.com/auth/analytics.readonly"}}' >&2
    exit 2
  }

  CLIENT_ID=$(echo "$CREDS" | jq -r '.client_id')
  CLIENT_SECRET=$(echo "$CREDS" | jq -r '.client_secret')
  REFRESH_TOKEN=$(echo "$CREDS" | jq -r '.refresh_token')

  TOKEN_RESP=$(curl -sf -X POST https://oauth2.googleapis.com/token \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "refresh_token=$REFRESH_TOKEN" \
    -d "grant_type=refresh_token") || {
    echo '{"error": {"message": "Token refresh failed. Try: aux4 google auth login"}}' >&2
    exit 2
  }

  TOKEN=$(echo "$TOKEN_RESP" | jq -r '.access_token')
  if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo '{"error": {"message": "Could not obtain access token"}}' >&2
    exit 2
  fi
fi

if [ -n "$BODY" ]; then
  curl -s -X "$METHOD" "$URL" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$BODY"
else
  curl -s -X "$METHOD" "$URL" \
    -H "Authorization: Bearer $TOKEN"
fi
