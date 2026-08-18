# Changelog

## 0.1.0 — Initial testing build

- Added a new API 2 content mod for **Red, Blue, Yellow, and Gold**.
- Added friendly asset folders for selected battle, capture, menu, item, overworld, PC, healing, status, and Pokédex sound effects.
- Added verified generation-specific mappings rather than assuming Red/Blue/Yellow IDs match Gold IDs.
- Added Gold-only replacement categories for evolution completion, egg hatching, and several named move effects.
- Added startup diagnostics for loaded folders, missing replacements, large static audio files, and unsupported **Ogg Opus** streams.
- Documented that `.ogg` files must contain **Ogg Vorbis**, not Ogg Opus.
- Documented intentionally unsupported moments that are music, species cries, or currently anonymous Gen 1 battle SFX.

This is a first testing build. It has passed isolated Gen 1 and Gold mapping regression checks plus current official manifest, lint, and strict Gen 2 compatibility validation. It still needs live in-game playback testing on all supported cartridge versions.
