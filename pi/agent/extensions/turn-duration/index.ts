import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

const ENTRY_TYPE = "turn-duration";

type TurnDurationEntry = {
	durationMs: number;
	finishedAt: string;
};

export function formatDuration(durationMs: number): string {
	const totalSeconds = Math.max(0, Math.round(durationMs / 1_000));
	const hours = Math.floor(totalSeconds / 3_600);
	const minutes = Math.floor((totalSeconds % 3_600) / 60);
	const seconds = totalSeconds % 60;

	return `${hours}h ${minutes.toString().padStart(2, "0")}m ${seconds
		.toString()
		.padStart(2, "0")}s`;
}

export default function turnDurationExtension(pi: ExtensionAPI) {
	let startedAt: number | undefined;

	pi.registerEntryRenderer<TurnDurationEntry>(ENTRY_TYPE, (entry, _options, theme) => {
		if (typeof entry.data?.durationMs !== "number") return undefined;

		const duration = formatDuration(entry.data.durationMs);
		return new Text(theme.fg("dim", `Turn completed in ${duration}`), 1, 0);
	});

	pi.on("before_agent_start", () => {
		// Keep the first timestamp when steering or follow-up messages extend the
		// same run. agent_settled fires only after all automatic work is finished.
		startedAt ??= performance.now();
	});

	pi.on("agent_settled", () => {
		if (startedAt === undefined) return;

		const durationMs = performance.now() - startedAt;
		startedAt = undefined;
		pi.appendEntry(ENTRY_TYPE, {
			durationMs,
			finishedAt: new Date().toISOString(),
		});
	});
}
