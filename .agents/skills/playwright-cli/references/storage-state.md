# Storage Management

Follow the lifecycle ordering in [`command-contract.md`](command-contract.md): open an isolated session, load authorized state, and only then navigate to the target origin.

> Browser storage may contain reusable authentication credentials, personal data, and application secrets. Do not inspect, print, save, load, modify, or clear sensitive state unless it is necessary for the authorized task.

## Safety Rules

- Use an isolated named session.
- Prefer non-sensitive test fixtures and in-memory state.
- Save state only with explicit authorization.
- Store temporary state outside the repository in a task-specific directory.
- Restrict file permissions where supported, never commit state files, and delete temporary state after use unless the user asks to retain it.
- Do not list all cookies or storage values merely for diagnostics. Query the minimum non-sensitive key or domain needed.
- Never print token-like values in the response or copy them into source files, shell history, logs, screenshots, traces, or generated tests.
- Clear or delete only state created for the current task. Do not modify a person's normal browser profile.

## Save and Restore Authorized State

Storage-state files can contain cookies and local-storage values sufficient to impersonate a user.

Save from an already-open, explicitly authorized authenticated session:

```bash
mkdir -p /tmp/playwright-task
chmod 700 /tmp/playwright-task
playwright-cli -s=authenticated-task state-save /tmp/playwright-task/auth-state.json
chmod 600 /tmp/playwright-task/auth-state.json
```

Restore into a new isolated session before navigating to the target origin:

```bash
playwright-cli -s=restored-task open about:blank
playwright-cli -s=restored-task state-load /tmp/playwright-task/auth-state.json
playwright-cli -s=restored-task goto https://example.com
playwright-cli -s=restored-task close
```

Remove task-created state when it is no longer needed:

```bash
rm -f /tmp/playwright-task/auth-state.json
```

Do not save authenticated state to a generic repository-root filename such as `auth.json`.

## Cookies

Do not use general cookie-listing commands: they can print authentication values even when filtered to one domain. Do not retrieve cookie values for user-facing output.

Use only synthetic, non-secret values when setting cookies for a test:

```bash
playwright-cli -s=task cookie-set test_variant variant-a --domain=example.com --path=/ --secure --sameSite=Lax
playwright-cli -s=task cookie-delete test_variant
```

`cookie-clear` is destructive. Use it only in a disposable task-owned session or when the user explicitly asks to clear the targeted state.

## Local Storage

```bash
playwright-cli -s=task localstorage-get theme
playwright-cli -s=task localstorage-set theme dark
playwright-cli -s=task localstorage-delete theme
```

Use `localstorage-list` only when all values are known to be non-sensitive. `localstorage-clear` is destructive and is restricted to disposable task-owned sessions unless explicitly authorized.

For multiple non-sensitive test preferences:

```bash
playwright-cli -s=task run-code "async page => {
  await page.evaluate(() => {
    localStorage.setItem('theme', 'dark');
    localStorage.setItem('test_variant', 'variant-a');
  });
}"
```

## Session Storage

```bash
playwright-cli -s=task sessionstorage-get step
playwright-cli -s=task sessionstorage-set step 3
playwright-cli -s=task sessionstorage-delete step
```

Use `sessionstorage-list` and `sessionstorage-clear` only under the same minimum-access and task-owned-session rules.

## IndexedDB

Inspect or delete IndexedDB only when required by the test. Database contents may be sensitive, and deletion is destructive.

```bash
# Metadata only; do not dump database contents.
playwright-cli -s=task run-code "async page => {
  return await indexedDB.databases();
}"
```

Deleting a database requires explicit authorization unless the browser context is a disposable fixture created for the current test:

```bash
playwright-cli -s=task run-code "async page => {
  await page.evaluate(() => indexedDB.deleteDatabase('test-fixture-db'));
}"
```

## Authentication Workflow

Prefer the repository's existing test authentication fixture. Do not put real usernames or passwords in CLI arguments or generated code.

If interactive login is required, let the user complete sensitive credential entry when practical, then save state only if they explicitly authorize reuse. Keep the state scoped to the intended test origin, and remove the state file at completion.
