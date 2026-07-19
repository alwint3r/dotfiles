# Interactive Course Builder

A skill that turns a real codebase, a prompt-only brief, or a web article into a beautiful, interactive HTML course designed to help a human learner truly understand how the system works.

Point it at a repo, give it a detailed prompt brief, or provide a web article URL. Get back a self-contained course directory that teaches through scroll-based modules, animated visualizations, embedded quizzes, code-to-plain-language translations, and active practice prompts.

The skill supports two rigor profiles:

- **Balanced** (default): high learning with lower frustration
- **Strict**: maximum effort, interview-level challenge, and stronger desirable difficulty constraints

## Who is this for?

People who want to understand a technical system with confidence, whether they already have a project or only have a concept/brief.

The source may be a project assembled quickly from templates, copied examples, tutorials, or AI-assisted iteration. It may be an open-source codebase they want to study, a prompt-only plan for something they have not built yet, or a web article they want to learn deeply from. The common problem is the same: the learner does not yet have a durable mental model of the system.

The course is built for learners who want to:

- Understand how the major parts of the project fit together
- Trace requests, state changes, and data flow without guessing
- Build real vocabulary they can use when reading and discussing code
- Debug by forming hypotheses and checking them against the source
- Make deliberate changes by hand and explain why they work
- Retain what they learn and transfer it to future projects

This skill is not about helping the learner rely on AI more effectively. It is about helping them become more capable on their own.

## What the course looks like

The output is a **directory** that can be opened directly in the browser. It includes shared assets plus per-module HTML files that are assembled into a final `index.html`.

- **Scroll-based modules** with progress tracking and keyboard navigation
- **Code <-> plain-language translations** using real code when available, or clearly labeled illustrative snippets for prompt-only courses
- **Animated visualizations** such as data flow animations, group chats between components, and architecture diagrams
- **Interactive quizzes** that test tracing, debugging, and transfer instead of memorization
- **Prediction checkpoints** that ask the learner to think before the explanation appears
- **Hands-on practice prompts** that send the learner to concrete files/runtime behavior or prompt-defined artifacts and decisions
- **Glossary tooltips** so technical terms are explained where they first appear
- **Warm, distinctive design** instead of generic AI-themed visuals

## How to use

1. Copy the `interactive-course-builder` folder into your skills directory.
2. Provide source input: a local project, GitHub repo, current directory, or prompt-only brief.
3. Ask for a course, for example: "Turn this codebase into an interactive course" or "Create a course from this architecture brief."

For article understanding checks, ask for quiz-only mode directly:

- "Create a quiz from this article URL and check my understanding"
- "Assessment only, based strictly on this webpage"
- "Write a comprehension quiz using only this article"

If you want maximum effort, ask for strict mode directly:

- "Turn this codebase into a strict, high-rigor course"
- "Create a strict course from this prompt brief"
- "Make interview-level hard mode"
- "Optimize for maximum effortful learning"

### Trigger phrases

- "Turn this into a course"
- "Explain this codebase interactively"
- "Make a course from this project"
- "Build an interactive course from this prompt"
- "Teach me how this code works"
- "Interactive tutorial from this code"
- "Teach this architecture as a course"
- "Create an article quiz from this URL"
- "Quiz me on this article only"

## Design philosophy

### Start from concrete behavior

The learner starts from concrete behavior: either a real project that already runs, or a realistic prompt-defined workflow they can reason through. That gives every concept a reason to matter.

### Predict, inspect, explain, test, reflect

The course should repeatedly ask the learner to predict behavior, inspect code or system artifacts, explain ideas in plain language, test those ideas against the source material, and reflect on what changed in their understanding.

In strict mode this becomes: **predict -> attempt -> feedback -> explain -> transfer**, with hints and solutions gated behind a real attempt.

### Quizzes test transfer, not memorization

Good questions ask what the learner would do in a new scenario, where they would look for a bug, or how a change would move through the system.

### Source fidelity first

When real code exists, snippets should be copied exactly from the source project so the learner can verify them directly. For prompt-only courses, snippets must be clearly labeled as illustrative and should stay consistent with the prompt constraints. For web-article quizzes, every question and explanation must map back to explicit article evidence, with no external facts added.

## Credits

This skill is direct modification of the original [codebase-to-course](https://github.com/zarazhangrui/codebase-to-course) skill made by [Zara](https://x.com/zarazhangrui).
