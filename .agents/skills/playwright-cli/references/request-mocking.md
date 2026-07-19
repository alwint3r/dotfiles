# Request Mocking

Follow the canonical session lifecycle in [`command-contract.md`](command-contract.md). The examples below use the task-owned session `request-mock` and assume it is already open.

Intercept, mock, modify, and block network requests inside an authorized browser session.

## Safety and Scope

- Prefer local, preview, staging, or dedicated test environments.
- Treat request and response headers and bodies as potentially sensitive. Do not print credentials, tokens, personal data, or private payloads.
- A route handler that calls `route.fetch()` still contacts the real endpoint. Use it only when that network request is authorized.
- Mocking a browser response does not authorize mutating the upstream service.
- Keep routes scoped as narrowly as possible and remove them after the test.
- Do not use interception to bypass access controls, anti-automation controls, or rate limits.

## CLI Route Commands

```bash
# Mock with custom status
playwright-cli -s=request-mock route "**/*.jpg" --status=404

# Mock with JSON body
playwright-cli -s=request-mock route "**/api/users" --body='[{"id":1,"name":"Alice"}]' --content-type=application/json

# Mock with custom headers
playwright-cli -s=request-mock route "**/api/data" --body='{"ok":true}' --header="X-Custom: value"

# Remove headers from requests
playwright-cli -s=request-mock route "**/*" --remove-header=cookie,authorization

# List active routes
playwright-cli -s=request-mock route-list

# Remove routes created by the current test.
playwright-cli -s=request-mock unroute "**/*.jpg"
# Use broad unroute only when every active route belongs to this task.
playwright-cli -s=request-mock unroute
```

## URL Patterns

```
**/api/users           - Exact path match
**/api/*/details       - Wildcard in path
**/*.{png,jpg,jpeg}    - Match file extensions
**/search?q=*          - Match query parameters
```

## Advanced Mocking with run-code

For conditional responses, request body inspection, response modification, or delays:

### Conditional Response Based on Request

```bash
playwright-cli -s=request-mock run-code "async page => {
  await page.route('**/api/login', route => {
    const body = route.request().postDataJSON();
    if (body.username === 'admin') {
      route.fulfill({ body: JSON.stringify({ token: 'mock-token' }) });
    } else {
      route.fulfill({ status: 401, body: JSON.stringify({ error: 'Invalid' }) });
    }
  });
}"
```

### Modify Real Response

`route.fetch()` sends a real request. Confirm the origin and request are authorized, and avoid logging the returned payload.

```bash
playwright-cli -s=request-mock run-code "async page => {
  await page.route('**/api/user', async route => {
    const response = await route.fetch();
    const json = await response.json();
    json.isPremium = true;
    await route.fulfill({ response, json });
  });
}"
```

### Simulate Network Failures

```bash
playwright-cli -s=request-mock run-code "async page => {
  await page.route('**/api/offline', route => route.abort('internetdisconnected'));
}"
# Options: connectionrefused, timedout, connectionreset, internetdisconnected
```

### Delayed Response

```bash
playwright-cli -s=request-mock run-code "async page => {
  await page.route('**/api/slow', async route => {
    await new Promise(r => setTimeout(r, 3000));
    route.fulfill({ body: JSON.stringify({ data: 'loaded' }) });
  });
}"
```
