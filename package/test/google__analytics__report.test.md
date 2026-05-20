# google analytics report

```timeout
15000
```

## with default options

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

## with custom dimensions and metrics

### should return country breakdown

```execute
aux4 google analytics report ${GA4_PROPERTY_ID} --startDate 30daysAgo --endDate today --dimensions date,country --metrics sessions --limit 5
```

```expect:partial
"rows"
```
