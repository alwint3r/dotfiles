# Module Brief Template

> **When to read this:** During Phase 2.5 for complex codebases. Fill in one brief per module and save it to `course-name/briefs/0N-slug.md`. Each brief should give a module-writing worker everything it needs to write one module without reading the codebase or `SKILL.md`.

---

## Module N: [Title]

### Teaching Arc
- **Metaphor:** [A fresh, specific metaphor. Never "restaurant."]
- **Opening hook:** [1 sentence that connects to something the learner already knows from using the project]
- **Key insight:** [The one thing the learner should walk away understanding]
- **Human capability built:** [What this module helps the learner do better on their own]
- **Prediction checkpoint:** [What the learner should guess before the explanation]
- **Practice prompt:** [What real file, function, command, or behavior the learner should inspect or modify]
- **Reflection / retrieval prompt:** [What they should restate, recall, or compare after the lesson]

### Code Snippets (pre-extracted)

Include the actual code the module will use in code <-> plain-language translation blocks. Copy-paste from the codebase with file path and line numbers. The writing worker will use these verbatim and will not re-read the codebase.

File: src/example/file.ts (lines 12-24)
[paste actual code here]

File: src/another/file.ts (lines 45-52)
[paste actual code here]

### Interactive Elements

Check which elements this module needs. Include enough detail for the writing worker to build them.

- [ ] **Code <-> plain-language translation** - which snippet(s) from above
- [ ] **Quiz** - [number] questions, style: [scenario / debugging / architecture / tracing / transfer]. Brief description of each question's angle.
- [ ] **Group chat animation** - actors: [list]. Message flow summary: [who says what to whom, in what order]
- [ ] **Data flow animation** - actors: [list]. Steps: [sequence of highlights and packet movements]
- [ ] **Drag-and-drop** - items: [list], targets: [list]
- [ ] **Other** - [architecture diagram, layer toggle, pattern cards, timeline, etc.]

### Learning Moves To Preserve

- **Prediction before reveal:** [where this happens in the module]
- **Manual practice:** [where the learner must inspect or change something themselves]
- **Retrieval:** [what earlier concept this module asks them to recall]
- **Reflection:** [what they should articulate after finishing the module]

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
