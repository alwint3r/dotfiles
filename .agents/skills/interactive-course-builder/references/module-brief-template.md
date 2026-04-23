# Module Brief Template

> **When to read this:** During Phase 2.5 for complex-scope courses. Fill in one brief per module and save it to `course-name/briefs/0N-slug.md`. Each brief should give a module-writing worker everything it needs to write one module without reading the full source corpus or `SKILL.md`.

---

## Module N: [Title]

### Effort Profile
- **Profile:** [Strict or Balanced]
- **Target challenge level:** [How demanding this module should feel]
- **Passive explanation cap:** [Strict: <= 90 seconds, Balanced: <= 2-3 minutes]

### Teaching Arc
- **Metaphor:** [A fresh, specific metaphor. Never "restaurant."]
- **Opening hook:** [1 sentence that connects to something the learner already knows from using the product, workflow, or scenario]
- **Key insight:** [The one thing the learner should walk away understanding]
- **Human capability built:** [What this module helps the learner do better on their own]
- **Prediction checkpoint:** [What the learner should guess before the explanation]
- **Attempt-before-reveal gate:** [What the learner must attempt before hints/solution open]
- **Hint ladder:** [Hint 1 conceptual, Hint 2 structural, Hint 3 near-solution]
- **Misconception trap:** [Tempting wrong reasoning and why it fails]
- **Practice prompt:** [What concrete file, function, command, behavior, or prompt-defined artifact the learner should inspect or modify]
- **Transfer task:** [Where this idea must be applied in a new file/module/context]
- **Confidence checkpoint:** [Where confidence is rated before and after]
- **Reflection / retrieval prompt:** [What they should restate, recall, or compare after the lesson]
- **Delayed retrieval target:** [Which earlier concept is reactivated here]

### Code Snippets (pre-extracted)

Include the source snippets the module will use in code <-> plain-language translation blocks.
- If codebase-backed: copy-paste real code with file path and line numbers.
- If prompt-only: provide concise illustrative snippets and label them `Illustrative (not from repo)`.
- If article-backed: provide short article excerpts with section/paragraph anchors for evidence-grounded quiz writing.
The writing worker will use these verbatim and will not re-read full source inputs.

File: src/example/file.ts (lines 12-24)
[paste actual code here]

File: src/another/file.ts (lines 45-52)
[paste actual code here]

Article: https://example.com/article (section "How the cache works", paragraph 3)
[paste short quote fragment here]

### Article Evidence Map (required for article-grounded quiz mode)

List one row per planned question so grounding can be verified.

| Question ID | Article anchor | Evidence quote fragment | What the question checks |
|---|---|---|---|
| Q1 | [section/paragraph] | "[short quote]" | [understanding target] |

### Interactive Elements

Check which elements this module needs. Include enough detail for the writing worker to build them.

- [ ] **Code <-> plain-language translation** - which snippet(s) from above
- [ ] **Quiz** - [number] questions, style: [scenario / debugging / architecture / tracing / transfer]. Brief description of each question's angle. If article-backed, include source anchor for each question.
- [ ] **Group chat animation** - actors: [list]. Message flow summary: [who says what to whom, in what order]
- [ ] **Data flow animation** - actors: [list]. Steps: [sequence of highlights and packet movements]
- [ ] **Drag-and-drop** - items: [list], targets: [list]
- [ ] **Attempt gate + hint ladder** - [exercise id]. Define attempt condition, 3 hints, and solution reveal trigger.
- [ ] **Confidence checkpoint** - [before/after scope]. Define what is being rated.
- [ ] **Effort rubric card** - [retrieval/tracing/debugging/transfer/explanation/confidence] with criteria.
- [ ] **Other** - [architecture diagram, layer toggle, pattern cards, timeline, etc.]

### Learning Moves To Preserve

- **Prediction before reveal:** [where this happens in the module]
- **Attempt before reveal:** [what blocks answer reveal until learner attempts]
- **Manual practice:** [where the learner must inspect or change something themselves]
- **Retrieval:** [what earlier concept this module asks them to recall]
- **Delayed retrieval:** [which module/concept from earlier appears again here]
- **Transfer:** [where learner applies concept in a new context]
- **Misconception correction:** [wrong path and correction loop]
- **Reflection:** [what they should articulate after finishing the module]

### Effort Targets and Scoring Notes

- **Attempts expected:** [count]
- **Hint usage budget:** [count or guidance]
- **Primary scoring focus:** [retrieval / tracing / debugging / transfer / explanation quality / confidence calibration]
- **Success evidence:** [what observable output proves understanding]

### Reference Files to Read

List only the sections the writing worker needs, not the whole file.

- `references/interactive-elements.md` -> [section names, for example "Multiple-Choice Quizzes", "Group Chat Animation"]
- `references/design-system.md` -> [only if needed for specific tokens not already clear from the brief]
- `references/content-philosophy.md` -> [always include]
- `references/gotchas.md` -> [always include]

### Connections

- **Previous module:** [Title - what it covered, so this module can build on it]
- **Next module:** [Title - what it will cover, so this module can set it up]
- **Tone/style notes:** [Any course-wide consistency notes: accent color name, actor naming convention, level of scaffolding, etc.]
