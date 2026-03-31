# Codebase to Course

A skill that turns any codebase into a beautiful, interactive HTML course designed to help a human learner truly understand how the system works.

Point it at a repo. Get back a self-contained course directory that teaches the codebase through scroll-based modules, animated visualizations, embedded quizzes, code-to-plain-language translations, and active practice prompts.

## Who is this for?

People with a project they can run but cannot yet explain with confidence.

That project may have been assembled quickly from templates, copied examples, tutorials, or AI-assisted iteration. It may be an open-source codebase they want to study. The common problem is the same: the learner does not yet have a durable mental model of the system.

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
- **Code <-> plain-language translations** using real code from the project
- **Animated visualizations** such as data flow animations, group chats between components, and architecture diagrams
- **Interactive quizzes** that test tracing, debugging, and transfer instead of memorization
- **Prediction checkpoints** that ask the learner to think before the explanation appears
- **Hands-on practice prompts** that send the learner back to the real files or runtime behavior
- **Glossary tooltips** so technical terms are explained where they first appear
- **Warm, distinctive design** instead of generic AI-themed visuals

## How to use

1. Copy the `codebase-to-course` folder into your skills directory.
2. Open a project.
3. Ask for a course, for example: "Turn this codebase into an interactive course."

### Trigger phrases

- "Turn this into a course"
- "Explain this codebase interactively"
- "Make a course from this project"
- "Teach me how this code works"
- "Interactive tutorial from this code"

## Design philosophy

### Build first, understand later

The learner starts from a real project that already does something concrete. That gives every concept a reason to matter.

### Predict, inspect, explain, test, reflect

The course should repeatedly ask the learner to predict behavior, inspect the real code, explain it in plain language, test the idea against the project, and reflect on what changed in their understanding.

### Quizzes test transfer, not memorization

Good questions ask what the learner would do in a new scenario, where they would look for a bug, or how a change would move through the system.

### Original code only

Code snippets should be copied exactly from the real project. The learner should be able to open the source and see the same code they studied.

## Credits

This skill is direct modification of the original [codebase-to-course](https://github.com/zarazhangrui/codebase-to-course) skill made by [Zara](https://x.com/zarazhangrui).
