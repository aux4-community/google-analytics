# google analytics

Part of the optional `integration` group in `test.suite.md`. These tests talk to the
real Analytics Data API, so they need a completed `aux4 google auth login` — a Google
Cloud OAuth Desktop client plus a human approving the consent screen in a browser.
They only run when asked for explicitly:

```bash
aux4 test run --group integration
```

Set `GA4_PROPERTY_ID` to a GA4 property the authenticated account can read.

```timeout
15000
```

## metadata

### should return available dimensions and metrics

```execute
aux4 google analytics metadata ${GA4_PROPERTY_ID}
```

```expect:partial
"dimensions"
```

```expect:partial
"metrics"
```

## report

### should return report data

```execute
aux4 google analytics report ${GA4_PROPERTY_ID} --startDate 7daysAgo --endDate today
```

```expect:partial
"dimensionHeaders"
```

```expect:partial
"metricHeaders"
```

### should return country breakdown

```execute
aux4 google analytics report ${GA4_PROPERTY_ID} --startDate 30daysAgo --endDate today --dimensions date,country --metrics sessions --limit 5
```

```expect:partial
"rows"
```

## realtime

### should return realtime metric headers

```execute
aux4 google analytics realtime ${GA4_PROPERTY_ID}
```

```expect:partial
"metricHeaders"
```
