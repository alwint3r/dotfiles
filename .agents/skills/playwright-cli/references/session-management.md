# Browser Session Management

The lifecycle and attachment syntax in [`command-contract.md`](command-contract.md) is authoritative.

Use named browser sessions to isolate automation contexts. Each named session has independent cookies, storage, cache, history, and tabs.

## Safe Default

Create a unique, in-memory session for the current task:

```bash
playwright-cli -s=task open https://example.com
playwright-cli -s=task snapshot
playwright-cli -s=task close
```

Use semantic, collision-resistant names when multiple tasks may run concurrently. Close only sessions created for the current task.

## Named Sessions

```bash
playwright-cli -s=public-check open https://example.com
playwright-cli -s=local-app open http://localhost:3000

playwright-cli -s=public-check snapshot
playwright-cli -s=local-app snapshot

playwright-cli -s=public-check close
playwright-cli -s=local-app close
```

List sessions when necessary to identify the task-owned session:

```bash
playwright-cli list
```

Do not interact with or close an unfamiliar session merely because it appears in this list.

## Persistent Profiles Are Opt-In

By default, keep browser state in memory. Persistent profiles can retain credentials, history, and site data on disk. Use them only when the user explicitly requests state persistence.

```bash
# Explicitly authorized, task-owned persistent profile.
playwright-cli -s=task open https://example.com --persistent

# Explicitly authorized profile directory created for this task.
playwright-cli -s=task open https://example.com --profile=/tmp/playwright-task/profile
```

Never point `--profile` at a person's normal browser profile unless the user explicitly requests that exact profile and accepts the exposure risk. Do not reuse a task profile across unrelated origins or users.

Connecting through `--extension` can expose an existing browser session and is subject to the same opt-in requirement.

## Configuration

Use reviewed project configuration when it is part of the requested workflow:

```bash
playwright-cli -s=task open http://localhost:3000 --config=.playwright/my-cli.json
playwright-cli -s=task open http://localhost:3000 --browser=firefox
```

Inspect unfamiliar configuration before using it because it may select persistent profiles, proxies, downloads, or other sensitive paths.

## Destructive Session Commands

These commands can affect state beyond the current page:

```bash
playwright-cli -s=task delete-data
playwright-cli close-all
playwright-cli kill-all
```

Rules:

- `delete-data` may target only a profile created for the current task, unless the user explicitly authorizes deletion of another profile.
- Do not use `close-all` for routine cleanup; close task-owned named sessions individually.
- Do not use `kill-all` unless task-owned Playwright CLI processes are stuck, targeted closure failed, and unrelated sessions will not be disrupted.
- Never delete stale profiles or session data solely to free disk space without confirming ownership.

## Concurrent Sessions

Concurrent sessions are appropriate for isolated comparison or test work. Track every session name and close each one explicitly:

```bash
playwright-cli -s=variant-a open http://localhost:3000/?variant=a &
playwright-cli -s=variant-b open http://localhost:3000/?variant=b &
wait

playwright-cli -s=variant-a snapshot
playwright-cli -s=variant-b snapshot

playwright-cli -s=variant-a close
playwright-cli -s=variant-b close
```

Avoid broad cleanup commands even after concurrent runs.
