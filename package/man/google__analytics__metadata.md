#### Description

The `metadata` command retrieves the list of dimensions and metrics available for reporting on a specific GA4 property. Use this to discover which dimension and metric names you can pass to the `report` and `realtime` commands.

The response includes the API name, display name, description, and category for each dimension and metric. Custom dimensions and metrics configured on your property are also included.

#### Usage

```bash
aux4 google analytics metadata <propertyId>
```

propertyId  GA4 property ID (numeric)

#### Example

```bash
aux4 google analytics metadata 123456789
```

```text
{
  "name": "properties/123456789/metadata",
  "dimensions": [
    {"apiName": "date", "uiName": "Date", "description": "The date of the event...", "category": "Time"},
    {"apiName": "country", "uiName": "Country", "description": "The country...", "category": "Geography"},
    ...
  ],
  "metrics": [
    {"apiName": "sessions", "uiName": "Sessions", "description": "The number of sessions...", "category": "Session", "type": "TYPE_INTEGER"},
    {"apiName": "activeUsers", "uiName": "Active users", "description": "The number of distinct...", "category": "User", "type": "TYPE_INTEGER"},
    ...
  ]
}
```

Filter to just dimension names:

```bash
aux4 google analytics metadata 123456789 | jq '[.dimensions[].apiName]'
```

Filter to just metric names:

```bash
aux4 google analytics metadata 123456789 | jq '[.metrics[].apiName]'
```
