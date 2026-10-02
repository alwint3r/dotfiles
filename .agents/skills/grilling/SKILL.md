---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview me relentlessly about every aspect of this until we reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing. Asking multiple questions at once is bewildering.

When Pi's `question` tool is available, use it for every interview question instead of asking in normal chat:

- Ask exactly one question per tool call. Do not send several question calls together or prepare later questions before receiving the answer.
- Include your recommended answer and a short reason in `recommendation`.
- When there are concrete alternatives, provide concise `options` with descriptions of their trade-offs. Mark your recommended option's label with `(Recommended)`. The tool always lets the user write a custom answer.
- For an open-ended question, omit `options`; still include `recommendation`.
- Wait for the tool result, then use the user's answer to choose the next question. A recommendation is not the user's decision.
- If the user cancels, stop the interview and wait for them. Do not treat cancellation as an answer or approval, and do not immediately reopen the question.

If the tool is unavailable or reports that there is no interactive UI, ask one question in normal chat, include your recommendation, and wait for a reply.

If a *fact* can be found by exploring the environment (filesystem, tools, etc.), look it up rather than asking me. The *decisions*, though, are mine — put each one to me and wait for my answer.

Do not act on it until I confirm we have reached a shared understanding.
