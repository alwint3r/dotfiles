# Running Playwright Tests

Follow the canonical session and attachment rules in [`command-contract.md`](command-contract.md).

Use the repository's existing package-manager script when available. Otherwise, invoke an already-installed project dependency without allowing an implicit download. Do not install Playwright or browsers automatically. To avoid opening the interactive HTML report, set `PLAYWRIGHT_HTML_OPEN=never`.

```bash
# Run through an existing project script.
PLAYWRIGHT_HTML_OPEN=never npm run special-test-command

# Or use an already-installed project dependency without downloading it.
PLAYWRIGHT_HTML_OPEN=never npx --no-install playwright test
```

# Debugging Playwright Tests

To debug a failing test, run it with Playwright as usual, but set `PWPAUSE=cli` environment variable. This command will pause the test at the point of failure, and print the debugging instructions.

**IMPORTANT**: run the command in the background and check the output until "Debugging Instructions" is printed.

Once instructions are printed, use `playwright-cli` to explore the page. Debugging instructions include a browser name that should be used in `playwright-cli` to attach to the page under test.

```bash
log=/tmp/playwright-debug.log

# Run the test in the background and retain its exact process identifier.
PLAYWRIGHT_HTML_OPEN=never PWPAUSE=cli \
  npx --no-install playwright test >"$log" 2>&1 &
test_pid=$!

# Poll only this log until it prints the debugging instructions and bound browser name.
# Then attach using that exact browser name.
playwright-cli -s=test-debug attach test-worker-abcdef
playwright-cli -s=test-debug snapshot
playwright-cli -s=test-debug click e14
playwright-cli -s=test-debug detach

# Stop only the task-owned test process when debugging is complete.
kill "$test_pid" 2>/dev/null || true
wait "$test_pid" 2>/dev/null || true
```

Keep the task-owned test process running while you explore and look for a fix. In an automated shell workflow, install a trap after assigning `test_pid` so interruption also stops only that process. Do not kill unrelated test or browser processes.

Every action you perform with `playwright-cli` generates corresponding Playwright TypeScript code.
This code appears in the output and can be copied directly into the test. Most of the time, a specific locator or an expectation should be updated, but it could also be a bug in the app. Use your judgement.
