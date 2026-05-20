# community/google-analytics

Commands to interact with Google Analytics 4 (GA4) using the Analytics Data API

This package provides aux4 command wrappers for the [Google Analytics Data API](https://developers.google.com/analytics/devguides/reporting/data/v1) (GA4). It covers running standard reports with dimensions, metrics, and date ranges, querying realtime data, and discovering available dimensions and metrics for a property.

Authentication is handled through the Google Workspace CLI (`gws`) with custom OAuth scopes — the same credential store used by other Google packages (Sheets, Drive, etc.).

## Installation

```bash
aux4 aux4 pkger install community/google-analytics
```

## System Dependencies

This package requires:

- **Google Workspace CLI** (`gws`) — for authentication and credential management
  - [brew](https://brew.sh): `brew install googleworkspace-cli`
  - [npm](https://www.npmjs.com): `npm install -g @googleworkspace/cli`
- **jq** — for JSON processing
  - [brew](https://brew.sh): `brew install jq`

## Prerequisites

Authenticate with Google Analytics scopes:

```bash
aux4 google auth login --scopes https://www.googleapis.com/auth/analytics.readonly
```

For read-write access (e.g. audience exports):

```bash
aux4 google auth login --scopes https://www.googleapis.com/auth/analytics
```

You can combine Analytics scopes with other Google services in a single login:

```bash
aux4 google auth login --services sheets,drive --scopes https://www.googleapis.com/auth/analytics.readonly
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
aux4 google analytics metadata 123456789 | jq '[.dimensions[].apiName]'
```

Filter to just metric names:

```bash
aux4 google analytics metadata 123456789 | jq '[.metrics[].apiName]'
```

## Finding your Property ID

Your GA4 property ID is a numeric identifier found in Google Analytics:

1. Go to [analytics.google.com](https://analytics.google.com)
2. Click **Admin** (gear icon)
3. Under **Property**, click **Property Settings**
4. The property ID is displayed at the top

## Environment Variables

Authentication uses the same credential store as the Google Workspace CLI:

- `GOOGLE_WORKSPACE_CLI_TOKEN` — Pre-obtained OAuth2 access token (highest priority)
- `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE` — Path to credentials JSON file
- `GOOGLE_WORKSPACE_CLI_CONFIG_DIR` — Override default config directory

For tests, set `GA4_PROPERTY_ID` to your GA4 property ID.

## License

MIT — See [LICENSE](./LICENSE) for details.
