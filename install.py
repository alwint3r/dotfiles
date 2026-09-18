#!/usr/bin/env python3
import os
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
STATUS = 0


def config_target_dir() -> Path:
    if sys.platform == "win32":
        local_appdata = os.environ.get("LOCALAPPDATA")
        if local_appdata:
            return Path(local_appdata)

        return Path.home() / "AppData" / "Local"

    return Path.home() / ".config"


def install_dir(source_dir: Path, target_dir: Path) -> None:
    global STATUS

    if not source_dir.is_dir():
        print(f"Source directory not found at {source_dir}", file=sys.stderr)
        STATUS = 1
        return

    target_dir.mkdir(parents=True, exist_ok=True)

    for item in sorted(source_dir.iterdir(), key=lambda path: path.name):
        if not item.exists():
            continue

        name = item.name
        target = target_dir / name

        if target.is_symlink():
            link_target = os.readlink(target)
            if link_target == str(item):
                print(f"Symlink already exists for {name}")
                continue

            print(
                f"Conflicting symlink at {target}; remove it manually", file=sys.stderr
            )
            STATUS = 1
            continue
        elif target.exists():
            print(
                f"{target} already exists and is not a symlink; skipping",
                file=sys.stderr,
            )
            STATUS = 1
            continue

        os.symlink(str(item), str(target), target_is_directory=item.is_dir())
        print(f"Created symlink {target} -> {item}")


def install_file(source_file: Path, target: Path) -> None:
    global STATUS

    if not source_file.is_file():
        print(f"Source file not found at {source_file}", file=sys.stderr)
        STATUS = 1
        return

    target.parent.mkdir(parents=True, exist_ok=True)

    if target.is_symlink():
        link_target = os.readlink(target)
        if link_target == str(source_file):
            print(f"Symlink already exists for {target.name}")
            return

        print(
            f"Conflicting symlink at {target}; remove it manually", file=sys.stderr
        )
        STATUS = 1
        return
    elif target.exists():
        print(
            f"{target} already exists and is not a symlink; skipping",
            file=sys.stderr,
        )
        STATUS = 1
        return

    os.symlink(str(source_file), str(target))
    print(f"Created symlink {target} -> {source_file}")


def main() -> int:
    install_dir(SCRIPT_DIR / "config", config_target_dir())
    install_dir(SCRIPT_DIR / ".agents", Path.home() / ".agents")
    install_file(
        SCRIPT_DIR / "pi" / "agent" / "AGENTS.md",
        Path.home() / ".pi" / "agent" / "AGENTS.md",
    )
    install_dir(
        SCRIPT_DIR / "pi" / "agent" / "extensions",
        Path.home() / ".pi" / "agent" / "extensions",
    )
    return STATUS


if __name__ == "__main__":
    sys.exit(main())
