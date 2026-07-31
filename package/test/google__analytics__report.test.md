# google analytics report

Part of the `core` group in `test.suite.md`. The Analytics Data API is replaced by a
local echo server, so the test asserts the request aux4 builds — method, path,
`Authorization` header and JSON body — without needing a real GA4 property.

## against a local mock API

```beforeAll
nohup python3 -c "
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, threading, os
threading.Timer(90, lambda: os._exit(0)).start()

class Handler(BaseHTTPRequestHandler):
    def echo(self):
        length = int(self.headers.get('Content-Length') or 0)
        raw = self.rfile.read(length).decode() if length > 0 else ''
        payload = {
            'method': self.command,
            'path': self.path,
            'authorization': self.headers.get('Authorization'),
            'contentType': self.headers.get('Content-Type'),
            'body': json.loads(raw) if raw else None
        }
        data = json.dumps(payload, indent=2, sort_keys=True).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(data)))
        self.end_headers()
        self.wfile.write(data)
    do_GET = echo
    do_POST = echo
    def log_message(self, fmt, *args):
        pass

HTTPServer(('127.0.0.1', 18955), Handler).serve_forever()
" >/dev/null 2>&1 &
sleep 3
```

```afterAll
pkill -f "18955" 2>/dev/null
```

```file:google-token.json
{
  "clientId": "test-client",
  "clientSecret": "test-secret",
  "authUrl": "https://accounts.google.com/o/oauth2/v2/auth",
  "tokenUrl": "https://oauth2.googleapis.com/token",
  "scopes": "https://www.googleapis.com/auth/analytics.readonly",
  "accessToken": "test-access-token",
  "refreshToken": "test-refresh-token",
  "expiresAt": "2099-12-31T23:59:59Z"
}
```

### should POST to the runReport endpoint with a bearer token

```execute
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today --tokenFile google-token.json --apiUrl http://127.0.0.1:18955
```

```expect:partial
"authorization": "Bearer test-access-token"
```

```expect:partial
"contentType": "application/json"
```

```expect:partial
"method": "POST"
```

```expect:partial
"path": "/v1beta/properties/123456789:runReport"
```

### should build the default report body

```execute
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today --tokenFile google-token.json --apiUrl http://127.0.0.1:18955 | aux4 json get --path '$.body'
```

```expect:json
{
  "dateRanges": [
    {
      "endDate": "today",
      "startDate": "7daysAgo"
    }
  ],
  "dimensions": [
    {
      "name": "date"
    }
  ],
  "limit": 10000,
  "metrics": [
    {
      "name": "sessions"
    },
    {
      "name": "activeUsers"
    }
  ]
}
```

### should expand comma-separated dimensions and metrics and keep limit numeric

```execute
aux4 google analytics report 123456789 --startDate 2026-01-01 --endDate 2026-01-31 --dimensions date,country --metrics sessions,screenPageViews --limit 5 --tokenFile google-token.json --apiUrl http://127.0.0.1:18955 | aux4 json get --path '$.body'
```

```expect:json
{
  "dateRanges": [
    {
      "endDate": "2026-01-31",
      "startDate": "2026-01-01"
    }
  ],
  "dimensions": [
    {
      "name": "date"
    },
    {
      "name": "country"
    }
  ],
  "limit": 5,
  "metrics": [
    {
      "name": "sessions"
    },
    {
      "name": "screenPageViews"
    }
  ]
}
```

## without a stored token

### should report that the google provider has no token

```execute
aux4 google analytics report 123456789 --startDate 7daysAgo --endDate today --tokenFile ./no-such-directory/google.json --apiUrl http://127.0.0.1:18955
```

```error:partial
no token found for provider "google"
```
