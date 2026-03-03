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

## Resource Loading (Robust)

Before writing the ExecPlan, try to load PLANS guidance in this order:

1. `references/PLANS.md`
2. `.agents/skills/exec-planner/references/PLANS.md`
3. `@.agents/skills/exec-planner/references/PLANS.md` (if a caller passes this literal path, strip the leading `@` and retry as a local file path)

If all attempts fail, continue using the embedded baseline rules in this skill. Do not fail the task only because a reference file could not be loaded.

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

## Embedded PLANS Baseline (Fallback Rules)

Apply these rules when `PLANS.md` cannot be loaded, and also as a minimum quality bar even when it can:

1. Write for a novice. Define non-obvious terms immediately in plain language.
2. Keep the plan self-contained. Include all context needed to execute the work.
3. Focus on observable outcomes, not only code edits.
4. Use repository-relative paths for all files and concrete command lines with working directory context.
5. Include acceptance checks that prove behavior (tests, CLI output, HTTP responses, or equivalent).
6. Keep `Progress` as checkbox items with timestamps and update it at every stopping point.
7. Record all important course corrections in `Decision Log` with rationale.
8. Record unexpected findings and supporting evidence in `Surprises & Discoveries`.
9. At milestone or completion boundaries, update `Outcomes & Retrospective`.
10. Prefer idempotent and safe steps, with retry or rollback guidance for risky actions.

## Formatting Rules

- If the ExecPlan is delivered inline in chat, format it as one fenced code block labeled `md`.
- If writing directly to a `.md` file whose entire content is the ExecPlan, omit outer triple backticks.
- Do not use nested triple-backtick fences inside an ExecPlan; use indented blocks for commands and transcripts.

## Authoring Workflow

1. Resolve purpose and user-visible outcome first.
2. Read relevant repository files deeply enough to remove ambiguity.
3. Draft context and work plan with exact file paths and function/module targets.
4. Write concrete execution and validation steps with expected outcomes.
5. Initialize living sections (`Progress`, `Surprises & Discoveries`, `Decision Log`, `Outcomes & Retrospective`).
6. Save the plan under `.agent/execplans/` using the required naming convention.
7. When implementation starts, continuously update the same plan file as a living document.

## Completion Checklist

Before finishing, verify:

- the plan is self-contained and novice-usable
- required sections exist and are populated
- commands and acceptance checks are concrete
- file paths are explicit and repository-relative
- the plan was saved to `.agent/execplans/` with a unique name
