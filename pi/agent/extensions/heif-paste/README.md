# HEIF Paste

A macOS Pi extension that replaces Pi's clipboard-image handler while keeping the configured `app.clipboard.pasteImage` keybinding (Ctrl+V by default).

When the clipboard contains an image—including HEIF/HEIC data or a copied HEIF/HEIC file—the extension:

1. reads it through macOS AppKit;
2. converts it to a temporary PNG;
3. inserts the PNG path at the cursor in Pi's user input.

Text clipboard content still pastes normally.

## Requirements

- macOS 11 or newer
- Apple Command Line Tools (`/usr/bin/swiftc`)

The native helper is compiled on the first image or text paste and cached under `~/Library/Caches/pi-heif-paste/`.

## Install

From this dotfiles repository, run either installer:

```bash
./install.sh
# or
python3 install.py
```

The installer links `heif-paste/` into `~/.pi/agent/extensions/`. Run `/reload` in Pi after installing or changing the extension.
