import { createHash, randomUUID } from "node:crypto";
import { access, chmod, mkdir, readFile, rename, rm } from "node:fs/promises";
import { homedir, tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import {
	CustomEditor,
	type ExtensionAPI,
	type ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const EXTENSION_DIR = dirname(fileURLToPath(import.meta.url));
const HELPER_SOURCE = join(EXTENSION_DIR, "pasteboard-to-png.swift");
const HELPER_CACHE_DIR = join(homedir(), "Library", "Caches", "pi-heif-paste");
const COMPILE_TIMEOUT_MS = 60_000;
const PASTE_TIMEOUT_MS = 15_000;

let helperPromise: Promise<string> | undefined;
let pasteInProgress = false;

async function fileExists(path: string): Promise<boolean> {
	try {
		await access(path);
		return true;
	} catch {
		return false;
	}
}

async function buildHelper(pi: ExtensionAPI): Promise<string> {
	const source = await readFile(HELPER_SOURCE);
	const digest = createHash("sha256").update(source).digest("hex").slice(0, 16);
	const binary = join(HELPER_CACHE_DIR, `pasteboard-to-png-${digest}`);

	if (await fileExists(binary)) return binary;

	await mkdir(HELPER_CACHE_DIR, { recursive: true });
	const temporaryBinary = `${binary}.${process.pid}.${randomUUID()}.tmp`;

	try {
		const result = await pi.exec(
			"/usr/bin/swiftc",
			["-O", HELPER_SOURCE, "-o", temporaryBinary],
			{ timeout: COMPILE_TIMEOUT_MS },
		);

		if (result.code !== 0) {
			throw new Error(
				result.stderr.trim() || "swiftc could not build the clipboard helper",
			);
		}

		await chmod(temporaryBinary, 0o755);
		await rename(temporaryBinary, binary);
		return binary;
	} finally {
		await rm(temporaryBinary, { force: true });
	}
}

function getHelper(pi: ExtensionAPI): Promise<string> {
	helperPromise ??= buildHelper(pi).catch((error) => {
		helperPromise = undefined;
		throw error;
	});
	return helperPromise;
}

async function pasteClipboard(pi: ExtensionAPI, ctx: ExtensionContext): Promise<void> {
	if (pasteInProgress) return;
	pasteInProgress = true;

	try {
		const helper = await getHelper(pi);
		const outputPath = join(tmpdir(), `pi-clipboard-${randomUUID()}.png`);
		const result = await pi.exec(helper, [outputPath], { timeout: PASTE_TIMEOUT_MS });

		if (result.code === 0 && (await fileExists(outputPath))) {
			ctx.ui.pasteToEditor(outputPath);
			ctx.ui.notify("Pasted clipboard image as PNG", "info");
			return;
		}

		// Exit code 2 means that the pasteboard has no image. Preserve Pi's
		// normal Ctrl+V text fallback when this extension owns the paste action.
		if (result.code === 2) {
			const text = await pi.exec("/usr/bin/pbpaste", [], { timeout: 5_000 });
			if (text.code === 0 && text.stdout.length > 0) {
				ctx.ui.pasteToEditor(text.stdout);
			}
			return;
		}

		ctx.ui.notify(
			result.stderr.trim() || "Could not convert the clipboard image to PNG",
			"error",
		);
	} catch (error) {
		const message = error instanceof Error ? error.message : String(error);
		ctx.ui.notify(`HEIF paste failed: ${message}`, "error");
	} finally {
		pasteInProgress = false;
	}
}

export default function heifPasteExtension(pi: ExtensionAPI) {
	if (process.platform !== "darwin") return;

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		const previousEditor = ctx.ui.getEditorComponent();
		ctx.ui.setEditorComponent((tui, theme, keybindings) => {
			const editor =
				previousEditor?.(tui, theme, keybindings) ??
				new CustomEditor(tui, theme, keybindings);

			if (editor instanceof CustomEditor) {
				editor.onPasteImage = () => {
					void pasteClipboard(pi, ctx);
				};
			}

			return editor;
		});
	});
}
