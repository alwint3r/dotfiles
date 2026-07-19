# Video Recording

Follow the canonical capture lifecycle in [`command-contract.md`](command-contract.md): open first, pass the filename to `video-start`, navigate, record, call `video-stop` without an argument, and close.

Record a browser session as WebM only when a visual recording materially helps debugging, documentation, or verification.

> Videos can capture personal information, credentials as they are typed, private page content, notifications, and other unrelated screen state. Use synthetic data and an isolated test environment whenever possible.

## Basic Recording

```bash
mkdir -p /tmp/playwright-task
playwright-cli -s=task open about:blank
playwright-cli -s=task video-start /tmp/playwright-task/demo.webm
playwright-cli -s=task goto http://localhost:3000
playwright-cli -s=task snapshot
playwright-cli -s=task click e1
playwright-cli -s=task fill e2 "Synthetic test input"
playwright-cli -s=task video-stop
playwright-cli -s=task close
```

## Artifact Rules

- Record only the minimum flow needed.
- Do not record real credentials, payment details, private messages, or unrelated user activity.
- Use a task-specific temporary or ignored output directory.
- Do not commit recordings by default.
- Review the intended destination before sharing a recording.
- Report retained recording paths.
- Delete only recordings created by the current task; do not remove pre-existing files.
- Stop recording and close the task-owned session on both success and failure.

Use descriptive filenames that identify the test rather than a user. For example, use `/tmp/playwright-task/login-validation.webm` rather than a filename containing an account name.

## Tracing vs. Video

| Feature | Video | Trace |
| --- | --- | --- |
| Output | WebM | Trace bundle |
| Captures | Visible page state | DOM, network, console, actions, and screenshots |
| Typical use | Demonstration | Detailed debugging |
| Sensitivity | High | Often higher |

Prefer a screenshot when a single frame is sufficient. Prefer a trace only when DOM or network-level diagnosis is necessary.

## Limitations

- Recording adds runtime and storage overhead.
- Large recordings consume significant disk space.
- Video shows visible behavior but not underlying DOM or network state.
