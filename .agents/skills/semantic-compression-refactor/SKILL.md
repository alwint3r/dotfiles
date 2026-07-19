---
name: semantic-compression-refactor
description: Refactor existing code using Casey Muratori-style semantic compression. Use when repeated or substantially similar concrete code should be compressed bottom-up into smaller reusable operations without introducing speculative abstractions. Require at least two real instances before extracting reusable code. Do not use for general planning, requirements summarization, greenfield architecture, or non-code prose.
---

# Semantic Compression Refactor

Refactor concrete, working code by finding repeated semantics and expressing those semantics once. Optimize for the total human effort required to write, understand, debug, modify, extend, and maintain the code over its useful lifetime—not for line count alone.

## Scope

Use this skill to refactor existing source code when the goal is to:

- remove duplicated or substantively similar behavior;
- extract reusable operations from at least two real instances;
- gather repeatedly shared, interacting state into a minimal data structure;
- make common operations easier to read, modify, debug, and extend;
- reduce lifetime development effort without hiding unique behavior.

Do not use this skill for:

- general implementation or execution planning;
- ExecPlan creation;
- requirements, prompt, or prose summarization;
- greenfield architecture design;
- speculative API, framework, or class-hierarchy design;
- extracting reusable code from zero or one real instance.

If the user requests an ExecPlan, use the ExecPlan workflow instead. This skill does not create a competing brief or plan artifact.

## Core Principles

1. **Begin with concrete behavior.** Read the implementation and understand what each case actually does before proposing structure.
2. **Make code usable before making it reusable.** Keep a one-off case direct and local until repetition provides evidence for reuse.
3. **Require at least two real instances.** Do not invent a second consumer or hypothetical future requirement to justify extraction.
4. **Compress semantics, not text.** Similar syntax is not enough; the instances must perform the same or substantively similar operation.
5. **Extract bottom-up.** Let names, helper operations, shared state, and larger structure emerge from working details.
6. **Keep unique behavior local.** Do not force unlike cases through flags, callbacks, inheritance, or generic machinery merely to reduce duplication.
7. **Prefer the smallest justified representation.** Introduce only what the real instances prove is useful.
8. **Preserve required behavior, quality, and performance.** Compression is unsuccessful if it makes the program less suitable for its actual uses.

## Reuse Threshold

Do not extract reusable code until at least two real instances exist in the codebase.

The instances must:

- be concrete, current uses rather than imagined examples;
- perform the same or substantively similar semantic operation;
- provide enough variation to reveal what is truly shared;
- preserve identifiable case-specific behavior outside the shared extraction.

One instance is usable code. Two or more instances provide evidence from which reusable code can be derived. If only one instance exists, keep it concrete and record the possible repetition as an observation rather than adding an abstraction.

Existing externally imposed interfaces or repository conventions may still need to be obeyed, but they are constraints—not evidence for inventing additional reusable layers.

## Workflow

### 1. Establish the behavioral baseline

Inspect the relevant implementation, callers, tests, build configuration, and repository conventions. Identify:

- what each concrete case does;
- inputs, outputs, side effects, and state changes;
- ordering and lifetime requirements;
- edge cases and error behavior;
- required performance and quality characteristics;
- available tests or observable behavior that can detect regressions.

Run focused baseline checks when safe and practical. Do not begin by designing a hierarchy, framework, generic interface, or reusable API.

### 2. Find real repetition

Locate at least two real instances that appear compressible. Compare them directly and distinguish:

- repeated semantics from merely similar syntax;
- shared behavior from case-specific decisions;
- recurring state from incidental local variables;
- essential ordering from accidental statement order.

Do not extract code solely because two blocks look alike.

### 3. State the semantic payload

Before editing, describe the common operation in plain language. For each instance, account for:

- common inputs and outputs;
- common state;
- common sequencing;
- differences that must remain visible at the call site;
- invariants that the refactor must preserve.

If the common operation cannot be described without a collection of unrelated options, the cases may not represent one reusable semantic unit.

### 4. Introduce the smallest useful representation

Choose the least structure that expresses the proven common operation. Typical transformations include:

- replacing repeated statements with a narrowly named function;
- gathering recurring, interacting variables into a small structure that acts as shared working state;
- adding focused operations around that shared state;
- centralizing repeated setup, transition, or completion work;
- replacing synchronized manual bookkeeping with state derived from the operations actually performed.

Do not add hypothetical extension points, speculative parameters, or inheritance layers.

### 5. Replace instances incrementally

Convert one concrete instance at a time. After each conversion:

- compile or run the narrow relevant checks;
- confirm observable behavior remains unchanged;
- confirm unique behavior remains straightforward and near its use;
- compare the new call site with the semantic operation it represents.

Prefer small, reversible edits over a simultaneous rewrite of every candidate.

### 6. Evaluate the compression

A successful refactor should:

- represent genuinely repeated semantics once;
- leave unique code uncomplicated and local;
- make a future similar case require less human effort;
- improve or preserve readability, debugging, and modification;
- preserve required behavior, quality, and performance;
- avoid unnecessary indirection.

Fewer lines alone do not prove semantic compression.

### 7. Handle later uses deliberately

When another potential consumer appears:

- reuse the compressed operation unchanged if it fits;
- modify it if the change improves all real consumers;
- add a layer above or below it when consumers need different levels of control;
- keep the new case separate when sharing would distort either use.

Do not force every similar-looking operation through the same abstraction.

## Output Modes

Follow the user's requested operation:

### Refactoring review

Identify candidates without editing. For every candidate, provide:

```text
Semantic Compression Candidate
- Shared semantic operation:
- Concrete instance 1:
- Concrete instance 2:
- Behavior genuinely shared:
- Behavior that must remain local:
- Smallest proposed extraction:
- Validation:
```

Do not recommend an extraction unless at least two concrete instances can be cited.

### Refactoring proposal

Describe the smallest bottom-up transformation, affected files, incremental sequence, and validation. This is a focused refactoring proposal, not an ExecPlan.

### Refactoring implementation

When the user requests implementation, apply the transformation incrementally, preserve repository conventions, and run the relevant checks. Do not create a separate compressed brief or decompressed plan unless explicitly requested.

## Validation Checklist

Before completing a review, proposal, or implementation, verify:

- at least two concrete instances justified every new reusable extraction;
- the shared operation represents semantic repetition rather than visual similarity;
- case-specific behavior remains local and understandable;
- no speculative flags, callbacks, layers, or consumers were introduced;
- names reflect the problem-domain operation rather than a vague generic mechanism;
- relevant behavior and tests pass after implementation;
- performance-sensitive paths retain required characteristics;
- the result lowers expected lifetime development effort rather than only reducing text.

## Guardrails

- Do not model nouns into class hierarchies before examining concrete procedures.
- Do not introduce reusable code from zero or one real instance.
- Do not optimize for line count alone.
- Do not hide unique behavior behind generic machinery.
- Do not introduce options merely to force unlike cases together.
- Do not make code more reusable at the expense of immediate usability.
- Do not replace straightforward procedural code with unnecessary indirection.
- Do not assume every duplication should be removed.

## Reference

Read `references/casey-semantic-compression.md` before applying this method. Use it to resolve ambiguity in favor of concrete, bottom-up refactoring and against premature reusable architecture.
