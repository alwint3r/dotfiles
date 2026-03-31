# Gotchas - Common Failure Points

> **When to read this:** During Phase 3 (writing module HTML) and Phase 4 (review). Check every one of these before considering a course complete.

These are real problems encountered when building courses. Check every one before considering a course complete.

### Tooltip Clipping

Translation blocks use `overflow: hidden` for code wrapping. If tooltips use `position: absolute` inside the term element, they get clipped by the container. **Fix:** Tooltips must use `position: fixed` and be appended to `document.body`. Calculate position from `getBoundingClientRect()`. This is already handled by `main.js` but is the most common bug in builds.

### Not Enough Tooltips

The most common failure is under-tooltipping. Learners who are serious but still building foundations may not know terms like `REPL`, `JSON`, `flag`, `entry point`, `PATH`, `pip`, `namespace`, `function`, `class`, `module`, `PR`, or `E2E`. **Rule of thumb:** if a term would not show up in ordinary everyday conversation, tooltip it. Err on the side of too many.

### Passive Consumption

A module explains everything but never asks the learner to think first. Every module needs at least one moment where the learner must predict, trace, choose, or explain before the answer is revealed.

### Walls of Text

The course starts looking like a textbook instead of an infographic. This happens when you write more than 2-3 sentences in a row without a visual break. Every screen must be at least 50% visual.

### Recycled Metaphors

Using "restaurant" or "kitchen" for everything. Every module needs its own metaphor that fits the concept organically.

### Code Modifications

Trimming, simplifying, or "cleaning up" code snippets from the codebase. The learner should be able to open the real file and see the exact same code. Instead of editing code to be shorter, choose naturally short snippets that already illustrate the point.

### Quiz Questions That Test Memory

Asking "What does API stand for?" or "Which file handles X?" Those test memory, not understanding. Every quiz question should present a new scenario and ask the learner to apply what they learned.

### No Manual Practice

A module explains the code but never sends the learner back to the real project to inspect a file, trace a value, compare a runtime behavior, or make a safe small change. The course should train action, not just recognition.

### AI Escape Hatch

The course tells the learner to ask AI for an explanation, a fix, or the next step. Do not do that. The course should point them toward the next observation they can make themselves.

### Scroll-Snap Mandatory

Using `scroll-snap-type: y mandatory` traps users inside long modules. Always use `proximity`.

### Module Quality Degradation

Trying to write all modules in one pass causes later modules to become thin and rushed. Build one module at a time and verify each before moving on. For complex codebases, use the parallel path with module briefs.

### Missing Interactive Elements

A module with only text and code blocks, no interactivity. Every module needs at least one of: quiz, data flow animation, group chat, architecture diagram, drag-and-drop, or another strong interactive teaching element.
