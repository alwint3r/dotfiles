---
name: semantic-compression-agent
description: Apply Casey Muratori-style semantic compression to software development tasks only. Use when an agent must compress code intent, refactoring goals, API changes, or implementation plans while preserving constraints; and when it must decompress compressed code briefs into concrete edits, tests, and validation steps without introducing premature abstractions.
---

# Semantic Compression Agent

## Scope

- Apply this skill only to source code work:
  - implementation planning
  - refactoring
  - API/interface shaping
  - code review synthesis
  - test planning tied to code changes
- Do not apply this skill to general prose summarization, business writing, legal text, or non-code documents.

## Core Principles (Faithful to Casey)

- Preserve semantics and change representation.
- Start from concrete code, not abstract frameworks.
- Make code usable before making it reusable.
- Require at least two concrete instances before extracting shared abstractions.
- Build reuse bottom-up from working code.

## Compression Workflow

1. Extract the software semantics:
   - Identify the behavior to implement or change.
   - Identify hard technical constraints.
   - Identify invariants that must remain true.
   - Identify required tests or observable acceptance outcomes.
2. Remove representational noise:
   - Remove repeated wording and explanatory padding.
   - Keep only implementation-relevant meaning.
3. Encode a compact code brief:
   - Keep concrete file/module context visible.
   - Keep unknowns explicit.
4. Check abstraction readiness:
   - If fewer than two concrete instances exist, forbid new reusable abstraction.
5. Validate semantic preservation:
   - Confirm the compressed brief still supports concrete implementation without guessing.

## Decompression Workflow

1. Expand to executable code tasks:
   - Map semantics to file-level edits or module-level changes.
   - Map each constraint and invariant to explicit checks.
2. Produce concrete sequence:
   - Implement usable concrete code path first.
   - Add tests that validate required behavior.
3. Generalize only when justified:
   - Extract shared abstraction only if two real implementations are already present.
   - Keep abstraction strictly derived from existing concrete code.

## Fidelity Guardrails

- Reject top-down abstraction-first plans.
- Reject "framework-first" decompressions when concrete implementation is still missing.
- Reject any compression that removes a technical constraint or invariant.
- Reject reuse proposals based on only one concrete instance.

## Failure Modes and Corrections

- Symptom: Compressed output is short but vague.
  - Correction: Re-add concrete behavior, constraints, and code context.
- Symptom: Plan cannot be executed without guessing.
  - Correction: Decompress into concrete file/module edits and tests.
- Symptom: Reusable abstraction appears before concrete examples.
  - Correction: Return to concrete implementation and defer abstraction.
- Symptom: Proposed abstraction is justified by one use.
  - Correction: Require a second real instance before extraction.

## Output Patterns

Use this code-focused compressed brief format:

```text
Compressed Code Brief
- Behavior Goal:
- Existing Code Context:
- Hard Constraints:
- Invariants:
- Required Tests:
- Concrete Instances Seen:
- Open Questions:
```

Use this decompressed code plan format:

```text
Decompressed Code Plan
- Target Files/Modules:
- Concrete Edit Sequence:
- Constraint Checks:
- Test Cases:
- Abstraction Extraction (only if >=2 instances):
- Validation Commands:
```

Run this round-trip verification checklist before finalizing:
- Confirm every original technical constraint is preserved.
- Confirm each invariant maps to concrete code or test checks.
- Confirm the plan is implementable without hidden assumptions.
- Confirm no shared abstraction appears unless at least two concrete instances exist.

## Resource Loading

- Load `references/casey-semantic-compression.md` for source-grounded wording and principle checks.
- Prefer this file for workflow and the reference file for faithfulness decisions.
