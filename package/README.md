# community/google-analytics

Commands to interact with Google Analytics 4 (GA4) using the Analytics Data API

This package provides aux4 command wrappers for the [Google Analytics Data API](https://developers.google.com/analytics/devguides/reporting/data/v1) (GA4). It covers running standard reports with dimensions, metrics, and date ranges, querying realtime data, and discovering available dimensions and metrics for a property.

Authentication is handled by [community/google-auth](https://hub.aux4.io/package/community/google-auth), which stores a single OAuth2 token shared by every aux4 Google package.

## Installation

```bash
aux4 aux4 pkger install community/google-analytics
```

## System Dependencies

This package requires:

- **jq** — for turning comma-separated dimension and metric lists into API request bodies
  - [brew](https://brew.sh): `brew install jq`
  - linux: `apt install jq`

## Prerequisites

Authenticate once with `community/google-auth`. The scopes are resolved from the installed Google service packages, so no `--scopes` flag is needed:

```bash
aux4 google auth login
```

This package requests `https://www.googleapis.com/auth/analytics.readonly`, which is enough for every command it exposes. Because that scope is already read-only, `aux4 google auth login --readonly true` requests exactly the same thing.

Check the current state at any time:

```bash
aux4 google auth status
```

## Quick Start

Run a report for the last 7 days:

```bash
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today
```

Check realtime active users:

```bash
aux4 google analytics realtime 123456789
```

Discover available dimensions and metrics:

```bash
aux4 google analytics metadata 123456789
```

## Reports — query historical data

### Standard report

Run a report with default dimensions (date) and metrics (sessions, activeUsers):

```bash
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today
```

Specify custom dimensions and metrics:

```bash
aux4 google analytics report 123456789 --startDate 30daysAgo --endDate today --dimensions date,country --metrics sessions,screenPageViews --limit 100
```

Dates can be absolute (`YYYY-MM-DD`) or relative (`today`, `yesterday`, `7daysAgo`, `30daysAgo`, `90daysAgo`, `365daysAgo`).

### Common dimensions

- `date`, `dateHour` — time-based grouping
- `country`, `city`, `region` — geography
- `pagePath`, `pageTitle`, `landingPage` — content
- `sessionSource`, `sessionMedium`, `sessionCampaignName` — traffic source
- `deviceCategory`, `browser`, `operatingSystem` — technology

### Common metrics

- `sessions`, `activeUsers`, `newUsers` — audience
- `screenPageViews`, `averageSessionDuration`, `bounceRate` — engagement
- `conversions`, `totalRevenue` — conversions

Use `aux4 google analytics metadata <propertyId>` to see all available options.

## Realtime — live data

Check current active users:

```bash
aux4 google analytics realtime 123456789
```

Active users by country:

```bash
aux4 google analytics realtime 123456789 --metrics activeUsers --dimensions country
```

Active users by page:

```bash
aux4 google analytics realtime 123456789 --metrics activeUsers,screenPageViews --dimensions unifiedScreenName
```

## Metadata — discover dimensions and metrics

List all available dimensions and metrics for a property:

```bash
aux4 google analytics metadata 123456789
```

Filter to just dimension names:

```bash
aux4 google analytics metadata 123456789 | aux4 json get --path '$.dimensions' | aux4 2table --table apiName,uiName
```

## Finding your Property ID

Your GA4 property ID is a numeric identifier found in Google Analytics:

1. Go to [analytics.google.com](https://analytics.google.com)
2. Click **Admin** (gear icon)
3. Under **Property**, click **Property Settings**
4. The property ID is displayed at the top

## Environment Variables

- `AUX4_GOOGLE_TOKEN_FILE` — where the shared Google OAuth token lives. Defaults to `~/.aux4.config/.oauth/google.json`, the same location `aux4 google auth login` writes to, so it normally needs no setting.

For the optional `integration` test group, set `GA4_PROPERTY_ID` to your GA4 property ID.

## License

MIT — See [LICENSE](./LICENSE) for details.
