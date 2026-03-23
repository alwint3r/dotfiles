---
name: learn
description: Create structured learning materials, study plans, practice prompts, and mastery checks for any topic.
---

## Purpose

Use this skill when the user wants to learn a topic in a structured way.

This skill helps an agent:
- turn a topic into a study plan
- break it into concepts and prerequisites
- generate concise learning materials
- create active-recall questions and exercises
- verify understanding through quizzes and applied tasks

This skill does **not** assume:
- continuous background execution
- scheduled reminders
- persistent spaced-repetition infrastructure
- any specific agent framework, runtime, or storage layout

## Scope

This skill:
- ✅ Creates structured learning material for any domain
- ✅ Breaks topics into manageable concepts
- ✅ Emphasizes active recall and practice
- ✅ Generates quizzes, exercises, and verification steps
- ✅ Adapts depth to the learner’s goal and background
- ❌ Does not assume the agent can run continuously
- ❌ Does not depend on recurring reminders or automated review jobs
- ❌ Does not require filesystem persistence unless the host agent supports it
- ❌ Does not access external learning platforms unless explicitly allowed

## Core Workflow

```text
Goal → Scope → Prerequisites → Concepts → Explanation → Practice → Verify → Next Steps
````

## Operating Principles

### 1. Start from the user’s goal

Identify:

* what the user wants to learn
* why they want to learn it
* what level they want to reach
* whether they want theory, practical skill, or both

### 2. Break the topic into concepts

Decompose the topic into:

* foundational prerequisites
* core concepts
* applied skills
* common pitfalls
* advanced extensions

Prefer small, clearly named units of understanding.

### 3. Generate learning material, not just explanations

For each concept, produce:

* a plain explanation
* why it matters
* how it connects to earlier concepts
* examples
* common mistakes
* one or more active-recall prompts
* one or more practice tasks

### 4. Prefer active recall over passive reading

Do not stop at explanation. Include:

* short-answer questions
* concept checks
* “explain it back” prompts
* applied exercises
* comparison questions
* error-spotting questions

### 5. Verify understanding explicitly

Before treating a concept as understood, check it with:

* recall questions
* application questions
* transfer questions
* small problem-solving tasks

A concept is stronger when the learner can:

* define it correctly
* explain it in their own words
* apply it in a new situation
* distinguish it from nearby concepts

### 6. Adapt depth to context

Choose depth based on the learner’s intent:

* **overview**: fast mental map
* **standard**: practical working understanding
* **deep**: rigorous conceptual and applied mastery

### 7. Teach dependencies in order

Do not explain advanced ideas before required prerequisites.
When a concept depends on prior knowledge, teach or summarize the dependency first.

## Recommended Output Structure

When using this skill, structure the response like this:

### A. Learning Objective

State what the learner should be able to do after studying.

### B. Prerequisites

List required background knowledge, if any.

### C. Concept Map

Break the topic into ordered subtopics.

### D. Learning Material

For each subtopic, include:

1. explanation
2. intuition
3. example
4. common mistakes
5. recall questions
6. practice task

### E. Verification

Include a quiz or mastery check.

### F. Next Steps

Suggest what to study next after this material.

## Teaching Pattern for Each Concept

Use this template internally:

```text
Concept Name
- What it is
- Why it matters
- Intuition
- Example
- Common mistakes
- Recall questions
- Practice task
- Mastery check
```

## Difficulty Modes

### Overview

Use when the user wants:

* a quick introduction
* a mental model
* a roadmap before deeper study

### Standard

Use when the user wants:

* practical understanding
* moderate rigor
* examples and exercises

### Deep

Use when the user wants:

* strong conceptual precision
* edge cases
* formal reasoning where relevant
* challenging exercises and verification

## Verification Guidelines

Use a mix of:

* direct recall
* compare/contrast
* explain-the-why
* worked example completion
* error diagnosis
* small implementation or application tasks

A good verification set usually includes:

* 3–5 recall questions
* 2–3 application questions
* 1 integrative challenge

## Example Behavior

If the user says:

* “Teach me X” → generate a lesson
* “Help me study X” → generate a structured study plan with practice
* “Quiz me on X” → generate recall and application questions
* “Make me learning material for X” → produce a complete, self-contained study document

## Constraints

* Do not pretend to track future reviews unless the host environment explicitly supports persistence and scheduling.
* Do not assume files, folders, or local storage exist.
* Do not require background execution.
* Keep the learning material self-contained whenever possible.
* Prefer clarity, sequence, and practice over volume.

## Default Behavior

Unless the user specifies otherwise:

* teach from fundamentals upward
* use standard depth
* include examples
* include active-recall questions
* include a short quiz at the end
* include suggested next topics

