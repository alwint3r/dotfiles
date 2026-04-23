# Content Philosophy

> **When to read this:** During Phase 2.5 (writing module briefs) and Phase 3 (writing module HTML). These principles guide every content decision: what to show, how to explain it, and how to make the learner think.

These principles are what separate a great course from a generic tutorial.

### Show, Don't Tell - Aggressively Visual

People stop paying attention when a course turns into a wall of paragraphs. The course should feel closer to an infographic than a textbook. Follow these hard rules:

**Text limits:**
- Max **2-3 sentences** per text block. If you are writing a fourth sentence, stop and convert it into a visual instead.
- No text block should ever be wider than the content width and taller than about 4 lines. If it is, break it up with a visual element.
- Every screen must be **at least 50% visual** (diagrams, code blocks, cards, animations, badges, timelines, flow steps, or other non-paragraph teaching elements).

**Convert text to visuals:**
- A list of 3+ items -> **cards with icons**
- A sequence of steps -> **flow diagram with arrows** or **numbered step cards**
- "Component A talks to Component B" -> **animated data flow** or **group chat visualization**
- "This file does X, that file does Y" -> **visual file tree with annotations** or **icon + one-liner badges**
- Explaining what code does -> **code <-> plain-language translation block** (not a paragraph about the code)
- Comparing two approaches -> **side-by-side columns** with visual contrast

**Visual breathing room:**
- Use generous spacing between elements (`--space-8` to `--space-12` between sections)
- Alternate between full-width visuals and narrow text blocks to create rhythm
- Every module should have at least one "hero visual" that teaches the core concept at a glance

### Code <-> Plain-Language Translations

Every code snippet gets a side-by-side plain-language translation. Left panel: source code (real code when available, illustrative code when prompt-only) with syntax highlighting. Right panel: line-by-line plain-language explanation of what each line does. This is one of the most valuable teaching tools for learners building software intuition.

**Critical: No horizontal scrollbars on code.** All code must use `white-space: pre-wrap` so it wraps instead of scrolling. This is a course for learning, not an IDE. Readability beats preserving indentation shape.

**Critical: Preserve source fidelity.** If the course is codebase-backed, use original code exactly as-is. Never modify, simplify, or trim snippets from the repository. If the course is prompt-only, label snippets as illustrative and keep them consistent with the stated architecture and constraints. If the source is a web article, every quiz question and explanation must be grounded in explicit article evidence.

### One Concept Per Screen

Each screen within a module teaches exactly one idea. If you need more space, add another screen. Do not cram.

### Metaphors First, Then Reality

Introduce every new concept with a metaphor from everyday life. Then ground it immediately: "In our code, this looks like..." The metaphor builds intuition; the code grounds it in reality.

**Critical: No recycled metaphors.** Do not default to "restaurant" for everything. Each concept deserves a metaphor that feels natural to that specific idea. If you catch yourself using "restaurant" or "kitchen" more than once in a course, stop and rethink.

### Learn by Tracing Real Behavior

Follow what actually happens when the learner does something meaningful in the source material. Trace the flow end-to-end. Start from a concrete action they can imagine or reproduce, then show the journey through the system.

### Desirable Difficulty Over Smooth Reading

Learning should feel effortful in a productive way. Avoid "explain first, quiz later" sequencing.

- Ask the learner to commit to a prediction before any explanation.
- Require an explicit attempt before showing full solutions.
- Use incorrect-but-plausible distractors and explain why they are tempting.
- Keep friction on reasoning tasks, not on UI mechanics.
- Treat temporary struggle as a design goal when it leads to better transfer.

**Profile constraints:**
- **Strict profile:** no passive explanation longer than about 90 seconds without an action.
- **Balanced profile:** no passive explanation longer than about 2-3 minutes without an action.

### Use a Metacognitive Loop

Each module should repeatedly move through this loop:

1. **Predict** what will happen before the answer is revealed.
2. **Attempt** the task (trace, debug, decide, or edit) before seeing the full answer.
3. **Inspect** the code, file, UI event, command, or runtime signal that settles the question.
4. **Feedback** on correctness plus why wrong paths were tempting.
5. **Explain** the idea in plain language.
6. **Transfer** by applying the same concept in a new context.
7. **Reflect** by asking what changed in the learner's understanding or where the same pattern appears again.

The explanation should not arrive too early. If the learner has not had a chance to think first, the course becomes passive consumption.

### Progressive Hints and Solution Gates

For major exercises, include a 3-step hint ladder and a gated solution reveal:

1. **Hint 1 (conceptual):** what principle to think about.
2. **Hint 2 (structural):** where to look (file/function/path).
3. **Hint 3 (near-solution):** partial scaffold without giving the final answer.

Full solutions should be hidden by default and revealed only after an explicit attempt declaration.

### Confidence Calibration

Use confidence checks to reduce false confidence:

- Ask for confidence **before** a major task.
- Ask again **after** feedback.
- Prompt one sentence: "What changed between your expectation and outcome?"

This metacognitive step is part of the learning objective, not optional garnish.

### Delayed Retrieval and Interleaving

Re-activate earlier concepts later in the course.

- **Strict profile:** at least 2 delayed retrieval prompts per module from prior modules.
- **Balanced profile:** at least 1 delayed retrieval prompt per module from prior modules.

Do not cluster all retrieval at the end. Space it across modules so recall happens after forgetting has started.

### Make It Memorable

Use "aha!" callout boxes for universal software insights. Give components personality when it helps the explanation. Use humor sparingly and only when it supports the concept.

### Glossary Tooltips - No Term Left Behind

Any technical term in the course text should be wrapped in a tooltip that shows a plain-language definition on hover (desktop) or tap (mobile). The learner should never have to leave the page just to decode vocabulary.

**Be aggressive with tooltips.** If there is even a small chance the learner does not know a word, tooltip it. This includes:
- Software names they might not know
- Everyday developer terms (`REPL`, `JSON`, `flag`, `CLI`, `API`, `SDK`, etc.)
- Programming concepts (`function`, `variable`, `dictionary`, `class`, `module`, etc.)
- Infrastructure terms (`PATH`, `pip`, `namespace`, `entry point`, etc.)
- Acronyms on first use

**Vocabulary is part of mastery.** Tooltips should help the learner use the term precisely in their own notes, debugging reasoning, design discussions, or code review comments. A good tooltip gives them language they can reuse.

**Cursor:** Use `cursor: pointer` on terms, not `cursor: help`.

**Tooltip overflow fix:** Translation blocks and other containers with `overflow: hidden` will clip tooltips. To fix this, the tooltip JS must use `position: fixed` and calculate coordinates from `getBoundingClientRect()` instead of relying on CSS `position: absolute` within the container. Append tooltips to `document.body` rather than inside the term element.

### Quizzes That Test Application, Recall, and Transfer

Quizzes should test whether the learner can use what they learned to solve a new problem, not whether they can recite a definition.

**What to quiz (in order of value):**
1. **"What would you do?" scenarios** - present a new situation and ask the learner to apply what they learned
2. **Debugging scenarios** - "A user reports X is broken. Where would you look first, and why?"
3. **Tracing exercises** - "When a user does X, trace the path the data takes"
4. **Architecture decisions** - "You need to add Y. Which part of the system should own it?"
5. **Transfer prompts** - "Where else in this system does the same pattern show up?"

**What NOT to quiz:**
- Definitions ("What does API stand for?")
- File-name memorization ("Which file handles X?")
- Syntax trivia
- Anything the learner can answer by scrolling up and copying

**Quiz tone:**
- Wrong answers get clear, non-punitive explanations
- Correct answers get brief reinforcement of the principle
- The point is thinking, not scoring
- Wrong-answer explanations should teach something new

**How many quizzes:** One per module, placed after the module's core content. Use 3-5 questions. Each question should make the learner pause and think.

**Question quality bar:** At least one question per module must require a multi-step reasoning chain (for example, trace + boundary check + design decision), not a single lookup.

**Deciding what concepts are worth quizzing:** If a concept will help the learner inspect source artifacts, debug a problem, plan a change, or transfer a pattern to another part of the system, it is worth quizzing. If not, it probably belongs in a tooltip or a short explanation instead.

### Article-Grounded Quiz Rules (web page source)

When the source is a provided web page article, quiz generation must follow strict grounding:

- Build an evidence list first (section heading/paragraph anchor + quote fragment).
- Every quiz question must map to one evidence item.
- Do not ask about facts not explicitly stated or strongly implied in the article.
- Wrong-answer explanations must reference why the option conflicts with article evidence.
- If a question cannot be justified by article evidence, remove it.
- Spread questions across major article sections so the quiz checks full-content understanding.

### Do Not Add AI Escape Hatches

Do not tell the learner to ask AI for the answer, the explanation, or the code change. If the learner needs help, point them toward a sharper observation:

- Which file to open next
- Which value to trace
- Which input to vary
- Which symptom to compare against the expected behavior
- Which earlier module to recall
