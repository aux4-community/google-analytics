#### Description

The `metadata` command retrieves the list of dimensions and metrics available for reporting on a specific GA4 property. Use this to discover which dimension and metric names you can pass to the `report` and `realtime` commands.

The response includes the API name, display name, description, and category for each dimension and metric. Custom dimensions and metrics configured on your property are also included.

#### Usage

```bash
aux4 google analytics metadata <propertyId> [--tokenFile <path>]
```

propertyId   GA4 property ID (numeric)
--tokenFile  Where the shared Google OAuth token is stored (default: `~/.aux4.config/.oauth/google.json`, env `AUX4_GOOGLE_TOKEN_FILE`)

#### Example

```bash
aux4 google analytics metadata 123456789
```

```text
{
  "name": "properties/123456789/metadata",
  "dimensions": [
    {
      "apiName": "date",
      "uiName": "Date",
      "description": "The date of the event...",
      "category": "Time"
    },
    {
      "apiName": "country",
      "uiName": "Country",
      "description": "The country...",
      "category": "Geography"
    }
  ],
  "metrics": [
    {
      "apiName": "sessions",
      "uiName": "Sessions",
      "description": "The number of sessions...",
      "category": "Session",
      "type": "TYPE_INTEGER"
    },
    {
      "apiName": "activeUsers",
      "uiName": "Active users",
      "description": "The number of distinct...",
      "category": "User",
      "type": "TYPE_INTEGER"
    }
  ]
}
```

Show the dimension names as a table:

```bash
aux4 google analytics metadata 123456789 | aux4 json get --path '$.dimensions' | aux4 2table --table apiName,uiName,category
```

Show the metric names as a table:

```bash
aux4 google analytics metadata 123456789 | aux4 json get --path '$.metrics' | aux4 2table --table apiName,uiName,type
```
