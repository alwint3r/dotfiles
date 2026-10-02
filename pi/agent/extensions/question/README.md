# Question

An OpenCode-style Q&A extension for Pi. It registers the model-callable `question` tool with a choice picker and a custom-answer editor.

The grilling skill uses this tool for interview questions when it is available. Each call asks exactly one question, so the next question can depend on the previous answer. This is not a multi-question questionnaire.

## Install

Run either dotfiles installer from the repository root:

```bash
./install.sh
# or
python3 install.py
```

Then run `/reload` in Pi. The installers link this directory into `~/.pi/agent/extensions/question` and make the grilling skill available through `~/.agents/skills`.

To try the extension without installing it:

```bash
pi --extension ./pi/agent/extensions/question/index.ts
```

Start an interview with `/skill:grilling` followed by the idea you want to discuss. The skill still requires your confirmation of shared understanding before the agent acts on your plan.

## Answer a question

- Use **Up/Down** to navigate and **Enter** to choose an answer.
- The selected choice's full description appears below the list.
- Choose **Type your own answer…** to open the text editor.
- In the editor, **Enter** submits and **Shift+Enter** or **Ctrl+J** adds a new line.
- **Escape** returns from the editor to the choices without losing your draft. For an open-ended question, it cancels immediately.
- **Escape** in the choice list or **Ctrl+C** anywhere cancels. Cancellation is not an answer or approval. The tool stops automatic follow-up for a standalone question call.

Pi's configured selection and editor keybindings apply. The screen shows the active bindings. Questions without suggested choices open the editor directly. Empty custom answers are not accepted.

## Tool input and result

Example tool arguments:

```json
{
  "header": "Storage",
  "question": "Where should we store the data?",
  "recommendation": "Use local files first because this application has only one user.",
  "options": [
    {
      "label": "Local files (Recommended)",
      "description": "No database server to manage."
    },
    {
      "label": "PostgreSQL",
      "description": "Shared storage with transactional writes."
    }
  ]
}
```

Only `question` is required by the tool. `header`, `recommendation`, and `options` are optional. The grilling skill requires a recommendation on every question. Option labels must be non-blank and distinct. Custom answers are always allowed.

Results include `question`, `answer`, `wasCustom`, and `cancelled` in both tool details and structured output. The answer is the selected label or the custom text. On cancellation, `answer` is `null` and `cancelled` is `true`. Tool results persist in the session and are sent to the model.

## Other Pi modes

RPC clients receive Pi's standard `select` and `input` dialogs instead of the custom terminal screen. RPC custom answers use an input dialog rather than the terminal's multi-line editor.

Print and JSON modes cannot collect interactive answers. The tool reports that UI is unavailable, and the grilling skill falls back to one question at a time in normal chat. If you disable or exclude the `question` tool, the skill also uses normal chat.
