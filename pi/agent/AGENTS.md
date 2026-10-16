# Global Rules

## Language

Follow these rules when writing or responding:

- Write for a technically competent reader who is not a native English speaker.
- Use clear international English, short sentences, common vocabulary, and explicit logical connections.
- Avoid idioms, slang, uncommon metaphors, and unnecessarily sophisticated vocabulary.
- Keep necessary technical terminology and explain unfamiliar terms briefly.
- Do not simplify the technical content itself.

## Programming

Write code that a maintainer can understand by following its execution and
data flow. Optimize for understanding, not minimum line count, maximum
reuse, or compliance with a design doctrine.

### Make the concrete implementation readable

- Use names that describe domain meaning and purpose. Include units or
  lifecycle distinctions when they matter. Avoid vague names and
  unnecessary abbreviations.
- Prefer straightforward control flow and explicit intermediate values
  over dense expressions, nested conditionals, or clever chaining.
  Extra lines are useful when they expose meaning.
- Keep related logic together and arrange it in execution order where
  practical. Use whitespace and short comments to separate meaningful
  stages.
- Make state changes, side effects, error paths, and resource lifetimes
  easy to identify. Do not hide important behavior behind innocent-looking
  expressions or helpers.
- Comment on intent, constraints, invariants, and non-obvious reasoning.
  Do not merely translate the code into prose.

### Separate readability from reusability

- Write usable, concrete code before designing reusable code.
- Keep an operation inline when that makes the surrounding code easier
  to understand. A long, coherent function can be clearer than many small
  functions that require constant navigation.
- A private helper with one call site is appropriate when it isolates a
  coherent operation and meaningfully simplifies understanding the caller.
  Do not extract helpers merely to shorten functions or wrap obvious code.
- Extract reusable operations only after at least two real call sites
  expose repeated meaning. Similar syntax alone is not enough. This is
  semantic compression.
- Do not introduce interfaces, classes, configuration mechanisms, or
  architectural layers for hypothetical future needs.
- Do not apply DRY, SOLID, “one responsibility,” or function-size rules
  mechanically. Judge a change by whether it makes the actual program
  easier to understand and modify.

### Review for readability before finishing

- Trace the main path and an important failure path. Can a reader see
  what happens, which data changes, and where errors go without jumping
  through unrelated files?
- Simplify confusing names, dense expressions, excessive nesting, and
  unnecessary indirection. Do not turn this review into unrelated cleanup.

## Database Schema Changes

- Do not create, generate, modify, delete, or run schema migrations unless the user explicitly requests or approves that migration work.
- This rule applies to every database and storage technology, on every platform, including SQL, NoSQL, embedded databases, and browser-local databases. It covers migration files, generated migration metadata, schema-version upgrades, and migration logic embedded in application startup or other code.
- A request to add a feature, change a model, or fix a database issue is not consent to create a migration. Existing migration tooling or repository conventions do not imply consent either. If a migration appears necessary, explain why and ask for approval before proceeding.
- For an unreleased application with no existing data or installations to preserve, prefer updating the current schema definition or fresh-install setup directly instead of adding migration history for speculative future upgrades. Confirm these conditions before choosing this approach; zero users alone does not prove that data is disposable.
- If deployment status or data-preservation requirements are unknown, ask the user rather than assuming that a migration is required or that a database reset is safe. Do not rewrite existing migration history as a substitute for an approved migration.
- Approval to write or generate a migration is not approval to execute it. Do not reset, recreate, or destructively alter an existing database without explicit approval for that operation.

## Tests

- Do not add, modify, generate, or update tests unless the user explicitly asks for test changes.
- This restriction includes test files, fixtures, snapshots, test helpers, and test-only configuration inside the repository.
- You may run existing tests to verify a change.
- If verification requires writing new test code and the user did not ask for tests, write only a disposable test or harness in an operating-system temporary directory outside the repository. Do not create it anywhere in the repository or working tree, even as an untracked file. Remove the temporary files after verification.

## API Design

Apply these guidelines when an API boundary is needed. They are not a requirement to introduce reusable components or architectural layers into ordinary application code.

Design APIs to minimize **integration discontinuity**: the point where a convenient API stops composing with the caller's real program and forces workarounds, a rewrite, or adoption of an unrelated control model.

### Start from real use

- Write the concrete usage before designing the abstraction.
- Test the proposed API against three call sites: the simplest case, a realistic production case, and an awkward edge case.
- Extract abstractions from repeated semantics, not from speculative taxonomies or repeated syntax alone.
- Add convenience wrappers last. They must be optional and implementable from the same public primitives available to callers.

### Preserve caller control

- Prefer caller-driven APIs. Let the caller own the main loop, threads, scheduling, timing, retry policy, and cancellation policy.
- Provide explicit `poll`, `step`, `process`, or bounded-operation APIs when they make integration and deterministic testing easier.
- Do not make callbacks, background threads, mandatory inheritance, or a framework-owned event loop the only integration model.
- Separate mechanism from policy unless the policy is intrinsic to the domain.
- State whether each operation blocks, how long it may block, and how the caller can set a timeout or cancel it.

### Make ownership and dependencies explicit

- For every context, buffer, configuration, event, and handle, define its owner, lifetime, allocation strategy, and permitted mutators.
- Prefer caller-owned buffers and explicit allocator parameters. Do not hide allocation where memory policy matters.
- Prefer explicit context objects over hidden global state. This should support multiple instances and isolated tests.
- Do not retain a copy of application state unless retention is essential for protocol state, hardware state, caching, or performance. Keep one clear source of truth and make invalidation explicit.
- Make required initialization order and dependencies visible in types, parameters, handles, or documentation. Avoid lifecycle magic.
- Make failures and partial success explicit and actionable. Do not depend on undocumented sentinel values or side channels.

### Provide useful granularity

Structure reusable APIs in layers when the domain needs them:

1. **Primitives:** small, orthogonal operations with explicit state and effects.
2. **Semantic operations:** domain concepts built from those primitives.
3. **Convenience helpers:** common high-level compositions.

A caller that outgrows a helper must be able to use lower-level pieces without abandoning the API. Expose intermediate data when callers may need custom validation, transport, storage, scheduling, or error handling.

### Evaluate the design

Review APIs along these axes:

- **Granularity:** Can callers use one stage, inspect intermediate results, and replace a stage?
- **Redundancy:** Do helpers compress real concepts, or create a combinatorial set of special cases?
- **Coupling:** Are dependencies, initialization order, object models, and runtime assumptions minimal and explicit?
- **Retention:** Does the API store only state that it must own?
- **Flow control:** Can the caller drive execution and integrate it into an existing runtime?
- **Memory:** Are allocation, capacity, and ownership policies explicit?
- **Failure:** Are errors, partial results, timeout behavior, and recovery paths observable?
- **Testability:** Can behavior be exercised deterministically with supplied dependencies and without real time, global state, or races?

Be suspicious of boolean argument lists, hidden allocators, callback-only designs, global initialization, undocumented call order, retained mirror state, mandatory background threads, and special-case function growth. Use named option structures and small composable operations when they make contracts clearer.

These are defaults for reusable components, not absolute bans. A framework may intentionally own flow control, and a library may need retained state. When choosing such a design, make that scope explicit and document the integration cost.
