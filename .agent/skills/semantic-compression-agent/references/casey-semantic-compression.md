# Casey Muratori Semantic Compression Notes

Source article: https://caseymuratori.com/blog_0015

## Core Thesis

Apply semantic compression by preserving meaning while changing representation.
Focus on the semantic payload first, then optimize the representation.
Keep the focus on software development decisions and code structure.

## Practical Principles

1. Build from concrete usage upward.
2. Keep code usable before attempting broad reuse.
3. Defer abstractions until at least two real instances exist.
4. Prefer bottom-up extraction over top-down framework design.
5. Compress for clarity, not for brevity alone.

## Agent Translation Rules

1. Apply only to coding tasks and code-change requests.
2. Extract and retain behavior, constraints, and invariants before shortening.
3. Compress requests into compact code briefs with concrete context.
4. Decompress into file/module edits and explicit tests.
5. Validate round-trip fidelity against original technical constraints.

## Source Anchors (for Faithfulness Checks)

- "make your code usable before you try to make it reusable"
- Require at least two real instances before extracting shared abstraction.
- Treat software semantic compression as bottom-up from concrete code.

Use these anchors to resolve ambiguity in favor of concrete implementation over premature abstraction.
