# Changelog

## 0.2.0 — Per-move sound assignments

Sound Effect Replacer now supports optional **Move Sounds**. The package includes a folder for every move: **165 folders** under `assets/Move Sounds/Gen 1/` for Red, Blue, and Yellow, plus **251 folders** under `assets/Move Sounds/Gold/` for Gold. Put one compatible audio file in a move folder and restart the game to add that sound whenever the move is used.

The Gen 1 and Gold trees are deliberately separate. A player can give Thunderbolt one sound in `Gen 1/THUNDERBOLT` and a different sound in `Gold/THUNDERBOLT`; Gold-only moves such as Future Sight have folders only in the Gold tree. Move Sounds play once per move use at the move announcement/animation-start point, respect the battle-animation setting, and currently add to any native sound rather than replacing it.

The release retains the general sound-effect folders, Ogg Opus detection, Ogg Vorbis guidance, and generation-specific SFX mappings from the initial testing build. The updated source passed isolated Gen 1/Gold mapping and playback regressions plus current manifest, lint, syntax, and strict Gen 2 compatibility validation. Live testing is still required.
