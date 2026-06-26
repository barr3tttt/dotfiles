# Voice dictation (OpenSuperWhisper rebuilt for Fedora/Wayland)

OpenSuperWhisper is macOS-only, so the same workflow is rebuilt from Linux parts:
`pw-record` (mic) -> `whisper.cpp` (local transcription with a custom-vocabulary
prompt) -> `ydotool` (types into the focused window; clipboard fallback).

## Components
- `whisper.cpp` built at `~/.local/share/whisper.cpp`; `whisper-cli` on PATH.
- Model: `ggml-base.en.bin` (148 MB). Upgrade to `small.en`/`medium.en` for accuracy:
  `cd ~/.local/share/whisper.cpp && sh ./models/download-ggml-model.sh small.en`
  then set `WHISPER_MODEL` to that path.
- `voice-dictate` (toggle script) on PATH.
- Custom vocabulary: `~/.config/voice/vocab.txt` (tracked: `config/voice/vocab.txt`).
  Whisper uses it as the initial prompt so names like Talroo, WezTerm, gnhf,
  treehouse, Lavish, AXI transcribe with correct spelling. Edit it freely.

## One-time setup
1. Install packages: `sudo dnf install ydotool wl-clipboard`.
2. `bash install/ydotool-setup.sh` - installs ydotoold as a root system service
   (socket at `/run/ydotoold.socket`, owned by you). Reboot-proof; no relogin.
3. `export YDOTOOL_SOCKET=/run/ydotoold.socket` (already added to ~/.bashrc).
4. Bind a KDE global shortcut (see below).

## KDE global shortcut (Plasma 6, Wayland)
System Settings -> Keyboard -> Shortcuts -> Add Command/URL (or "Add Custom Shortcut"):
- Command: `voice-dictate`
- Trigger: e.g. `Meta+Alt+D`
Press once to start recording, press again to stop, transcribe, and type the text.

## Behavior
- Toggle: 1st press records, 2nd press transcribes + injects.
- If ydotoold is not running, the text is copied to the clipboard (paste with Ctrl+V)
  and you get a notification, so dictation degrades gracefully.

## Verified
- whisper-cli transcription (bundled jfk.wav) accurate.
- Record -> wav -> whisper pipeline works with `pw-record`.
- ydotool injection through the root ydotoold service: PASS.
- KDE shortcut Meta+Alt+D bound via kglobalshortcutsrc (confirm with a keypress;
  adjust in System Settings -> Keyboard -> Shortcuts if needed).
