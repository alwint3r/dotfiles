---
name: interactive-course-builder
description: "Create a beautiful, interactive single-page HTML course from a codebase, prompt brief, or web article. Also supports article-grounded quiz-only assessments when a user wants to check understanding from a provided webpage."
---

# Interactive Course Builder

Transform source material into a stunning, interactive course. The source can be a real codebase, an existing project spec, a prompt-only brief, or a web page article. The output is a **directory** containing a pre-built `styles.css`, `main.js`, per-module HTML files, and an assembled `index.html`. Open it directly in the browser with no setup required other than the Google Fonts CDN already referenced by the shell.

## First-Run Welcome

When the skill is first triggered and the user has not specified source material yet, introduce yourself and explain what you do:

> **I can build an interactive course from real code, a prompt-only brief, or a web article, so you can learn by doing instead of passively reading.**
>
> Give me one of these inputs:
> - **A local folder** - for example, "turn ./my-project into a course"
> - **A GitHub link** - for example, "make a course from https://github.com/user/repo"
> - **The current project** - if you are already inside a codebase, say "turn this into a course"
> - **A prompt brief only** - for example, "create a course about building a realtime chat backend from scratch"
> - **A web page article URL** - for example, "create a quiz from https://example.com/article and test my understanding"
> - **A deep-dive long course** - for example, "teach me how to rasterize a triangle with Vulkan from scratch" or "I want a comprehensive course on writing a compiler"
>
> For standard topics, I generate 4-8 module courses. For non-trivial deep dives (like Vulkan, compilers, databases), I generate 10-20 module mastery courses with a three-act spiral structure, cumulative checkpoints, and deliberate retrieval across the full journey. The goal is not passive explanation. The goal is to help you build real understanding.

If the user provides a GitHub link, clone the repo first (`git clone <url> /tmp/<repo-name>`) before starting the analysis. If they say "this codebase" or similar, use the current working directory. If they provide prompt-only input, do not block waiting for a repository; proceed using the prompt as the source of truth. If they provide a web article URL, fetch and read the article first, then build from that article as the sole source of truth.

## Who This Is For

The target learner is someone with uneven understanding of a technical system they want to master. Sometimes they already have a working project. Sometimes they only have a concept, architecture idea, or product brief. Either way, they do not yet trust their own understanding of how the system should work.

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

This skill inverts the usual order of learning. Instead of memorizing abstract concepts first and hoping they matter later, the learner starts from something concrete: either a working project or a realistic build brief. They always have visible behavior, scenarios, or code paths to reason through, which gives every concept a reason to exist.

The teaching loop should be: **see the behavior -> predict what happens -> inspect the code -> explain it in plain language -> test the idea -> reflect on what was misunderstood.** That loop builds metacognition, which means noticing what you do and do not understand, catching false confidence early, and improving your mental model over time.

Every module should answer **"what skill does this build?"** before "what concept does this explain?" The answer should always be about human capability: tracing a request, locating logic, spotting boundaries, debugging a symptom, or deciding where a change belongs.

The directory-based output is intentional: separating CSS and JS from content keeps the boilerplate stable, keeps the HTML modules focused on teaching, and makes the final `index.html` easy to assemble and open locally.

## Learning Pillars

Every course must repeatedly use these pillars of learning:

- **Prediction before reveal** - ask the learner to guess what the code, system, or rule set will do before showing the answer
- **Self-explanation** - require the learner to restate the idea in plain language, not just read the explanation
- **Retrieval practice** - revisit earlier concepts in later modules so the learner has to recall, not merely re-read
- **Deliberate tracing** - have the learner follow real execution paths, file boundaries, and data movement by hand
- **Reflection and transfer** - prompt the learner to name what confused them, what changed in their mental model, and where the same pattern appears elsewhere

The course must not tell the learner to hand the hard part to AI. If the learner is stuck, the course should direct them back to the source material, the observable behavior, and a concrete next observation they can make themselves.

## Concept Complexity & Explanation Depth

Not all concepts need the same amount of explanation. The course must adjust reading depth to match concept complexity — some ideas are simple and can be explained in a paragraph; others are dense and need a multi-screen deep-dive before the learner can reason about them.

**Concept complexity heuristic:** Before writing each module, ask: *"Can a learner who has never seen this concept before explain it back to me in their own words after reading the explanation?"* If the answer is no, the explanation needs more depth.

| Complexity tier | Indicators | Minimum explanation depth | Maximum uninterrupted prose per screen | Visual balance |
|---|---|---|---|---|
| **Simple** | Definition-like concept, single-step, no dependencies | 1-2 paragraphs, 1 screen | 3-4 paragraphs | Heavy visual emphasis (50%+ visual) |
| **Moderate** | Multi-step concept, 1-2 dependencies, requires tracing | 2-4 paragraphs across 1-2 screens | 3-4 paragraphs | Balanced (visuals and text alternate naturally) |
| **Complex** | Multi-layered, 3+ dependencies, requires tracing + reasoning + transfer to understand | 4-8 paragraphs across 2-4 screens | 5-6 paragraphs, followed by a visual or interactive break | Visuals support but don't dominate; deep prose is the primary teaching medium |
| **Foundational** | Core abstraction that the rest of the course builds on (e.g., graphics pipeline in Vulkan, type system in a compiler, B-tree in a database) | 6-12 paragraphs across 3-6 screens, with progressive revelation (introduce → explain → trace → connect) | Up to 6 paragraphs, broken by inline code snippets, diagrams, or prediction checkpoints | Prose-led with strategic visuals; the goal is deep conceptual clarity, not visual appeal |

**Hard rule:** Even for complex and foundational concepts, every screen must include at least one interactive or visual break (code block, diagram, prediction checkpoint, callout box, or glossary tooltip). No screen should be a wall of undifferentiated text. But the break should serve the explanation, not truncate it.

**Progressive revelation for deep concepts:** Don't dump all paragraphs at once. Reveal understanding in layers:
1. **What it is** — metaphor and plain-language definition (1-2 paragraphs)
2. **Why it exists** — the problem it solves, what breaks without it (1-2 paragraphs)
3. **How it works** — mechanism, data structures, step-by-step trace (2-4 paragraphs)
4. **How it connects** — where it fits in the larger system, what depends on it (1-2 paragraphs)
5. **When it fails** — edge cases, gotchas, debugging surface (1-2 paragraphs)

Each layer can be a separate screen with its own interactive element. The learner should feel they are descending into understanding, not being hit with a wall of text.

## Effort Profiles (Required)

Every generated course must declare one effort profile and enforce it throughout all modules.

- **Strict profile** (maximum effort): Use when the user asks for maximum effort, interview-level rigor, hard mode, intense practice, or deep mastery.
- **Balanced profile** (default): Use when the user asks for a normal course and does not request extreme rigor.
- **Mastery profile** (long-form deep dive): Use when the user asks for a really long course, comprehensive coverage, "teach me X from scratch," or explicitly wants 10+ modules. This profile is designed for non-trivial topics (e.g., building a Vulkan renderer, writing a compiler, implementing a database engine) where the learner needs to internalize a large, interconnected system over many hours.

Do not ask for profile selection unless the user explicitly asks to choose. Infer from intent.

| Profile | Explanation depth rule | Required module loop | Hint policy | Retrieval policy | Target length |
|---|---|---|---|---|---|
| Strict | Match depth to concept complexity using the tiers above. Simple concepts stay concise; complex concepts get full progressive revelation. Never pad for length — every sentence must earn its place. | Prediction -> Attempt -> Feedback -> Explanation -> Transfer | 3-level progressive hints; full solution hidden until first attempt | At least 2 delayed retrieval prompts per module from earlier modules | 4-8 modules |
| Balanced | Match depth to concept complexity. Use progressive revelation for moderate and complex concepts. Keep simple concepts tight. | Prediction -> Attempt -> Feedback -> Explanation -> Transfer | 2-3 level hints; full solution hidden until first attempt | At least 1 delayed retrieval prompt per module from earlier modules | 4-8 modules |
| Mastery | Full progressive revelation for every concept tier moderate and above. Foundational concepts get the complete 5-layer treatment across multiple screens. No artificial length caps — depth is governed only by what the learner needs to achieve genuine understanding. | Prediction -> Attempt -> Feedback -> Explanation -> Transfer | 3-level progressive hints; full solution hidden until first attempt | At least 2 delayed retrieval prompts per module from earlier modules, plus at least 3 cumulative retrieval checkpoints across the full course | 10-20 modules |

**Hard requirement for all profiles:** explanations come after learner effort. Never reveal the answer before a meaningful attempt.

---

## Article Quiz-Only Mode (Web Source)

Use this mode when the user provides a web page article and asks for a quiz-only assessment (for example: "create a quiz from this article," "test my understanding," or "assessment only").

**Behavior:**
- Produce a quiz-focused course artifact (typically 1 module) optimized for understanding checks rather than full architecture walkthrough.
- Generate 5-12 questions total (strict: 8-12, balanced: 5-8), using scenario, tracing, inference, and transfer prompts grounded in the article.
- Include confidence-before and confidence-after checkpoints and a brief reflection prompt.

**Grounding requirements (mandatory):**
- Every question must be answerable from explicit article content. No outside facts, prior world knowledge, or unstated assumptions.
- Each question must have an evidence anchor captured during analysis (section heading or paragraph reference plus a short quote fragment).
- Wrong options must be plausible from the article context, but still clearly contradicted by article evidence.
- If a concept is not stated or strongly implied by the article, do not ask about it.
- Explanations must point back to article evidence, not to general background knowledge.

**Coverage rule:**
- Distribute questions across the article's major sections. Avoid clustering all questions in one part of the article.

## The Process

### Phase 1: Source Analysis

Before writing course HTML, understand the source deeply.

If the source is a codebase, read key files, trace execution paths, identify the "cast of characters" (components, services, modules), and map how they communicate.

If the source is prompt-only, extract the core system shape from the prompt: actors, flows, boundaries, key decisions, failure modes, and implementation milestones. Where code snippets are useful, create concise illustrative snippets and explicitly label them as illustrative rather than copied from a real repository.

If the source is a web page article, extract an evidence map before designing any quiz: section outline, key claims, definitions, cause/effect statements, constraints, and examples. Keep references to where each claim appears so every question can be traced back to the article.

**What to extract:**
- The main actors and their responsibilities
- The primary learner journey from one meaningful action to an observable result
- Key APIs, data flows, and communication patterns
- Clever engineering patterns (caching, lazy loading, retries, error handling, batching, etc.)
- Fragile points, bugs, or gotchas visible in code, tests, comments, git history, or design assumptions
- Places where a learner can manually verify behavior or make a small safe change
- The tech stack (real or proposed) and why each piece exists
- For web articles: a list of quiz-worthy claims with article evidence anchors (heading/paragraph + short quote fragment)

For codebase input, figure out what the app does yourself by reading the README, main entry points, and UI or CLI entry path. For prompt-only input, restate the intended product behavior and architecture in plain language before creating modules. For web article input, restate the article's key sections and claims in plain language, then map each planned quiz question to a specific evidence anchor. In all modes, begin from a concrete learner action and observable consequence.

### Phase 2: Curriculum Design

**For Balanced and Strict profiles:** Structure the course as **4-6 modules**. Most courses need 4-6. Only go to 7-8 if the source material genuinely has that many distinct concepts worth teaching. Fewer, stronger modules beat more, thinner ones.

**For Mastery profile (long-form deep dive):** Structure the course as **10-20 modules**. These courses cover non-trivial topics where the learner needs to build a system from zero understanding to working implementation. Each module should be a self-contained unit that builds one concrete capability, but modules should form a deliberate spiral: concepts introduced early are revisited with increasing depth later.

Exception: in **Article Quiz-Only Mode**, build a focused 1-module assessment (optionally 2 modules if a separate short recap module is needed).

The arc should always start from what the learner can observe and move toward what they need to reason about. Think of it as zooming in: begin with the lived behavior, then peel back layers until the learner can explain the machinery and use that understanding elsewhere.

#### Module Purpose Table (4-8 module courses)

| Module Position | Purpose | Human skill built |
|---|---|---|
| 1 | "Here is what this project does - and what happens when you use it" | Build a concrete anchor and practice the first end-to-end trace |
| 2 | Meet the actors | Build a mental map of which parts own which responsibilities |
| 3 | How the pieces talk | Practice following data flow and control flow without hand-waving |
| 4 | The outside world (APIs, databases, files, services) | Understand boundaries, inputs, outputs, and failure modes |
| 5 | The clever tricks | Build design judgment by studying patterns and tradeoffs |
| 6 | When things break | Practice debugging with hypotheses, symptoms, and checks |
| 7 | The big picture | Consolidate the architecture and transfer the lessons to future changes |

This is a **menu, not a checklist**. Pick the modules that serve the source material. A small CLI tool or narrow concept might need 4. A full-stack app might need 6 or 7.

#### Module Arc for Mastery (10-20 module courses)

For long-form courses, the modules follow a three-act structure with deliberate spiraling:

**Act I: Foundation & Orientation (modules ~1-4)**

| Module Role | Purpose | Human skill built |
|---|---|---|
| Orientation | What are we building and why? End-to-end behavior demo, mental model preview | Anchor the destination — the learner can picture what success looks like |
| Prerequisites & Setup | Toolchain, environment, core concepts the learner must install and verify | Build the learner's workspace; verify they can compile/run before coding |
| First Contact | The simplest possible working example — write it, run it, inspect it | Trace a complete execution from source to output without abstraction |
| Conceptual Foundation | The big ideas and vocabulary of the domain (not code yet — mental models) | Map the conceptual territory so the learner has language for what follows |

**Act II: Core Machinery (modules ~5-14)**

For a deep technical topic, decompose it into its natural subsystems. Each subsystem gets 1-3 modules following this pattern:
- **Module A: What it does and why it exists** (concept, observable behavior, metaphor)
- **Module B: How it works internally** (code walkthrough, data structures, algorithms, tracing)
- **Module C: When it breaks and how to fix it** (failure modes, debugging, edge cases, tuning)

| Module Role | Purpose | Human skill built |
|---|---|---|
| Subsystem: Purpose | Why this piece exists in the architecture and what would break without it | Reason about architectural necessity; trace dependency chains |
| Subsystem: Machinery | Walk the implementation line by line. Data structures, algorithms, control flow | Read and explain complex implementation code; map code to concepts |
| Subsystem: Failure Modes | Common bugs, edge cases, performance cliffs, misconfigurations | Debug this subsystem; form and test hypotheses; recognize anti-patterns |
| Cross-Cutting: Data Flow | How data moves between subsystems. Tracing a request/pixel/transaction end-to-end | Cross-boundary tracing; understand coupling and contracts |
| Cross-Cutting: Control Flow | Synchronization, ordering, state machines, lifecycle management | Reason about concurrency, ordering, and temporal behavior |

**Act III: Synthesis & Mastery (modules ~15-20)**

| Module Role | Purpose | Human skill built |
|---|---|---|
| Integration | Put subsystems together. Handle real-world coordination complexity | Integrate independently-understood pieces into a coherent whole |
| Performance & Profiling | Measure, analyze, and optimize the system | Use tools to find bottlenecks; form and test performance hypotheses |
| The Big Picture | Full architecture review. How every piece fits. Design rationale and alternatives | Articulate the complete system design and justify design choices |
| Extend & Transfer | Add a feature the course didn't build. Apply patterns to a different domain | Design and implement independently; recognize reusable patterns |
| Capstone | Build something real that combines at least 3 subsystems | Synthesize everything into a working artifact without scaffolding |

This is a **menu, not a checklist**. For a 12-module Vulkan course, you might pick: Orientation, Setup, First Triangle (conceptual), Instance & Devices, Swapchain, Pipeline (shaders + layout), Render Pass & Framebuffer, Command Buffers, Synchronization, Drawing the Triangle (integration), Debugging & Validation, Performance & Extend.

The key principle is the same: every module answers "what skill does this build?" before "what concept does this explain?"

**The key principle:** Every module should connect back to a real human skill. If a module does not help the learner inspect, predict, trace, debug, or modify code with more independence, cut it or reframe it until it does.

**Each module should contain:**
- 3-8 screens that flow as one learning story (more screens for modules covering complex or foundational concepts; fewer for simple, single-idea modules)
- At least one code-with-plain-language translation
- At least one interactive element (quiz, visualization, animation, drag-and-drop, or diagram)
- One or two "aha!" callout boxes with universal software insights
- A metaphor that grounds the concept in everyday life, without repeating metaphors across modules
- At least one **prediction checkpoint** that appears before the explanation
- At least one **practice prompt** that sends the learner to a concrete file/function/behavior (or a concrete prompt-defined artifact) to inspect by hand
- At least one brief **reflection or retrieval prompt** that asks the learner to recall or restate something in their own words

**Per-module rigor targets by profile:**

| Profile | Prediction checkpoints | Tracing drills | Bug/localization tasks | Transfer tasks | Misconception traps | Confidence checks |
|---|---|---|---|---|---|---|
| Strict | 2+ | 2+ | 1+ | 1+ | 1+ | Before and after each major task |
| Balanced | 1+ | 1+ | 1 every 1-2 modules | 1 every module | 1 every 1-2 modules | Before and after each module |
| Mastery | 2+ | 2+ | 1+ | 1+ | 1+ | Before and after each module + before and after each cumulative checkpoint |

Include one capstone synthesis challenge at the end of the course that combines at least two modules (strict: at least three modules, mastery: at least five modules). For Mastery profile, also include cumulative checkpoints at the end of each Act that test synthesis across all modules in that Act.

**Mandatory interactive elements (every course must include ALL of these):**
- **Group Chat Animation** - at least one across the course. These component conversations are highly engaging and make coordination visible.
- **Message Flow / Data Flow Animation** - at least one across the course. Animate request paths, state transitions, or data movement step by step.
- **Code <-> Plain-Language Translation Blocks** - at least one per module.
- **Quizzes** - at least one per module.
- **Glossary Tooltips** - on every technical term, first use per module.

For **Article Quiz-Only Mode**, minimum required elements are quizzes, confidence checkpoints, and glossary tooltips. Other elements are optional when they materially improve understanding checks.

**Mandatory learning moves (every course must include ALL of these):**
- **Prediction checkpoints** - the learner must guess before the explanation appears
- **Attempt-before-reveal gates** - hints and final solutions appear only after an explicit learner attempt
- **Manual practice prompts** - the learner must inspect or change something concrete themselves
- **Retrieval prompts** - later modules must briefly reactivate earlier learning
- **Reflection prompts** - the learner must name what changed in their understanding
- **Misconception traps** - include tempting wrong paths and explain why they are attractive but incorrect
- **Confidence calibration** - collect confidence before and after tasks/modules and compare with performance

These teaching moves are the backbone of the course. Other interactive elements (architecture diagrams, layer toggles, pattern cards, timeline cards, etc.) are optional and should be added when they fit.

Do **not** present the curriculum for approval. Design it internally, then build it. If the user wants changes, they can react to the finished course.

After designing the curriculum, decide which build path to use:

- **Simple course scope** (single-purpose CLI, small web app, narrow prompt brief, one clear flow, 5 or fewer modules) -> go directly to Phase 3 Sequential.
- **Complex course scope** (full-stack app, multiple services, content-heavy domain brief, monorepo, or 6-9 modules) -> go to Phase 2.5 first, then Phase 3 Parallel.
- **Mastery course scope** (10+ modules, deep technical topic, Mastery profile) -> go to Phase 2.5 first with extended briefs (see Mastery extension below), then Phase 3 Parallel in larger batches.

### Phase 2.5: Module Briefs (complex and mastery scope)

For complex and mastery courses, write a brief for each module before writing any HTML. This is the critical step that enables parallel writing. Each brief should give a module-writing worker everything it needs without re-reading raw source inputs.

Read `references/module-brief-template.md` for the template structure. Read `references/content-philosophy.md` for the content rules that should guide brief writing.

**For each module, write a brief to `course-name/briefs/0N-slug.md` containing:**
- The teaching arc (metaphor, opening hook, key insight, human capability being built)
- Pre-extracted source snippets:
  - If codebase-backed: copied from source with file paths and line numbers
  - If prompt-only: short illustrative snippets clearly labeled `Illustrative (not from repo)`
  - If article-backed: short article excerpts with section/paragraph anchors for quiz evidence
- Interactive elements checklist with enough detail to build them
- The prediction checkpoint, practice prompt, delayed retrieval target, and reflection moves for the module
- The misconception trap and transfer task for the module
- The confidence checkpoint placement and hint ladder plan
- For article-backed quizzes: per-question evidence anchors proving each question is grounded in the article
- Which sections of which reference files the writing worker needs
- What the previous and next modules cover, so transitions stay coherent

The source snippets are the critical token-saving step. By pre-extracting them into the brief, writing workers never need to read the full raw source corpus.

#### Mastery Extension: Course-Level Brief

For Mastery profile courses (10+ modules), write one additional course-level brief at `course-name/briefs/00-mastery-plan.md` before writing per-module briefs. This document contains:

- **The spiral map:** A table of every major concept and which modules introduce, deepen, and transfer it. This ensures concepts aren't taught once and forgotten — they reappear with increasing depth.
- **The dependency graph:** Which modules depend on which earlier modules. This prevents writing Module 8 before knowing what Module 3 actually established.
- **The metaphor register:** A list of metaphors already used, to prevent accidental reuse across 10-20 modules.
- **The retrieval schedule:** Which earlier concepts each module must reactivate with delayed retrieval prompts.
- **The cumulative checkpoint plan:** At least 3 points in the course where the learner demonstrates synthesis across multiple modules (not just the capstone at the end). These are placed at the end of Act I, mid Act II, and end of Act III.
- **Module grouping for parallel dispatch:** Workers are dispatched in groups of 3-5 modules that share conceptual territory. Modules 1-4 (Foundation) can be written together. Then 5-8, then 9-12, then 13-16, then 17-20. Within each group, briefs include enough context about adjacent modules that transitions stay coherent without workers needing to read every other brief.

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
  briefs/          <- module briefs (complex and mastery scope only, can delete after build)
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

#### Sequential path (simple scope)

Read `references/content-philosophy.md` and `references/gotchas.md`. Then write modules one at a time. For each module, write `course-name/modules/0N-slug.html` containing only the `<section class="module" id="module-N">` block and its contents. Do not include `<html>`, `<head>`, `<body>`, `<style>`, or `<script>` tags.

Read `references/interactive-elements.md` for HTML patterns for each interactive element type. Read `references/design-system.md` for visual conventions.

#### Parallel path (complex and mastery scope)

**For complex scope (6-9 modules):** Dispatch modules to workers in batches of up to 3. Each worker receives:
- Its module brief from `course-name/briefs/`
- `references/content-philosophy.md` and `references/gotchas.md`
- Only the sections of `references/interactive-elements.md` and `references/design-system.md` listed in the brief

**For mastery scope (10-20 modules):** Dispatch in grouped batches of 3-5 modules following the groupings in `00-mastery-plan.md`. The first batch contains Act I (Foundation) modules. Subsequent batches contain Act II (Core Machinery) groups. The final batch contains Act III (Synthesis) modules. Each worker in a batch receives the same materials as complex scope, plus the course-level mastery plan for context on the spiral and retrieval schedule.

Each worker writes its module file or files to `course-name/modules/`. Short modules can be paired if one worker can cover them cleanly.

**What workers do NOT receive:** the full raw source corpus (snippets are in the brief), `SKILL.md`, other modules' briefs, or unneeded reference file sections.

After each batch finishes, do a consistency check in the main context: nav dots match modules, transitions between modules are coherent, tone is steady, and the prediction/practice prompts remain concrete rather than generic. After the final batch, run a full-course review:

- Verify the spiral map: each major concept appears at least 2-3 times with increasing depth.
- Verify the retrieval schedule: delayed retrieval prompts reference the correct earlier modules.
- Verify cumulative checkpoints: at least 3 synthesis challenges exist and span multiple modules.
- Verify no metaphor reuse across the full 10-20 modules.
- Verify effort profile consistency: attempt-before-reveal gates, delayed retrieval, misconception traps, and confidence calibration are present.

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
- Include explicit attempt gates and progressive hints for major exercises using the patterns in `references/interactive-elements.md`
- Include an effort rubric near the end of the course that scores retrieval, tracing, debugging, transfer, explanation quality, and confidence calibration
- Do not tell the learner to "ask AI" for the answer. Keep the learner anchored in concrete files, runtime behavior, prompt constraints, and their own reasoning.

### Phase 4: Review and Open

After running `build.sh`, open `index.html` in the browser. Review whether the course is visually strong, technically accurate, and genuinely active instead of passive. Check that every module makes the learner do some thinking before the answer is revealed, that practice prompts point to concrete artifacts (real files when available), and that delayed retrieval and confidence checkpoints are present. Then walk the user through what was built and ask for feedback on clarity, rigor, pacing, and interactivity.

---

## Design Identity

The visual design should feel like a **beautiful developer notebook** - warm, inviting, and distinctive. Read `references/design-system.md` for the full token system, but here are the non-negotiable principles:

- **Warm palette**: Off-white backgrounds, warm grays, no cold whites or blues
- **Bold accent**: One confident accent color (vermillion, coral, teal - not purple gradients)
- **Distinctive typography**: Display font with personality for headings (Bricolage Grotesque or similar bold geometric face - never Inter, Roboto, Arial, or Space Grotesk). Clean sans-serif for body (DM Sans or similar). JetBrains Mono for code.
- **Generous whitespace**: Modules should breathe. Paragraph count per screen varies by concept complexity (see Concept Complexity & Explanation Depth table above). Complex and foundational concepts need room for deep prose; simple concepts stay tight. No screen should be a wall of undifferentiated text — strategic breaks are mandatory.
- **Alternating backgrounds**: Even and odd modules should alternate between two warm background tones for rhythm
- **Dark code blocks**: IDE-style with Catppuccin-inspired syntax highlighting on deep indigo-charcoal (`#1E1E2E`)
- **Depth without harshness**: Subtle warm shadows, never black drop shadows

---

## Reference Files

The `references/` directory contains detailed specs. Read them only when you reach the relevant phase so context stays lean.

- **`references/content-philosophy.md`** - visual density rules, metaphor guidelines, desirable difficulty constraints, prediction and quiz design, tooltip rules, code translation guidance, and practice-loop guidance. Read during Phase 2.5 (briefs) and Phase 3 (writing modules).
- **`references/gotchas.md`** - common failure points checklist. Read during Phase 3 and Phase 4 (review).
- **`references/module-brief-template.md`** - template for Phase 2.5 module briefs. Read only for complex-scope and mastery-scope courses using the parallel path.
- **`references/design-system.md`** - complete CSS custom properties, color palette, typography scale, spacing system, shadows, animations, scrollbar styling. Read during Phase 3 when writing module HTML.
- **`references/interactive-elements.md`** - implementation patterns for quizzes, animations, translation blocks, attempt gates, confidence checkpoints, effort rubrics, diagrams, and callout structures. Read only the relevant sections during Phase 3.
