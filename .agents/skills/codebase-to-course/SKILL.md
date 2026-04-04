---
name: codebase-to-course
description: "Turn any codebase into a beautiful, interactive single-page HTML course that helps a human learner understand how the system works through active practice, code tracing, and metacognitive exercises. Use this skill whenever someone wants to create an interactive course, tutorial, or educational walkthrough from a codebase or project, especially when the goal is to truly learn an unfamiliar or fast-built codebase and build durable software intuition."
---

# Codebase-to-Course

Transform any codebase into a stunning, interactive course. The output is a **directory** containing a pre-built `styles.css`, `main.js`, per-module HTML files, and an assembled `index.html`. Open it directly in the browser with no setup required other than the Google Fonts CDN already referenced by the shell. The course should teach how the code works through scroll-based modules, animated visualizations, embedded quizzes, and plain-language translations of real code.

## First-Run Welcome

When the skill is first triggered and the user has not specified a codebase yet, introduce yourself and explain what you do:

> **I can turn any codebase into an interactive course that helps you understand it deeply and practice reasoning through it yourself.**
>
> Point me at a project:
> - **A local folder** - for example, "turn ./my-project into a course"
> - **A GitHub link** - for example, "make a course from https://github.com/user/repo"
> - **The current project** - if you are already inside a codebase, say "turn this into a course"
>
> I will read the code, map how the pieces fit together, and generate a browser-based course with diagrams, code walkthroughs, quizzes, prediction checkpoints, and practice drills. The goal is not passive explanation. The goal is to help you build real understanding of the project.

If the user provides a GitHub link, clone the repo first (`git clone <url> /tmp/<repo-name>`) before starting the analysis. If they say "this codebase" or similar, use the current working directory.

## Who This Is For

The target learner is someone with a working project, but uneven understanding of how it actually works. Maybe they assembled it quickly from templates, copied examples, tutorials, or AI-assisted iterations. Maybe they found an open-source project they admire. Either way, they do not yet trust their own understanding of the system.

Assume little formal background, but do not water the material down into empty simplifications. Every technical term should be explained in plain language on first use, but the course should still treat the learner as capable of doing real thinking. The learner is here to build skill, not to be comforted by vague summaries.

**Their goals are practical and human-centered:**
- Build a mental model of how the parts of the system fit together
- Trace execution and data flow without guessing
- Understand enough vocabulary to describe the code precisely in their own words
- Form debugging hypotheses and test them against the actual code
- Make small, deliberate code changes by hand and explain why they work
- Recognize reusable patterns and failure modes in future projects
- Retain what they learn instead of forgetting it after one reading

**They are trying to become independently capable.** The course should move them from passive observer to active practitioner. Do not frame the learning payoff as "better prompting" or "steering AI better." Frame it as better reading, tracing, debugging, and modifying real software by themselves.

## Why This Approach Works

This skill inverts the usual order of learning. Instead of memorizing abstract concepts first and hoping they matter later, the learner starts from a real project that already does something concrete. They have a working artifact, visible user behavior, and code that matters right now. That gives every concept a reason to exist.

The teaching loop should be: **see the behavior -> predict what happens -> inspect the code -> explain it in plain language -> test the idea -> reflect on what was misunderstood.** That loop builds metacognition, which means noticing what you do and do not understand, catching false confidence early, and improving your mental model over time.

Every module should answer **"what skill does this build?"** before "what concept does this explain?" The answer should always be about human capability: tracing a request, locating logic, spotting boundaries, debugging a symptom, or deciding where a change belongs.

The directory-based output is intentional: separating CSS and JS from content keeps the boilerplate stable, keeps the HTML modules focused on teaching, and makes the final `index.html` easy to assemble and open locally.

## Learning Pillars

Every course must repeatedly use these pillars of learning:

- **Prediction before reveal** - ask the learner to guess what the code or system will do before showing the answer
- **Self-explanation** - require the learner to restate the idea in plain language, not just read the explanation
- **Retrieval practice** - revisit earlier concepts in later modules so the learner has to recall, not merely re-read
- **Deliberate tracing** - have the learner follow real execution paths, file boundaries, and data movement by hand
- **Reflection and transfer** - prompt the learner to name what confused them, what changed in their mental model, and where the same pattern appears elsewhere

The course must not tell the learner to hand the hard part to AI. If the learner is stuck, the course should direct them back to the code, the runtime behavior, and a concrete next observation they can make themselves.

---

## The Process

### Phase 1: Codebase Analysis

Before writing course HTML, understand the codebase deeply. Read the key files, trace the main execution paths, identify the "cast of characters" (components, services, modules), and map how they communicate. Thoroughness here pays off. The better you understand the codebase, the better you can teach it.

**What to extract:**
- The main actors and their responsibilities
- The primary user journey from one meaningful action to an observable result
- Key APIs, data flows, and communication patterns
- Clever engineering patterns (caching, lazy loading, retries, error handling, batching, etc.)
- Fragile points, bugs, or gotchas visible in code, tests, comments, or git history
- Places where a learner can manually verify behavior or make a small safe change
- The tech stack and why each piece exists in this project

Figure out what the app does yourself by reading the README, the main entry points, and the UI or CLI entry path. Do not ask the user to explain the product unless the repository truly leaves it ambiguous. The course should open by explaining what the project does in plain language before diving into how it works. The first module should start with a concrete user action, such as "imagine you click Publish" or "imagine you run this command," and trace what happens under the hood.

### Phase 2: Curriculum Design

Structure the course as **4-6 modules**. Most courses need 4-6. Only go to 7-8 if the codebase genuinely has that many distinct concepts worth teaching. Fewer, stronger modules beat more, thinner ones.

The arc should always start from what the learner can observe and move toward what they need to reason about. Think of it as zooming in: begin with the lived behavior, then peel back layers until the learner can explain the machinery and use that understanding elsewhere.

| Module Position | Purpose | Human skill built |
|---|---|---|
| 1 | "Here is what this project does - and what happens when you use it" | Build a concrete anchor and practice the first end-to-end trace |
| 2 | Meet the actors | Build a mental map of which parts own which responsibilities |
| 3 | How the pieces talk | Practice following data flow and control flow without hand-waving |
| 4 | The outside world (APIs, databases, files, services) | Understand boundaries, inputs, outputs, and failure modes |
| 5 | The clever tricks | Build design judgment by studying patterns and tradeoffs |
| 6 | When things break | Practice debugging with hypotheses, symptoms, and checks |
| 7 | The big picture | Consolidate the architecture and transfer the lessons to future changes |

This is a **menu, not a checklist**. Pick the modules that serve the codebase. A small CLI tool might need 4. A full-stack app might need 6 or 7.

**The key principle:** Every module should connect back to a real human skill. If a module does not help the learner inspect, predict, trace, debug, or modify code with more independence, cut it or reframe it until it does.

**Each module should contain:**
- 3-6 screens that flow as one learning story
- At least one code-with-plain-language translation
- At least one interactive element (quiz, visualization, animation, drag-and-drop, or diagram)
- One or two "aha!" callout boxes with universal software insights
- A metaphor that grounds the concept in everyday life, without repeating metaphors across modules
- At least one **prediction checkpoint** that appears before the explanation
- At least one **practice prompt** that sends the learner to a real file, function, or behavior to inspect by hand
- At least one brief **reflection or retrieval prompt** that asks the learner to recall or restate something in their own words

**Mandatory interactive elements (every course must include ALL of these):**
- **Group Chat Animation** - at least one across the course. These component conversations are highly engaging and make coordination visible.
- **Message Flow / Data Flow Animation** - at least one across the course. Animate request paths, state transitions, or data movement step by step.
- **Code <-> Plain-Language Translation Blocks** - at least one per module.
- **Quizzes** - at least one per module.
- **Glossary Tooltips** - on every technical term, first use per module.

**Mandatory learning moves (every course must include ALL of these):**
- **Prediction checkpoints** - the learner must guess before the explanation appears
- **Manual practice prompts** - the learner must inspect or change something in the real project themselves
- **Retrieval prompts** - later modules must briefly reactivate earlier learning
- **Reflection prompts** - the learner must name what changed in their understanding

These teaching moves are the backbone of the course. Other interactive elements (architecture diagrams, layer toggles, pattern cards, timeline cards, etc.) are optional and should be added when they fit.

Do **not** present the curriculum for approval. Design it internally, then build it. If the user wants changes, they can react to the finished course.

After designing the curriculum, decide which build path to use:

- **Simple codebase** (single-purpose CLI, small web app, library, one clear entry point, 5 or fewer modules) -> go directly to Phase 3 Sequential.
- **Complex codebase** (full-stack app, multiple services, content-heavy site, monorepo, or 6+ modules) -> go to Phase 2.5 first, then Phase 3 Parallel.

### Phase 2.5: Module Briefs (complex codebases only)

For complex codebases, write a brief for each module before writing any HTML. This is the critical step that enables parallel writing. Each brief should give a module-writing worker everything it needs without re-reading the codebase.

Read `references/module-brief-template.md` for the template structure. Read `references/content-philosophy.md` for the content rules that should guide brief writing.

**For each module, write a brief to `course-name/briefs/0N-slug.md` containing:**
- The teaching arc (metaphor, opening hook, key insight, human capability being built)
- Pre-extracted code snippets copied from the codebase with file paths and line numbers
- Interactive elements checklist with enough detail to build them
- The prediction checkpoint, practice prompt, and retrieval/reflection moves for the module
- Which sections of which reference files the writing worker needs
- What the previous and next modules cover, so transitions stay coherent

The code snippets are the critical token-saving step. By pre-extracting them into the brief, writing workers never need to read the full codebase at all.

### Phase 3: Build the Course

The course output is a **directory**, not a single file. All CSS and JS are pre-built reference files. Do not regenerate them. Your job is to write only the HTML content and customize the shell.

**Output structure:**
```
course-name/
  styles.css       <- copied verbatim from references/styles.css
  main.js          <- copied verbatim from references/main.js
  _base.html       <- customized shell (title, accent color, nav dots)
  _footer.html     <- copied verbatim from references/_footer.html
  build.sh         <- copied verbatim from references/build.sh
  briefs/          <- module briefs (complex codebases only, can delete after build)
  modules/
    01-intro.html
    02-actors.html
    ...
  index.html       <- assembled by build.sh (do not write manually)
```

**Step 1 (both paths): Setup** - Create the course directory. Copy these four files verbatim using Read + Write. Do not regenerate their contents:
- `references/styles.css` -> `course-name/styles.css`
- `references/main.js` -> `course-name/main.js`
- `references/_footer.html` -> `course-name/_footer.html`
- `references/build.sh` -> `course-name/build.sh`

**Step 2 (both paths): Customize `_base.html`** - Read `references/_base.html`, then write it to `course-name/_base.html` with exactly three substitutions:
- Both instances of `COURSE_TITLE` -> the actual course title
- The four `ACCENT_*` placeholders -> the chosen accent color values (pick one palette from the comments in `_base.html`)
- `NAV_DOTS` -> one `<button class="nav-dot" ...>` per module

**Step 3: Write modules** - This is where the paths diverge.

#### Sequential path (simple codebases)

Read `references/content-philosophy.md` and `references/gotchas.md`. Then write modules one at a time. For each module, write `course-name/modules/0N-slug.html` containing only the `<section class="module" id="module-N">` block and its contents. Do not include `<html>`, `<head>`, `<body>`, `<style>`, or `<script>` tags.

Read `references/interactive-elements.md` for HTML patterns for each interactive element type. Read `references/design-system.md` for visual conventions.

#### Parallel path (complex codebases)

Dispatch modules to workers in batches of up to 3. Each worker receives:
- Its module brief from `course-name/briefs/`
- `references/content-philosophy.md` and `references/gotchas.md`
- Only the sections of `references/interactive-elements.md` and `references/design-system.md` listed in the brief

Each worker writes its module file or files to `course-name/modules/`. Short modules can be paired if one worker can cover them cleanly.

**What workers do NOT receive:** the full codebase (snippets are in the brief), `SKILL.md`, other modules' briefs, or unneeded reference file sections.

After all workers finish, do a quick consistency check in the main context: nav dots match modules, transitions between modules are coherent, tone is steady, and the prediction/practice prompts remain concrete rather than generic.

**Step 4 (both paths): Assemble** - Run `build.sh` from the course directory:
```bash
cd course-name && bash build.sh
```
This produces `index.html`. Open it in the browser.

**Critical rules:**
- **Never regenerate** `styles.css` or `main.js` - always copy from references
- Module files contain only `<section>` content - no boilerplate
- Avoid page-level scroll snapping by default; keep normal wheel/touch scrolling and use explicit smooth scrolling only for guided navigation
- Use `min-height: 100dvh` with `100vh` fallback on `.module`
- Interactive element JS is in `main.js`; wire up via `data-*` attributes and CSS class names as shown in `references/interactive-elements.md`
- Chat containers need `id` attributes; flow animations need `data-steps='[...]'` JSON on `.flow-animation`
- Do not tell the learner to "ask AI" for the answer. Keep the learner anchored in the real files, runtime behavior, and their own reasoning.

### Phase 4: Review and Open

After running `build.sh`, open `index.html` in the browser. Review whether the course is visually strong, technically accurate, and genuinely active instead of passive. Check that every module makes the learner do some thinking before the answer is revealed, and that the practice prompts send them back to the real codebase. Then walk the user through what was built and ask for feedback on clarity, rigor, pacing, and interactivity.

---

## Design Identity

The visual design should feel like a **beautiful developer notebook** - warm, inviting, and distinctive. Read `references/design-system.md` for the full token system, but here are the non-negotiable principles:

- **Warm palette**: Off-white backgrounds, warm grays, no cold whites or blues
- **Bold accent**: One confident accent color (vermillion, coral, teal - not purple gradients)
- **Distinctive typography**: Display font with personality for headings (Bricolage Grotesque or similar bold geometric face - never Inter, Roboto, Arial, or Space Grotesk). Clean sans-serif for body (DM Sans or similar). JetBrains Mono for code.
- **Generous whitespace**: Modules should breathe. Max 3-4 short paragraphs per screen.
- **Alternating backgrounds**: Even and odd modules should alternate between two warm background tones for rhythm
- **Dark code blocks**: IDE-style with Catppuccin-inspired syntax highlighting on deep indigo-charcoal (`#1E1E2E`)
- **Depth without harshness**: Subtle warm shadows, never black drop shadows

---

## Reference Files

The `references/` directory contains detailed specs. Read them only when you reach the relevant phase so context stays lean.

- **`references/content-philosophy.md`** - visual density rules, metaphor guidelines, prediction and quiz design, tooltip rules, code translation guidance, practice-loop guidance. Read during Phase 2.5 (briefs) and Phase 3 (writing modules).
- **`references/gotchas.md`** - common failure points checklist. Read during Phase 3 and Phase 4 (review).
- **`references/module-brief-template.md`** - template for Phase 2.5 module briefs. Read only for complex codebases using the parallel path.
- **`references/design-system.md`** - complete CSS custom properties, color palette, typography scale, spacing system, shadows, animations, scrollbar styling. Read during Phase 3 when writing module HTML.
- **`references/interactive-elements.md`** - implementation patterns for quizzes, animations, translation blocks, diagrams, and callout structures. Read only the relevant sections during Phase 3.
