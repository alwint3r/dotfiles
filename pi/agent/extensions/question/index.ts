import { keyHint, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
	Editor,
	Key,
	matchesKey,
	SelectList,
	Text,
	truncateToWidth,
	wrapTextWithAnsi,
} from "@earendil-works/pi-tui";
import { Type, type Static } from "typebox";

const QuestionParams = Type.Object({
	question: Type.String({ minLength: 1, description: "One question to ask the user" }),
	header: Type.Optional(Type.String({ description: "Short topic label, such as Scope or Storage" })),
	recommendation: Type.Optional(
		Type.String({ description: "Your recommended answer and a short reason; required when grilling" }),
	),
	options: Type.Optional(
		Type.Array(
			Type.Object({
				label: Type.String({
					minLength: 1,
					description: "Answer label; mark the recommended choice with (Recommended)",
				}),
				description: Type.Optional(Type.String({ description: "Explain this choice and its trade-offs" })),
			}),
			{ description: "Suggested answers. The user can always write a custom answer. Omit for an open-ended question." },
		),
	),
});

const AnswerSchema = Type.Object({
	question: Type.String(),
	answer: Type.Union([Type.String(), Type.Null()]),
	wasCustom: Type.Boolean(),
	cancelled: Type.Boolean(),
});

type Answer = { answer: string; wasCustom: boolean };

export default function questionExtension(pi: ExtensionAPI) {
	pi.registerTool<typeof QuestionParams, Static<typeof AnswerSchema>>({
		name: "question",
		label: "Question",
		description:
			"Ask the user one question and wait for their answer in an interactive picker. Offer choices with descriptions, include your recommendation, or ask an open-ended question. A custom answer is always available. Never infer an answer from cancellation. Requires terminal or RPC UI; if unavailable, ask in normal chat instead.",
		promptSnippet: "Ask the user one interactive question with suggested or custom answers",
		promptGuidelines: [
			"When the grilling skill is active, use question instead of asking interview questions in normal chat. Ask exactly one question per call and wait for its answer before deciding what to ask next.",
		],
		parameters: QuestionParams,
		outputSchema: AnswerSchema,
		exposure: "model-only",
		executionMode: "sequential",
		annotations: { readOnlyHint: true, destructiveHint: false, openWorldHint: false },

		async execute(_toolCallId, params, signal, _onUpdate, ctx) {
			signal?.throwIfAborted();
			if (!ctx.hasUI || (ctx.mode !== "tui" && ctx.mode !== "rpc")) {
				throw new Error(
					"The question tool needs terminal or RPC UI. Ask this question in normal chat and wait for the user's reply instead.",
				);
			}

			const question = params.question.trim();
			const options = (params.options ?? []).map((option) => ({
				label: option.label.trim(),
				description: option.description?.trim(),
			}));
			if (!question || options.some((option) => !option.label)) {
				throw new Error("The question and option labels must not be blank.");
			}
			if (new Set(options.map((option) => option.label)).size !== options.length) {
				throw new Error("Each option must have a distinct label.");
			}

			let answer: Answer | null = null;
			if (ctx.mode === "rpc") {
				const title = [
					params.header,
					question,
					params.recommendation && `Recommendation: ${params.recommendation}`,
				].filter(Boolean).join("\n\n");
				const choices = options.map(
					(option, index) =>
						`${index + 1}. ${option.label}${option.description ? ` — ${option.description}` : ""}`,
				);
				const customChoice = "Type your own answer…";
				const selected = options.length
					? await ctx.ui.select(title, [...choices, customChoice], { signal })
					: customChoice;
				signal?.throwIfAborted();
				if (selected === customChoice) {
					// RPC input supports cancellation signals; the multi-line editor does not.
					while (true) {
						const value = await ctx.ui.input(title, "Your answer", { signal });
						signal?.throwIfAborted();
						if (value === undefined) break;
						if (value.trim()) {
							answer = { answer: value.trim(), wasCustom: true };
							break;
						}
					}
				} else if (selected !== undefined) {
					const index = choices.indexOf(selected);
					if (index < 0) throw new Error("The RPC client returned an unknown answer choice.");
					answer = { answer: options[index].label, wasCustom: false };
				}
			} else {
				answer = await ctx.ui.custom<Answer | null>((tui, theme, keybindings, done) => {
					let editing = options.length === 0;
					let focused = false;
					let finished = false;
					let validationMessage = "";
					const listTheme = {
						selectedPrefix: (text: string) => theme.fg("accent", text),
						selectedText: (text: string) => theme.fg("accent", text),
						description: (text: string) => theme.fg("muted", text),
						scrollInfo: (text: string) => theme.fg("dim", text),
						noMatch: (text: string) => theme.fg("warning", text),
					};
					const editor = new Editor(tui, {
						borderColor: (text) => theme.fg("accent", text),
						selectList: listTheme,
					});
					const list = new SelectList(
						[
							...options.map((option, index) => ({
								value: String(index),
								label: `${index + 1}. ${option.label}`,
							})),
							{ value: "custom", label: `${options.length + 1}. Type your own answer…` },
						],
						6,
						listTheme,
						{ minPrimaryColumnWidth: 1, maxPrimaryColumnWidth: 80 },
					);

					function refresh() {
						editor.focused = focused && editing;
						tui.requestRender();
					}

					function finish(value: Answer | null) {
						if (finished) return;
						finished = true;
						signal?.removeEventListener("abort", onAbort);
						done(value);
					}

					function onAbort() {
						finish(null);
					}

					list.onSelect = (item) => {
						if (item.value === "custom") {
							editing = true;
							refresh();
						} else {
							finish({ answer: options[Number(item.value)].label, wasCustom: false });
						}
					};
					list.onCancel = () => finish(null);
					editor.onSubmit = (value) => {
						if (!value.trim()) {
							validationMessage = "Write an answer before submitting, or cancel.";
							refresh();
							return;
						}
						finish({ answer: value.trim(), wasCustom: true });
					};
					signal?.addEventListener("abort", onAbort, { once: true });
					// Pi installs the component after the factory returns.
					if (signal?.aborted) queueMicrotask(onAbort);

					return {
						get focused() {
							return focused;
						},
						set focused(value: boolean) {
							focused = value;
							editor.focused = value && editing;
						},
						handleInput(data: string) {
							if (finished) return;
							if (matchesKey(data, Key.ctrl("c"))) {
								finish(null);
							} else if (editing && keybindings.matches(data, "tui.select.cancel")) {
								if (!options.length) finish(null);
								else {
									editing = false;
									validationMessage = "";
									refresh();
								}
							} else if (editing) {
								validationMessage = "";
								editor.handleInput(data);
								refresh();
							} else {
								list.handleInput(data);
								refresh();
							}
						},
						render(width: number) {
							const renderWidth = Math.max(1, width);
							const lines = [theme.fg("accent", "─".repeat(renderWidth))];
							function addWrapped(text: string) {
								lines.push(...wrapTextWithAnsi(text, renderWidth));
							}

							if (params.header) addWrapped(theme.fg("accent", theme.bold(params.header)));
							addWrapped(theme.fg("text", question));
							if (params.recommendation) {
								lines.push("");
								addWrapped(theme.fg("muted", `Recommendation: ${params.recommendation}`));
							}
							lines.push("");
							if (editing) {
								lines.push(...editor.render(renderWidth));
								if (validationMessage) addWrapped(theme.fg("warning", validationMessage));
							} else {
								lines.push(...list.render(renderWidth));
								const selected = list.getSelectedItem();
								const option = selected && selected.value !== "custom"
									? options[Number(selected.value)]
									: undefined;
								if (option) {
									// Keep the full selected label and description visible on narrow terminals.
									lines.push("");
									addWrapped(theme.fg("text", option.label));
									if (option.description) addWrapped(theme.fg("muted", option.description));
								}
							}
							const hints = editing
								? [
									keyHint("tui.input.submit", "submit"),
									keyHint("tui.input.newLine", "new line"),
									keyHint("tui.select.cancel", options.length ? "back" : "cancel"),
								]
								: [
									keyHint("tui.select.up", "up"),
									keyHint("tui.select.down", "down"),
									keyHint("tui.select.confirm", "choose"),
									keyHint("tui.select.cancel", "cancel"),
								];
							lines.push("");
							addWrapped(hints.join(" • "));
							lines.push(theme.fg("accent", "─".repeat(renderWidth)));
							return lines.map((line) => truncateToWidth(line, renderWidth, ""));
						},
						invalidate() {
							editor.invalidate();
							list.invalidate();
						},
						dispose() {
							finished = true;
							signal?.removeEventListener("abort", onAbort);
						},
					};
				});
			}

			signal?.throwIfAborted();
			const details = {
				question,
				answer: answer?.answer ?? null,
				wasCustom: answer?.wasCustom ?? false,
				cancelled: answer === null,
			};
			return {
				content: [{
					type: "text",
					text: answer
						? `Question: ${question}\nUser ${answer.wasCustom ? "wrote" : "selected"}: ${answer.answer}`
						: `The user dismissed this question: ${question}\nNo answer or approval was given. Stop the interview and wait for the user; do not immediately ask again.`,
				}],
				details,
				structuredContent: details,
				terminate: details.cancelled,
			};
		},

		renderCall(args, theme) {
			const lines = [theme.fg("toolTitle", theme.bold("question ")) + (args.question ?? "")];
			if (args.recommendation) lines.push(theme.fg("muted", `Recommendation: ${args.recommendation}`));
			if (Array.isArray(args.options)) {
				for (const [index, option] of args.options.entries()) {
					lines.push(theme.fg("dim", `${index + 1}. ${option?.label ?? ""}`));
				}
			}
			return new Text(lines.join("\n"), 0, 0);
		},

		renderResult(result, { isPartial }, theme) {
			if (isPartial) return new Text(theme.fg("dim", "Waiting for your answer…"), 0, 0);
			if (!result.details) {
				const text = result.content.filter((item) => item.type === "text")
					.map((item) => item.text).join("\n");
				return new Text(text, 0, 0);
			}
			if (result.details.cancelled) {
				return new Text(theme.fg("warning", "Question cancelled; no answer given"), 0, 0);
			}
			return new Text(
				theme.fg("success", "✓ ")
					+ (result.details.wasCustom ? theme.fg("muted", "(custom) ") : "")
					+ result.details.answer,
				0,
				0,
			);
		},
	});
}
