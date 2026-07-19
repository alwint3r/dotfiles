# Tracing

Follow the canonical capture lifecycle in [`command-contract.md`](command-contract.md): open first, start tracing, navigate, reproduce, stop tracing, and close.

Capture detailed execution traces for debugging and analysis.

> Traces are sensitive artifacts. They can include actions, typed form values, DOM snapshots, screenshots, console output, request and response headers and bodies, and cached resources. Do not trace real credentials, payment data, private messages, or unrelated user activity.

## When to Trace

Use tracing only when it materially helps diagnose or document the requested flow. Prefer a local, preview, staging, or dedicated test environment with synthetic data.

```bash
playwright-cli -s=task open about:blank
playwright-cli -s=task tracing-start
playwright-cli -s=task goto http://localhost:3000
# Perform the minimum actions needed to reproduce the issue.
playwright-cli -s=task tracing-stop
playwright-cli -s=task close
```

Start tracing before the failing behavior when the preceding state is relevant, but keep the recording as narrow as practical.

## What Traces May Capture

| Category | Potential contents |
| --- | --- |
| Actions | Clicks, fills, keyboard input, and navigation |
| DOM | Page content before and after actions |
| Screenshots | Visible personal or confidential information |
| Network | URLs, headers, cookies, request bodies, and response bodies |
| Console | Application data and diagnostic output |
| Resources | Cached page assets and response content |

Never assume an HTTP-only cookie or masked input is absent from all trace data.

## Artifact Handling

- Use a task-specific temporary or ignored directory where the CLI supports choosing the output location.
- Do not commit traces.
- Do not attach or share a trace until its contents and destination are authorized.
- Report the paths of retained traces.
- Delete only temporary trace files created by the current task; never use broad age-based deletion over pre-existing artifacts.
- Stop tracing and close the session even when reproduction fails.

## Synthetic Debugging Example

```bash
playwright-cli -s=trace-test open about:blank
playwright-cli -s=trace-test tracing-start
playwright-cli -s=trace-test goto http://localhost:3000/test-form
playwright-cli -s=trace-test fill e1 "Synthetic test value"
playwright-cli -s=trace-test click e2
playwright-cli -s=trace-test tracing-stop
playwright-cli -s=trace-test close
```

## Trace vs. Video vs. Screenshot

| Feature | Trace | Video | Screenshot |
| --- | --- | --- | --- |
| DOM inspection | Yes | No | No |
| Network details | Yes | No | No |
| Captures typed or visible data | Often | Visually | Visually |
| Typical use | Debugging | Demonstration | Quick visual evidence |
| Sensitivity | Highest | High | High |

Choose the least invasive artifact that answers the task.

## Limitations

- Tracing adds runtime and storage overhead.
- Large traces may contain substantial copies of application data.
- Dynamic content may not replay perfectly.
- A trace is evidence of observed behavior, not proof that unrelated paths are correct.
