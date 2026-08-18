# Changelog

## 0.3.3 — Audio diagnostics

Sound Effect Replacer now performs a conservative startup check of visible replacement files. It detects unsupported extensions, Ogg Opus streams, and clear Ogg/WAV/FLAC header mismatches before those files can replace a game cue. Files with one of those unambiguous problems are skipped, so the corresponding native sound remains active.

When one or more startup-detectable problems are found, the mod shows a single normal in-game text box after the player’s first overworld step and directs the player to the mod log. The log provides the relevant `SFXR-A##` diagnostic code, path, and reason. The warning does not repeat during the same game launch.

This release also documents the distinction between startup checks and later decoder failures, plus Android customization through USB debugging/ADB without root.
