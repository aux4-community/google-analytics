#### Description

The `google analytics` command group provides access to Google Analytics 4 (GA4) reporting through the Analytics Data API. It uses the same authentication credentials managed by `gws` (Google Workspace CLI), with custom OAuth scopes for Analytics access.

Available subcommands:

- **report** — Run a standard GA4 report with dimensions, metrics, and date ranges
- **realtime** — Run a realtime report for the last 30 minutes
- **metadata** — List available dimensions and metrics for a property

#### Prerequisites

Authenticate with Analytics scopes before first use:

```bash
aux4 google auth login --scopes https://www.googleapis.com/auth/analytics.readonly
```

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
