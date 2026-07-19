---
name: exec-planner
description: Create and maintain a self-contained ExecPlan for complex engineering work. Use when the user explicitly requests an execution plan or asks for plan-driven implementation. Do not invoke solely because a direct implementation task is complex.
---

# Exec Planner

## When To Use

Use this skill when the user:

- explicitly asks for an ExecPlan or execution-plan deliverable, or
- asks for plan-driven implementation of a complex feature, significant refactor, cross-module change, or migration.

Do not invoke this skill solely because a direct implementation request is complex. Do not create an ExecPlan artifact unless the request selects or clearly implies one of the delivery modes below.

## Delivery, Authorization, and Research Policy

Tool availability is not user authorization. The ability to write files or create commits does not by itself permit repository changes.

Choose exactly one delivery mode:

1. **User-specified path:** Write the ExecPlan to that path.
2. **Explicit inline request:** Return the ExecPlan in chat and do not create a plan file.
3. **Planning-only request with no delivery format:** Return the completed ExecPlan inline by default.
4. **Plan-driven implementation:** Persist a living ExecPlan before implementation edits. Use an existing repository convention when one exists; otherwise use `.agent/execplans/`.
5. **Read-only environment:** Return the plan inline and do not attempt implementation edits.

Do not create both an inline plan and a plan file unless the user explicitly requests both. A planning-only request authorizes research and plan production, not implementation edits. A plan-driven implementation request authorizes relevant implementation edits but does not authorize commits, destructive operations, or unrelated repository changes.

For plan-driven implementation:

1. Perform minimal reconnaissance of the current working directory to identify the likely files, constraints, assumptions, and unknowns.
2. Persist the initial living ExecPlan before implementation edits.
3. Deepen research and update the same plan as discoveries are made.

For planning-only requests:

1. Perform proportional repository research before delivery.
2. Produce one completed plan rather than exposing an intentionally incomplete skeleton.
3. Mark facts that cannot be established as assumptions, open questions, or `TBD`.
4. Do not perform implementation edits.

## Resource Loading (Robust)

Before writing the ExecPlan, load PLANS guidance using this exact normalization and lookup sequence:

1. Normalize any candidate path before calling file tools:
   - If a path starts with `@`, remove exactly one leading `@`.
   - If the normalized path is relative, resolve it against the project working directory.
   - Never call file tools with a literal `@...` path.
2. Try candidate files in this order and stop at the first successful read:
   - Caller-provided normalized path (if one was provided)
   - `.agents/skills/exec-planner/references/PLANS.md` (repo-local canonical path)
   - `${HOME}/.agents/skills/exec-planner/references/PLANS.md` (user-level canonical path)
   - `references/PLANS.md` (legacy repo-local path)
   - `<skill_root>/references/PLANS.md` where `<skill_root>` is the directory containing this `SKILL.md`
3. If every candidate fails, continue using the embedded PLANS core in this skill.

Do not fail the task only because an external PLANS reference could not be loaded.

## Output Contract

Produce exactly one logical ExecPlan per planning request. Deliver it either as one persisted Markdown file or inline in chat when inline delivery is requested, persistence is not authorized, or the environment is read-only.

For persisted plans, choose the path in this order:

1. User-provided path.
2. Existing repository ExecPlan convention.
3. `.agent/execplans/execplan_<YYYYMMDD>_<HHMMSS>_<name>.md`.

Do not create `.agent/execplans/` unless a persisted plan is required. For the default filename, `<name>` is lower-case, uses hyphens between words, and is short and task-specific. Avoid collisions by regenerating the timestamp or appending `-v2`, `-v3`, and so on.

A persisted plan must be executable by a novice contributor with only the repository and that single plan file. An inline plan must satisfy the same self-contained quality bar.

## Required Sections In Every ExecPlan

Every plan must include and keep current:

- `Purpose / Big Picture`
- `Progress`
- `Surprises & Discoveries`
- `Decision Log`
- `Outcomes & Retrospective`
- `Context and Orientation`
- `Plan of Work`
- `Concrete Steps`
- `Validation and Acceptance`
- `Idempotence and Recovery`
- `Artifacts and Notes`
- `Interfaces and Dependencies`

## Embedded PLANS Core (Fallback and Minimum Quality Bar)

Apply these rules whenever external `PLANS.md` cannot be loaded. Even when `PLANS.md` is available, treat these rules as mandatory minimum checks:

1. Write for a complete novice to this repository. Define non-obvious terms immediately in plain language.
2. Keep the plan fully self-contained. The reader must be able to succeed with only the repository checkout and the delivered ExecPlan, whether inline or persisted.
3. Begin with user value: explain what becomes possible after the change and how to observe it working.
4. Keep all required sections present and current: `Purpose / Big Picture`, `Progress`, `Surprises & Discoveries`, `Decision Log`, `Outcomes & Retrospective`, `Context and Orientation`, `Plan of Work`, `Concrete Steps`, `Validation and Acceptance`, `Idempotence and Recovery`, `Artifacts and Notes`, and `Interfaces and Dependencies`.
5. Keep narrative sections prose-first. Use checklists only in `Progress`, where checkbox items are required.
6. Keep `Progress` as timestamped checkboxes and update it at every stopping point.
7. Record every meaningful course correction in `Decision Log` with rationale and date/author.
8. Record unexpected findings in `Surprises & Discoveries` with concise evidence snippets.
9. Update `Outcomes & Retrospective` at major milestones and at completion.
10. Use repository-relative paths for all files and concrete command lines with explicit working directory.
11. Anchor acceptance in observable behavior (tests, CLI output, HTTP response, or another user-visible signal), not only internal code changes.
12. Prefer idempotent, additive, and safe steps. Include retry or rollback guidance for risky actions.
13. If the plan is provided inline in chat, emit one fenced `md` block and do not nest triple-backtick fences inside it. If the plan is written directly to a `.md` file whose entire content is the plan, omit outer triple backticks.
14. When revising the plan, propagate updates across every affected section. Record meaningful decisions and course corrections as append-only entries in `Decision Log`; routine wording corrections need no history entry.
15. During plan-driven implementation, do not ask generic questions such as "What should I do next?" Continue autonomously only when the next step is safe, reversible, and supported by the plan.
16. Ask a targeted question before deciding consequential matters involving product behavior, public API compatibility, security or privacy, destructive data changes, irreversible migrations, external services or material cost, unsupported platform changes, or materially different tradeoffs.
17. For planning-only work, record unresolved consequential decisions with options and a recommendation rather than silently choosing.
18. Apply the research policy for the selected delivery mode: early living draft for plan-driven implementation, proportional research before a completed planning-only deliverable.
19. Never create, amend, squash, rebase, push, or otherwise modify Git history unless explicitly authorized by the user or repository instructions.

## Formatting Rules

- If the ExecPlan is delivered inline in chat, format it as one fenced code block labeled `md`.
- If writing directly to a `.md` file whose entire content is the ExecPlan, omit outer triple backticks.
- Do not use nested triple-backtick fences inside an ExecPlan; use indented blocks for commands and transcripts.

## Authoring Workflow

1. Resolve PLANS guidance using the Resource Loading sequence.
2. Determine whether the request is planning-only or plan-driven implementation, then select the authorized delivery mode and output path.
3. Resolve purpose and user-visible outcome first.
4. For planning-only work, perform proportional research and deliver one completed inline or persisted plan without implementation edits.
5. For plan-driven implementation, perform minimal reconnaissance and persist the initial living plan before implementation edits.
6. Deepen repository research only as needed to remove important ambiguity, and update a persisted living plan as discoveries are made.
7. Write concrete execution and validation steps with expected outcomes.
8. Initialize and maintain the living sections (`Progress`, `Surprises & Discoveries`, `Decision Log`, `Outcomes & Retrospective`).
9. Ask only targeted questions required by the ambiguity policy; otherwise continue safely through the plan.
10. Do not modify Git history unless explicitly authorized.

## Completion Checklist

Before finishing, verify:

- path normalization removed any leading `@` before file reads
- lookup attempted any caller-provided path, then repo-local and user-level canonical paths before broader fallback paths
- PLANS guidance was loaded from a valid source, or fallback core rules were applied
- the plan is self-contained and novice-usable
- required sections exist and are populated
- the selected delivery mode and output path match the user's request and authorization
- planning-only work received proportional research and no implementation edits
- plan-driven implementation has a persisted living plan created before implementation edits
- unresolved details are called out explicitly instead of being silently deferred
- consequential ambiguities were asked or documented with options and a recommendation
- commands and acceptance checks are concrete
- file paths are explicit and repository-relative
- meaningful history is captured in append-only `Decision Log` entries
- no Git history was modified without explicit authorization
