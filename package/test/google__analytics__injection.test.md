# google analytics injection

Regression test for the command-injection remediation (PKG-059). Every user-supplied
value is shell-escaped through `value()`/`param()` and URLs are built with an unquoted
`set:` then passed through `value()`. A `propertyId` that carries a single quote plus a
shell command must be treated as literal data and must never execute.

## a quote-bearing propertyId must not execute a shell command

```beforeAll
rm -f /tmp/AUX4_INJ_analytics
```

```afterAll
rm -f /tmp/AUX4_INJ_analytics
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

### should run the report command with a malicious propertyId without executing it

```execute
aux4 google analytics report "x'; touch /tmp/AUX4_INJ_analytics; echo '" --startDate 2030-01-01 --endDate 2030-01-02 --apiUrl http://127.0.0.1:1 --tokenFile google-token.json </dev/null; echo ATTEMPTED
```

```expect:partial
ATTEMPTED
```

### should not have created the injection marker file

```execute
test -f /tmp/AUX4_INJ_analytics && echo VULNERABLE || echo SAFE
```

```expect
SAFE
```
