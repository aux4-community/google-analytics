#### Description

The `google analytics` command group provides access to Google Analytics 4 (GA4) reporting through the Analytics Data API. Every request is signed with the shared Google OAuth2 token that `community/google-auth` maintains, so there is nothing to configure beyond a single login.

Available subcommands:

- **report** — Run a standard GA4 report with dimensions, metrics, and date ranges
- **realtime** — Run a realtime report for the last 30 minutes
- **metadata** — List available dimensions and metrics for a property

#### Prerequisites

Authenticate once before first use. Scopes are resolved from the installed Google service packages, so no `--scopes` flag is required:

```bash
aux4 google auth login
```

This package requests `https://www.googleapis.com/auth/analytics.readonly`, which is enough for every command it exposes. That scope is already read-only, so `aux4 google auth login --readonly true` requests exactly the same thing.

The token is read from `~/.aux4.config/.oauth/google.json`. Override it per command with `--tokenFile`, or for the whole shell with the `AUX4_GOOGLE_TOKEN_FILE` environment variable.

#### Usage

```bash
aux4 google analytics <subcommand>
```

#### Example

```bash
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today
aux4 google analytics realtime 123456789
aux4 google analytics metadata 123456789
```
