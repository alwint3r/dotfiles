# Casey Muratori Semantic Compression Reference

Source: [Semantic Compression](https://caseymuratori.com/blog_0015), published 2014-05-28.

This reference summarizes the article's code-refactoring method. It is not a general framework for compressing prose, requirements, prompts, or implementation plans.

## Central Objective

Optimize development efficiency over the full useful lifetime of the code. Relevant costs include the effort to:

- type and initially understand the code;
- get it working;
- debug it;
- modify and extend it;
- adapt it to other real uses;
- change surrounding code to accommodate it;
- maintain required performance and quality.

The target is semantic compactness: repeated or substantively similar operations are expressed once, while unique behavior remains direct. Physical text often becomes shorter, but line count is not the objective.

## Bottom-Up Method

1. Write the concrete operation needed for a specific case.
2. Get that concrete case working without designing for hypothetical reuse.
3. Wait until the same semantic operation appears in at least one additional real case.
4. Compare the real instances to determine what is actually shared.
5. Extract the shared operation or state representation from those details.
6. Replace the concrete instances incrementally.
7. Continue compressing only as further real repetition appears.

The article's concise rule is: "make your code usable before you try to make it reusable".

## Why Two Instances Matter

At least two real examples are required before extracting reusable code because they provide evidence about:

- which behavior is actually common;
- which differences need to remain at the call sites;
- what inputs and state the shared operation truly needs;
- whether reuse is necessary at all;
- whether the proposed interface is convenient for more than one case.

With zero or one example, reusable design is speculation. Do not invent a second consumer to satisfy the rule.

## Semantic Versus Textual Similarity

Compression applies to meaning, not merely repeated tokens.

Two blocks are candidates when they perform the same or substantively similar operation. Conversely, visually similar blocks may need to remain separate when their behavior, lifetime, failure handling, or reasons for change differ.

A successful extraction removes duplicated semantics without obscuring unique behavior.

## Architecture Emerges From Details

The article rejects architecture-first methods that begin with noun modeling, class hierarchies, diagrams, or generic frameworks before concrete procedures are known.

Reusable structures should arise from working code:

- procedures reveal repeated operations;
- repeated operations reveal useful names;
- interacting repeated variables may reveal a useful data structure;
- operations around that data may eventually form an object-like bundle;
- larger architecture emerges through repeated compression.

The resulting structure is shaped by actual use rather than predicted use.

## Shared Working State

The article demonstrates gathering variables that repeatedly interact across multiple UI operations into a small structure. This structure serves as shared working state—a "shared stack frame"—that allows repeated operations to become focused functions.

This is a technique, not a mandatory pattern. Use it only when multiple real cases share interacting state. Do not create an object merely because nouns are present in the problem description.

## Incremental Transformations

The example proceeds through small transformations rather than a wholesale redesign:

- gather recurring layout state;
- extract repeated row movement;
- extract repeated title handling;
- derive final height from actual operations instead of synchronized pre-counting;
- extract repeated button drawing;
- leave each button's unique action at the call site.

Intermediate states do not need to be immediately prettier. A small structural step may enable later compression, but every step should remain understandable and testable.

## Later Consumers and Multiple Resolutions

When a new consumer appears, do not automatically distort an existing reusable operation to fit it. Decide whether to:

- reuse the existing operation as-is;
- modify it because all real consumers benefit;
- introduce a layer above or below it to expose a different level of control;
- keep the new case separate.

This preserves both convenient high-level operations and lower-level control when real uses require them.

## Signs of Good Compression

Well-compressed code tends to:

- approach the minimum information needed to express each unique case;
- use consistent names for frequent domain operations;
- route identical behavior through the same path;
- keep unique behavior near its use;
- make similar extensions straightforward;
- reduce debugging and modification effort;
- preserve required runtime performance and quality.

## Failure Modes

- Designing reusable code before a second real use exists.
- Confusing fewer lines with fewer semantics.
- Extracting code based only on syntactic resemblance.
- Building class hierarchies from nouns before understanding procedures.
- Adding generic options for hypothetical consumers.
- Hiding unique behavior behind indirection.
- Forcing a new use through an abstraction that does not naturally fit.
- Replacing simple working code with a framework that increases lifetime effort.

## Faithfulness Checks

Before calling a refactor semantic compression, ask:

1. Which two or more real instances justified the extraction?
2. What semantic operation do they genuinely share?
3. What behavior remains unique and local?
4. Did the reusable representation emerge from working details?
5. Does the result reduce lifetime human effort rather than only text?
6. Were behavior, quality, and performance preserved?
7. Did the refactor avoid speculative architecture?
