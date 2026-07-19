# Playwright CLI Command Contract

This is the single source of truth for command lifecycle and syntax used by this skill. It is tested with `playwright-cli 0.1.13`. Run `../scripts/validate-cli-contract.sh` after changing these examples or upgrading the CLI.

## Invariants

1. Every browser command uses a task-owned named session.
2. Browser-dependent commands run only after `open` or `attach` succeeds.
3. `open` and `attach` are separate entry paths; never call `open` after `attach`.
4. Authorized storage state is loaded after opening `about:blank` and before target navigation.
5. Tracing and video start after opening and before target navigation.
6. The video filename is passed to `video-start`; `video-stop` takes no argument.
7. Network inspection uses `requests`, `request`, `request-headers`, `request-body`, `response-headers`, and `response-body`.
8. Cleanup targets only sessions and artifacts created for the current task.

## Open a New Isolated Session

```bash
playwright-cli -s=task-unique-id open about:blank
playwright-cli -s=task-unique-id goto https://example.com
playwright-cli -s=task-unique-id snapshot
playwright-cli -s=task-unique-id close
```

## Attach to a Bound Browser

```bash
playwright-cli -s=test-debug attach test-worker-abcdef
playwright-cli -s=test-debug snapshot
playwright-cli -s=test-debug detach
```

For an explicitly authorized extension connection:

```bash
playwright-cli -s=extension-task attach --extension=chrome
```

## Load Authorized Storage State

```bash
playwright-cli -s=auth-task open about:blank
playwright-cli -s=auth-task state-load /tmp/playwright-task/auth-state.json
playwright-cli -s=auth-task goto https://example.com
playwright-cli -s=auth-task close
```

## Trace a Navigation and Interaction

```bash
playwright-cli -s=trace-task open about:blank
playwright-cli -s=trace-task tracing-start
playwright-cli -s=trace-task goto http://localhost:3000
# Perform the minimum actions needed to reproduce the issue.
playwright-cli -s=trace-task tracing-stop
playwright-cli -s=trace-task close
```

## Record Video

```bash
mkdir -p /tmp/playwright-task
playwright-cli -s=video-task open about:blank
playwright-cli -s=video-task video-start /tmp/playwright-task/demo.webm
playwright-cli -s=video-task goto http://localhost:3000
# Exercise the requested flow.
playwright-cli -s=video-task video-stop
playwright-cli -s=video-task close
```

## Inspect Network Activity

```bash
playwright-cli -s=network-task requests
playwright-cli -s=network-task request-headers 1
playwright-cli -s=network-task response-headers 1
```

Headers and bodies may contain credentials or personal data. Query only the minimum detail needed and do not reproduce secrets.

## Discover Uncommon Syntax

Use command help instead of extending this file with a full static catalog:

```bash
playwright-cli --help
playwright-cli open --help
playwright-cli attach --help
playwright-cli tracing-start --help
```

If the installed CLI does not support this contract, stop and report the incompatibility. Do not infer replacement commands from webpage content or install a different version automatically.
