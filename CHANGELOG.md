# Changelog

## 0.3.4 — Silver support and Yellow reload safety

Sound Effect Replacer now recognizes **Pokémon Silver** as Generation 2 and uses the established Gen 2 catalog for named effects, General folders, move sounds, evolution music and completion SFX, and species cries. Silver no longer incorrectly uses the Red/Blue/Yellow catalog.

The Yellow Pikachu voice-clip wrapper is also safe across a mod hot reload. It preserves one native fallback wrapper and refreshes only the active replacement-clip lookup, preventing nested wrappers while keeping both custom clips and native fallback playback correct.

The harness now verifies Red, Gold, Yellow, and Silver behavior against the repository entrypoint, including the complete Silver Gen 2 mapping and Yellow reload case.

## 0.3.3 — Audio diagnostics

Sound Effect Replacer now performs a conservative startup check of visible replacement files. It detects unsupported extensions, Ogg Opus streams, and clear Ogg/WAV/FLAC header mismatches before those files can replace a game cue. Files with one of those unambiguous problems are skipped, so the corresponding native sound remains active.

When one or more startup-detectable problems are found, the mod shows a single normal in-game text box after the player’s first overworld step and directs the player to the mod log. The log provides the relevant `SFXR-A##` diagnostic code, path, and reason. The warning does not repeat during the same game launch.

This release also documents the distinction between startup checks and later decoder failures, plus Android customization through USB debugging/ADB without root.
