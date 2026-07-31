# google analytics realtime

Part of the `core` group in `test.suite.md`. The Analytics Data API is replaced by a
local echo server so the realtime request body can be asserted without a real GA4
property.

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

HTTPServer(('127.0.0.1', 18956), Handler).serve_forever()
" >/dev/null 2>&1 &
sleep 3
```

```afterAll
pkill -f "18956" 2>/dev/null
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

### should POST to the runRealtimeReport endpoint

```execute
aux4 google analytics realtime 123456789 --tokenFile google-token.json --apiUrl http://127.0.0.1:18956
```

```expect:partial
"method": "POST"
```

```expect:partial
"path": "/v1beta/properties/123456789:runRealtimeReport"
```

### should omit dimensions when none are given

```execute
aux4 google analytics realtime 123456789 --tokenFile google-token.json --apiUrl http://127.0.0.1:18956 | aux4 json get --path '$.body'
```

```expect:json
{
  "limit": 100,
  "metrics": [
    {
      "name": "activeUsers"
    }
  ]
}
```

### should include dimensions when they are given

```execute
aux4 google analytics realtime 123456789 --metrics activeUsers,screenPageViews --dimensions country --limit 5 --tokenFile google-token.json --apiUrl http://127.0.0.1:18956 | aux4 json get --path '$.body'
```

```expect:json
{
  "dimensions": [
    {
      "name": "country"
    }
  ],
  "limit": 5,
  "metrics": [
    {
      "name": "activeUsers"
    },
    {
      "name": "screenPageViews"
    }
  ]
}
```
