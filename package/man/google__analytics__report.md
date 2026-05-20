#### Description

The `report` command runs a standard GA4 report against the Analytics Data API. It returns rows of dimension and metric values for the specified date range. This is the primary way to query historical analytics data — page views, sessions, user counts, conversions, and more.

Dimensions group the data (e.g. by date, country, page path), while metrics are the numeric values measured (e.g. sessions, active users, screen page views). You can combine multiple dimensions and metrics in a single request.

Dates can be absolute (`YYYY-MM-DD`) or relative (`today`, `yesterday`, `7daysAgo`, `30daysAgo`, `90daysAgo`, `365daysAgo`).

#### Usage

```bash
aux4 google analytics report <propertyId> [--startDate <date>] [--endDate <date>] [--dimensions <dims>] [--metrics <metrics>] [--limit <n>]
```

propertyId  GA4 property ID (numeric). Found in Google Analytics under Admin → Property Settings
--startDate  Start date in YYYY-MM-DD format or relative (e.g. 7daysAgo). Required
--endDate    End date in YYYY-MM-DD format or relative (e.g. today). Required
--dimensions Comma-separated dimension names (default: date)
--metrics    Comma-separated metric names (default: sessions,activeUsers)
--limit      Maximum rows to return (default: 10000)

#### Example

```bash
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today
```

```text
{
  "dimensionHeaders": [{"name": "date"}],
  "metricHeaders": [{"name": "sessions", "type": "TYPE_INTEGER"}, {"name": "activeUsers", "type": "TYPE_INTEGER"}],
  "rows": [
    {"dimensionValues": [{"value": "20240115"}], "metricValues": [{"value": "1234"}, {"value": "987"}]},
    {"dimensionValues": [{"value": "20240114"}], "metricValues": [{"value": "1100"}, {"value": "890"}]}
  ],
  "rowCount": 7
}
```

Report with multiple dimensions:

```bash
aux4 google analytics report 123456789 --startDate 30daysAgo --endDate today --dimensions date,country --metrics sessions,screenPageViews --limit 100
```

Common dimensions: `date`, `country`, `city`, `pagePath`, `pageTitle`, `sessionSource`, `sessionMedium`, `deviceCategory`, `browser`, `operatingSystem`.

Common metrics: `sessions`, `activeUsers`, `newUsers`, `screenPageViews`, `averageSessionDuration`, `bounceRate`, `conversions`, `totalRevenue`.

Use `aux4 google analytics metadata <propertyId>` to see all available dimensions and metrics.
