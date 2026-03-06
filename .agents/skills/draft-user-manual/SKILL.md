---
name: draft-user-manual
description: Draft or revise product user manuals, operator guides, installation guides, and deployment manuals from repository context or user notes. Use when Codex needs to create a new manual, expand a stub, or rewrite an existing manual in any language; default to English when the target language is not specified.
---

# Draft User Manual

Draft clear, factual manuals for operators or end users. Base the document on repository facts, user instructions, and any existing manual content; do not invent behavior that is not supported by the available source material.

## Default behavior

- Infer the target language from the user request. If the user does not specify a language, write in English.
- Preserve product names, executable names, config keys, API paths, file paths, environment variables, and code identifiers exactly unless the user explicitly asks to localize them.
- Write for the stated audience. If no audience is given, assume operators or administrators for deployment-style manuals and end users for product-usage manuals.

## Workflow

1. Read the existing manual or source materials first.
   - Prefer repository documentation, config files, scripts, CLI help text, migrations, and deployment assets over assumptions.
   - If facts are missing, call out the gap instead of filling it with guesses.
2. Determine scope.
   - Identify whether the user wants a full manual, a section rewrite, a translation, or a bare-minimum first draft.
   - Keep the outline proportional to the requested scope.
3. Build a practical outline.
   - Typical sections: purpose, scope, prerequisites, installation or deployment, configuration, operation, maintenance, troubleshooting, and rollback or recovery.
   - Omit sections that are unsupported by the source material.
4. Draft in the requested language.
   - Use short declarative sentences.
   - Keep steps ordered and explicit.
   - Use tables only when they materially improve scanning.
5. Verify every claim against the source.
   - Keep unknowns visibly marked.
   - Avoid describing unimplemented features, unsupported commands, or speculative operational behavior.

## Style rules

- Prefer direct instructional language.
- Explain why a step matters only when it prevents mistakes or reduces operator confusion.
- Keep examples concrete: real filenames, service names, ports, commands, and directories when available.
- For translated manuals, keep technical terminology stable and natural in the target language instead of translating identifiers mechanically.
- When updating an existing manual, preserve confirmed structure where possible and improve clarity with minimal churn.

## Output shape

- Start with a title that matches the actual deliverable.
- Add a short introduction that states the manual's audience and scope.
- Use numbered steps for procedures and flat bullets for inventories or checks.
- Separate prerequisites from execution steps.
- End with operational checks, troubleshooting notes, or known limitations when the source supports them.

## References

- Read `references/example-en.md` when a concrete English example helps with structure, tone, or section ordering.
- If the current repository already contains a user manual draft, treat that file as the primary style and fact source for revisions.
