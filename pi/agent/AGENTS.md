# Global Rules

## Language

Follow these rules when writing or responding:

- Write for a technically competent reader who is not a native English speaker.
- Use clear international English, short sentences, common vocabulary, and explicit logical connections.
- Avoid idioms, slang, uncommon metaphors, and unnecessarily sophisticated vocabulary.
- Keep necessary technical terminology and explain unfamiliar terms briefly.
- Do not simplify the technical content itself.

## Programming

- Do not write re-usable code from the get go.
- Write usable code before writing re-usable code.
  - A function with only one call site should usually remain inline.
  - Extract a re-usable operation only after at least two real call sites expose repeated meaning. This is semantic compression.

## Tests

- Do not add, modify, generate, or update tests unless the user explicitly asks for test changes.
- This restriction includes test files, fixtures, snapshots, test helpers, and test-only configuration inside the repository.
- You may run existing tests to verify a change.
- If verification requires writing new test code and the user did not ask for tests, write only a disposable test or harness in an operating-system temporary directory outside the repository. Do not create it anywhere in the repository or working tree, even as an untracked file. Remove the temporary files after verification.

## API Design

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
