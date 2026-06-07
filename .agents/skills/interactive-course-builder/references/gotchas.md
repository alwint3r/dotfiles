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

Trimming, simplifying, or "cleaning up" code snippets when the course is codebase-backed. The learner should be able to open the real file and see the exact same code. For prompt-only courses, snippets must be clearly labeled as illustrative and stay consistent with the prompt constraints.

### Quiz Questions That Test Memory

Asking "What does API stand for?" or "Which file handles X?" Those test memory, not understanding. Every quiz question should present a new scenario and ask the learner to apply what they learned.

### Quiz Questions Not Grounded In The Article

In web-article quiz mode, questions must be answerable from the provided article alone. A common failure is injecting outside facts or assumptions. Every question should have an explicit article anchor and evidence quote. If it does not, remove it.

### No Manual Practice

A module explains ideas but never sends the learner back to concrete artifacts to inspect a file, trace a value, compare a runtime behavior, examine a design constraint, or make a safe small change. The course should train action, not just recognition.

### AI Escape Hatch

The course tells the learner to ask AI for an explanation, a fix, or the next step. Do not do that. The course should point them toward the next observation they can make themselves.

### Scroll-Snap Defaults

Even `scroll-snap-type: y proximity` can make wheel and trackpad scrolling feel sticky on long single-page courses. Do not enable page-level scroll snapping by default. Only add it intentionally for short, presentation-style experiences where snapping is a clear benefit.

### Module Quality Degradation

Trying to write all modules in one pass causes later modules to become thin and rushed. Build one module at a time and verify each before moving on. For complex course scopes, use the parallel path with module briefs.

### Missing Interactive Elements

A module with only text and code blocks, no interactivity. Every module needs at least one of: quiz, data flow animation, group chat, architecture diagram, drag-and-drop, or another strong interactive teaching element.

### Explanation Before Attempt

The module explains the answer before the learner has predicted or attempted. This destroys desirable difficulty and lowers retention. Enforce prediction and attempt-before-reveal ordering.

### Hint Ladder Collapse

Hints jump straight to the solution or skip conceptual guidance. Keep a true ladder: conceptual -> structural -> near-solution.

### No Misconception Traps

Exercises only include obvious wrong answers. Include at least one plausible but incorrect path and explain why it feels right at first glance.

### No Delayed Retrieval

Earlier concepts are never revisited after one module. Add spaced retrieval prompts in later modules so recall happens after some forgetting.

### Confidence Drift

No confidence checks, or confidence is never compared to actual outcomes. Add before/after confidence prompts for major tasks and capture what changed.

### Weak Transfer

Questions test only local recall from the same screen. Include at least one new-context transfer task per module (or every 1-2 modules for balanced pacing).

### Mastery-Specific Gotchas

These apply only to Mastery profile courses (10-20 modules).

### Spiral Without Depth

A concept reappears in later modules but at the same depth as the first introduction. "We revisit the swapchain" but the second pass just restates what Module 3 said. Each spiral pass must go deeper: first pass = what it does, second pass = how it works internally, third pass = what breaks and how to fix it.

### Metaphor Exhaustion

Running out of good metaphors by module 12 and resorting to weak or recycled ones. The metaphor register in `00-mastery-plan.md` must be maintained throughout all 10-20 briefs. If you struggle to find a fresh metaphor for a subsystem, use a spatial/visual metaphor (conveyor belt, post office, traffic light, plumbing, etc.) or a process metaphor (recipe, assembly line, check-in counter). Review the register before each module.

### Late-Module Fatigue

Modules 14-18 become thin and rushed because the writer is running out of energy. The parallel dispatch system (grouped batches) prevents this, but the consistency check after each batch must verify that Act III modules match the rigor of Act I modules. If fatigue is visible, slow down and write each batch as carefully as the first.

### Cumulative Checkpoint Collapse

Cumulative checkpoints at end-of-Act become token recall quizzes instead of genuine synthesis. A cumulative checkpoint should present a new scenario that requires reasoning across 3+ modules, not a list of trivia questions. The learner should have to trace a cross-cutting concern (e.g., "trace a pixel from shader to screen, identifying every Vulkan object it touches") rather than answer "what does vkCreateSwapchainKHR do?"

### Missing the Dependency Graph

Module 8 assumes Module 5 taught a concept in depth, but Module 5 only introduced it briefly. The dependency graph in `00-mastery-plan.md` prevents this: every module declares what it depends on and what it establishes for later modules. If a dependency is only shallowly covered, the brief must note this so the dependent module can fill the gap.

### Navigation Overwhelm

A 20-module course has 20 nav dots in a single row, making navigation difficult. Consider grouping nav dots into act-based clusters with visible act labels, or using a collapsible nav that shows act groupings. The `_base.html` nav must scale gracefully to 20 modules.

### Scope Creep

A 12-module plan becomes 20 modules because every interesting detail gets its own module. Resist. Each module must earn its place by building a distinct human skill. If two proposed modules teach the same skill at the same level, merge them. A 12-module course that is consistently rigorous beats a 20-module course that is padded.
