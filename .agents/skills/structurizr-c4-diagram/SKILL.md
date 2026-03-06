---
name: structurizr-c4-diagram
description: Create accurate C4 architecture diagrams in Structurizr DSL from an existing codebase, repository, or architecture notes. Use when an agent needs to inspect source code and produce or revise a software system context diagram, container diagram, component diagram, deployment diagram, or a Structurizr DSL workspace; default to system context plus container views when the user asks for a C4 diagram without specifying depth.
---

# Structurizr C4 Diagram

## Overview

Generate Structurizr DSL that matches the repository as it exists. Prefer evidence from code, manifests, configuration, and deployment artifacts over guesses, and state assumptions whenever the codebase does not prove a relationship or boundary.

By default, produce views up to the container level:

- one `systemContext` view for the system in scope
- one `container` view for that same system

Only add component, dynamic, or deployment views when the user explicitly asks for them or when the repository contains enough clear evidence that the deeper model is stable and useful.

## Workflow

1. Determine the modeling scope.

- Identify the software system in scope from the user request, repository name, README, entrypoints, service names, or deployment manifests.
- If the user did not specify depth, stop at container level.
- If the user asked for a specific level, honor that and keep the rest minimal.

2. Gather evidence from the codebase before writing DSL.

- Read the primary manifests and entrypoints first: `go.mod`, `package.json`, `pyproject.toml`, `Dockerfile`, `docker-compose*.yml`, Kubernetes manifests, Terraform, CI workflows, and top-level READMEs.
- Find inbound interfaces such as HTTP servers, gRPC services, CLIs, schedulers, workers, queues, and web frontends.
- Find outbound dependencies such as databases, caches, object stores, message brokers, third-party APIs, identity providers, and internal services.
- Use repository evidence to infer runtime boundaries. A container is a separately running or separately deployable unit, not a source folder.

3. Map repository facts to C4 elements.

- Use `person` for human roles that directly interact with the system.
- Use `softwareSystem` for the system in scope and important external systems.
- Use `container` for runnable applications, databases, frontends, batch jobs, worker services, queues, and similar runtime units inside the software system.
- Use `component` only for clear internal building blocks inside a single container. Do not invent components from arbitrary packages or directories.
- Use relationships only when the direction and purpose are supported by code or configuration.

4. Write the Structurizr DSL workspace.

- Prefer `!identifiers hierarchical` so nested identifiers stay readable and collision-free.
- Define `model` first, then `views`, then `configuration`.
- Give every view an explicit key so the workspace is stable across edits.
- Use concise descriptions and technologies. Good relationship descriptions are verb phrases such as `"Reads scan results from"` or `"Calls"` plus a technology such as `"HTTPS/JSON"` when known.
- When the workspace focuses on one software system, set `configuration { scope softwaresystem }` for stricter validation.
- Use `autoLayout lr` or `autoLayout tb`; default to left-to-right unless the shape of the system strongly suggests top-to-bottom.

5. Check the model for accuracy before finalizing.

- Every container should be a runtime concept the repository actually contains.
- Every external system should matter to understanding the system behavior.
- Every relationship should have a clear source, destination, and purpose.
- If a boundary is inferred rather than explicit, mention it in a short assumptions note.

## Modeling Heuristics

Use these rules when the repository is ambiguous:

- Model one primary software system unless the repository clearly contains multiple independently meaningful systems.
- Keep people outside the system boundary. Keep containers inside the system boundary.
- Prefer fewer, defensible containers over a speculative, over-detailed diagram.
- Datastores, queues, and caches are usually containers when they are part of the system being modeled, and external software systems when they are managed external platforms that the system merely uses.
- A library, package, or internal module is not a container.
- A separate process, executable, service, or independently operated datastore usually is a container.
- If a monorepo contains several deployables, group them under one `softwareSystem` only when they jointly form the user-requested system in scope.

## Output Contract

Unless the user asks for something else, produce:

1. one `.dsl` workspace file
2. one short assumptions section in the response if any relationships or boundaries required inference

Default view set:

- `systemContext`
- `container`

Optional additional views only when requested or justified by the repository:

- `component`
- `deployment`
- `dynamic`

## Structurizr DSL Rules

Follow the official DSL patterns summarized in [`references/structurizr-dsl-quick-reference.md`](./references/structurizr-dsl-quick-reference.md). Load that reference when you need exact syntax or official links.

Start from [`assets/workspace-template.dsl`](./assets/workspace-template.dsl) when creating a new workspace from scratch. Replace the placeholders with repository-specific facts instead of keeping the sample names.

Preferred conventions:

- Use explicit identifiers such as `user`, `payments`, `payments.api`, `payments.db`.
- Use explicit view keys such as `"system-context"` and `"containers"`.
- Keep styles simple unless the user asks for custom branding.
- Do not add deployment environments, health checks, perspectives, or documentation sections unless the user asked for them or the repository provides strong evidence.

## Validation

If the Structurizr CLI is available, validate the workspace before finishing:

```bash
structurizr validate -workspace workspace.dsl
```

If validation tooling is unavailable, do a manual pass:

- check that every referenced identifier exists
- check that each view includes the intended elements
- check that relationship directions match the repository evidence
- check that the default output did not go deeper than container level unless requested
