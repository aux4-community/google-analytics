#### Description

The `realtime` command runs a realtime report against the GA4 Analytics Data API. It returns data for events that have occurred in the last 30 minutes, giving you a live view of current activity on your property.

Realtime reports support a subset of dimensions and metrics compared to standard reports. Common realtime dimensions include `country`, `city`, `unifiedScreenName`, and `deviceCategory`. Common realtime metrics include `activeUsers`, `screenPageViews`, and `eventCount`.

#### Usage

```bash
aux4 google analytics realtime <propertyId> [--metrics <metrics>] [--dimensions <dims>] [--limit <n>]
```

propertyId   GA4 property ID (numeric)
--metrics    Comma-separated metric names (default: activeUsers)
--dimensions Comma-separated dimension names (default: none)
--limit      Maximum rows to return (default: 100)

#### Example

```bash
aux4 google analytics realtime 123456789
```

```text
{
  "metricHeaders": [{"name": "activeUsers", "type": "TYPE_INTEGER"}],
  "rows": [
    {"metricValues": [{"value": "42"}]}
  ]
}
```

Realtime report with dimensions:

```bash
aux4 google analytics realtime 123456789 --metrics activeUsers,screenPageViews --dimensions country
```

```text
{
  "dimensionHeaders": [{"name": "country"}],
  "metricHeaders": [{"name": "activeUsers", "type": "TYPE_INTEGER"}, {"name": "screenPageViews", "type": "TYPE_INTEGER"}],
  "rows": [
    {"dimensionValues": [{"value": "United States"}], "metricValues": [{"value": "15"}, {"value": "23"}]},
    {"dimensionValues": [{"value": "United Kingdom"}], "metricValues": [{"value": "8"}, {"value": "12"}]}
  ]
}
```
