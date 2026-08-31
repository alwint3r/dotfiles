# Turn Duration

A Pi extension that displays the elapsed time from `before_agent_start` until `agent_settled` after every completed agent run.

The duration appears below the final answer as a persistent, TUI-only session entry:

```text
Turn completed in 0h 03m 27s
```

The timer includes tool calls, retries, automatic compaction, steering, and queued follow-up work that completes before the agent settles. Duration entries are not sent to the model.

## Install

Run either dotfiles installer:

```bash
./install.sh
# or
python3 install.py
```

Then run `/reload` in Pi.
