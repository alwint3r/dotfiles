---
name: exec-planner
description: Create and maintain a self-contained execution plan (ExecPlan) for complex engineering work, with robust fallback behavior when external references fail to load.
---

# Exec Planner

## When To Use

Use this skill when work needs careful planning before implementation, especially for:

- complex features
- significant refactors
- cross-module changes
- migration work
- any request that explicitly asks for an execution plan

## Research and Write-Access Policy

Create the first ExecPlan draft early, not after exhaustive research.

1. Start with minimal reconnaissance of the current working directory:
   - inspect the top-level repository state
   - identify the most likely files or modules involved
   - capture the main constraints, assumptions, and unknowns
2. Do not perform broad or deep codebase research before the first ExecPlan draft exists.
3. If write permission is not available yet:
   - draft the full ExecPlan inline in chat immediately after minimal reconnaissance
   - keep the required section structure
   - mark unresolved details explicitly with `TBD` or equivalent notes
   - stop short of implementation edits
4. If write permission is available:
   - perform the same minimal reconnaissance
   - write the initial ExecPlan file under `.agent/execplans/` before implementation edits
   - then continue deeper research, updating the same plan as discoveries are made
5. Never let the first saved or shared ExecPlan appear already complete unless the task itself is already complete.

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

Produce exactly one ExecPlan markdown file per planning request and persist it under the project working directory:

- directory: `.agent/execplans/`
- filename: `execplan_<YYYYMMDD>_<HHMMSS>_<name>.md`
- naming rules:
  - `<name>` is lower-case and uses `-` between words
  - keep names short and task-specific
  - avoid collisions by regenerating timestamp or appending `-v2`, `-v3`, and so on

Here, `.agent/` is the project-local working directory for agent artifacts (not the skill install directory).

The plan file must be executable by a novice contributor with only the repository and that single plan file.

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
2. Keep the plan fully self-contained. The reader must be able to succeed with only the repository checkout and the ExecPlan file.
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
14. When revising the plan, propagate updates across all sections and append a short change note at the bottom describing what changed and why.
15. During implementation from an ExecPlan, do not ask the user for next steps; proceed to the next milestone autonomously.
16. Perform only minimal working-tree reconnaissance before the first draft; deeper research belongs after the initial ExecPlan exists.
17. If write permission is unavailable, produce the full skeleton inline with explicit unknowns instead of delaying for more research.
18. If write permission is available, persist the initial ExecPlan before any implementation edits.

## Formatting Rules

- If the ExecPlan is delivered inline in chat, format it as one fenced code block labeled `md`.
- If writing directly to a `.md` file whose entire content is the ExecPlan, omit outer triple backticks.
- Do not use nested triple-backtick fences inside an ExecPlan; use indented blocks for commands and transcripts.

## Authoring Workflow

1. Resolve PLANS guidance source using the Resource Loading sequence, then follow that guidance.
2. Resolve purpose and user-visible outcome first.
3. Perform minimal reconnaissance of the current working tree to identify likely files, constraints, and open questions.
4. Draft the initial ExecPlan immediately, even if some details are still marked `TBD`.
5. If write permission is available, save the initial plan under `.agent/execplans/` using the required naming convention before implementation edits. If write permission is unavailable, emit the draft inline and stop before implementation.
6. After the first draft exists, deepen repository research only as needed to remove important ambiguity.
7. Write or refine concrete execution and validation steps with expected outcomes.
8. Initialize and maintain the living sections (`Progress`, `Surprises & Discoveries`, `Decision Log`, `Outcomes & Retrospective`).
9. When implementation starts, continuously update the same plan file as a living document.

## Completion Checklist

Before finishing, verify:

- path normalization removed any leading `@` before file reads
- lookup attempted repo-local then user-level canonical paths before broader fallback paths
- PLANS guidance was loaded from a valid source, or fallback core rules were applied
- the plan is self-contained and novice-usable
- required sections exist and are populated
- the first plan draft was created after minimal reconnaissance rather than exhaustive pre-research
- unresolved details are called out explicitly instead of being silently deferred
- commands and acceptance checks are concrete
- file paths are explicit and repository-relative
- if write permission was available, the plan was saved to `.agent/execplans/` with a unique name before implementation edits
