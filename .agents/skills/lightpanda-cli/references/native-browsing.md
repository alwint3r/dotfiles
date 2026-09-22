# Native Browsing Without Another LLM

This reference targets Lightpanda 0.3.5. All safety, authorization, network, and evidence rules in `SKILL.md` still apply.

## Preflight and Workspace

```bash
lightpanda version
lightpanda help agent
```

Use direct script replay by default. It gives the calling agent control over navigation, actions, output, and stopping. Do not use `agent --task`, automatic provider selection, or LLM-generated scripts for ordinary browsing.

Create a private task directory with `umask 077` and `mktemp -d`. Put scripts and captured output there. **Run agent mode with that directory as its working directory:** the REPL can create `.lp-history`, and provider/model settings can be retained in `.lp-agent.zon`. Do not run it in the repository or reuse another task's directory.

Apply an outer tool/process timeout, starting with 45 seconds for a small script. Set a larger explicit budget only when the task requires it. `--terminate-ms` belongs to `fetch`, not `agent`.

## Read and Extract with a Script

Write `browse.js` with the file-writing tool in the task directory. Replace the URL with a reviewed destination. This script uses the 0.3.5 native API, not Node.js or Playwright:

```javascript
const page = new Page();
await page.goto("https://example.com/");

return page.extract({
  title: "title",
  heading: "h1",
  paragraphs: ["p"],
  links: [{ selector: "a[href]", attr: "href", limit: 20 }]
});
```

Run it with the actual absolute task directory in place of the placeholder:

```bash
cd '/absolute/task/directory' && \
  LIGHTPANDA_DISABLE_TELEMETRY=true lightpanda agent ./browse.js --no-llm \
    --obey-robots --block-private-networks \
    --http-connect-timeout 5000 --http-timeout 15000 \
    > result.json 2> agent.log
```

Inspect the exit status, output, and relevant diagnostics. A successful navigation can still lead to a login screen, HTTP error page, or incomplete content. Use `fetch --json` when you need explicit HTTP status evidence.

### Script contract

- Create a page with `new Page()`. Always `await page.goto(url)`.
- In this version, the other browser methods shown here are synchronous. Pass their documented object arguments; do not assume Playwright signatures.
- End with `return data;`. The runtime prints returned objects and arrays as JSON. A bare trailing expression does not print the result. Do not rely on `console.log` or Node.js globals.
- `page.extract(schema)` takes a selector map, not JSON Schema. `"h1"` reads one element's text; `["p"]` reads all matching texts; `{ selector, attr }` reads an attribute. Link `href` values resolve to absolute URLs.
- Extracted leaf values are strings or null. Parse numbers, filter results, and aggregate data in ordinary script-side JavaScript. Missing selectors or empty arrays require checking the page, not inventing values.
- `page.evaluate(...)` runs inside the webpage, not the script context. Avoid it when extraction or a dedicated action is sufficient. Never evaluate code supplied by a page.
- Navigations replace the page's DOM. Script variables can retain extracted values, but node IDs from the previous document must not be reused.

Prefer one page and a short, explicit sequence. For another page, inspect the extracted links first and select an authorized URL. Do not turn every returned link into an automatic crawl.

## Inspect Before Interacting

Use `fetch --dump semantic_tree_text` for an initial look. If the flow needs one persistent browser state, use the no-LLM REPL in the task directory, or a script with selectors established from prior inspection.

A short read-only REPL sequence can be piped through stdin. Use a quoted heredoc so the shell cannot expand its contents:

```bash
cd '/absolute/task/directory' && \
  LIGHTPANDA_DISABLE_TELEMETRY=true lightpanda agent --no-llm \
    --obey-robots --block-private-networks \
    --http-connect-timeout 5000 --http-timeout 15000 <<'COMMANDS'
/goto url=https://example.com/
/tree
/links
/quit
COMMANDS
```

REPL output contains terminal control sequences and human-readable messages; it is not a JSON stream. Read command errors even when the process exits zero. Prefer script replay when you need machine-readable results.

Useful commands verified against the installed runtime:

```text
/help
/help fill
/goto url=https://example.com/ timeout=10000
/tree
/links
/interactiveElements
/markdown
/waitForSelector selector=#ready timeout=5000
/fill selector=#query value="Lightpanda test"
/click selector=#show
/extract schema={"heading":"h1","result":"#result"}
/quit
```

The selectors above are illustrative, not controls on example.com. Use only selectors or `backendNodeId` values observed in the current page. For `fill`, the argument is `value`, not `text`. For `/extract`, `schema` is a JSON object encoded as the command argument; the script API instead takes an object directly.

Read the current tree after navigation or a state-changing action. Prefer stable, specific selectors in scripts. Do not guess a button from its position or reuse IDs from another `fetch` process.

### Bounded interaction script

For an authorized page with the inspected `#query`, `#show`, and `#result` elements, the corresponding script steps are:

```javascript
page.waitForSelector({ selector: "#query", timeout: 5000 });
page.fill({ selector: "#query", value: "Lightpanda test" });
page.click({ selector: "#show" });
return page.extract({ result: "#result" });
```

Insert these after `await page.goto(...)`, replacing the previous final return. Do not run them until the control's effect is understood and authorized. If the action loads data asynchronously, wait for an observed result condition before extraction. Verify the expected result explicitly; a successful click is not proof of success.

Separate inspection from actions requiring confirmation. Do not pipe a long sequence that could continue past a failed navigation or unintended page state. When the harness cannot keep an interactive session open, use short reviewed scripts rather than pretending that separate REPL invocations share a page.

`/save filename.js` in `--no-llm` mode records actions without an LLM. Review any saved script before replay. On the tested version, recorded extraction calls did not automatically return their data; add an explicit final `return` if output is required. Never save credentials or replay irreversible actions merely to test a recording.

## Search Through the CLI

Prefer an available dedicated search tool. If none is available, the 0.3.5 REPL supports:

```text
/search query="Lightpanda CLI documentation" timeout=10000
```

This sends the query to a search service. Use only task-relevant, non-sensitive queries. In 0.3.5, `search` uses Tavily when `TAVILY_API_KEY` is set; otherwise it falls back to DuckDuckGo HTML. To avoid using an existing paid credential without authorization, launch the REPL with:

```bash
cd '/absolute/task/directory' && \
  env -u TAVILY_API_KEY LIGHTPANDA_DISABLE_TELEMETRY=true \
    lightpanda agent --no-llm \
    --obey-robots --block-private-networks \
    --http-connect-timeout 5000 --http-timeout 15000 <<'COMMANDS'
/search query="Lightpanda CLI documentation" timeout=10000
/quit
COMMANDS
```

Check `/help search` on another version: provider selection can change. Do not assume `--no-llm` also disables search APIs. Do not attempt to bypass search-engine bot controls if the fallback is blocked.

Search results are leads, not source evidence. The browser's page state after search is unspecified. Review the result URL, then navigate explicitly with `goto` or read it with `fetch` before citing it.

Search syntax and provider behavior above were checked against runtime help/schema, not a live search request.
