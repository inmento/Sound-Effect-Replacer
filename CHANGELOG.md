# Changelog

## 0.5.0 — Native Crystal support

Sound Effect Replacer now supports **Pokémon Crystal** on Gen1Recomp `0.2.24` and later. Crystal is routed through the existing Generation II catalog and canonical `assets/Gen 2/` tree, so its named-effect, move-sound, cry, healing-machine, and evolution playlists follow the same independent implementation used for Gold and Silver.

Player-facing diagnostics and logs now refer to **Gen 2 (Gold/Silver/Crystal)** rather than Gold/Silver alone. The release adds a Crystal harness scenario that confirms canonical Gen 2 tree selection, registered private playlist routing, healing/evolution music selection, move-event playback, and Crystal-inclusive status text. It does not package, read, or alter Crystal ROM audio: all optional replacement audio remains player-supplied.

## 0.4.0 — Easy Custom Music v2 structure and playlist compatibility

Sound Effect Replacer now aligns its player-facing asset layout with **Easy Custom Music v2.0.0**. The canonical roots are now `assets/Gen 1/General Sound Effects`, `assets/Gen 1/Specific Sound Effects`, `assets/Gen 2/General Sound Effects`, and `assets/Gen 2/Specific Sound Effects`. Red, Blue, and Yellow load only the Gen 1 tree; Gold and Silver load only the Gen 2 tree.

Every replacement folder can now contain multiple compatible audio files. The mod registers each valid file and rotates through the folder in stable alphabetical order whenever that target is triggered. This applies to General categories, exact Named Effects, Move Sounds, Pokémon Cries, Yellow Pikachu voice clips, Evolution In Progress, and Evolution Complete.

The update preserves the mod’s specialized surfaces rather than treating them as map music. It retains its per-move event behavior, optional per-species cries, Yellow PCM fallback routing, Gen 1 evolution-only retargeting, Gen 2 healing/evolution music selection, conservative file diagnostics, and the optional Lua-authored PotatoVoxel confirmation cue.

To prevent an immediate loss of existing configuration, the old unlabelled `assets/General Sound Effects` and `assets/Specific Sound Effects` paths remain a lower-priority migration fallback in this release. The generation-specific tree takes precedence whenever both contain a replacement for the same target. Move existing files to the appropriate Gen 1 and/or Gen 2 folders.

The regression harness now verifies the legacy migration fallback, Gen 1 and Gen 2 routing, exact-over-general precedence, registered playlist behavior, a two-file rotation, generation-specific precedence over a legacy file, move/evolution/cry behavior, Yellow reload safety, diagnostics, and PotatoVoxel behavior.

## 0.3.4 — Silver support and Yellow reload safety

Sound Effect Replacer now recognizes **Pokémon Silver** as Generation 2 and uses the established Gen 2 catalog for named effects, General folders, move sounds, evolution music and completion SFX, and species cries. Silver no longer incorrectly uses the Red/Blue/Yellow catalog.

The Yellow Pikachu voice-clip wrapper is also safe across a mod hot reload. It preserves one native fallback wrapper and refreshes only the active replacement-clip lookup, preventing nested wrappers while keeping both custom clips and native fallback playback correct.

The harness now verifies Red, Gold, Yellow, and Silver behavior against the repository entrypoint, including the complete Silver Gen 2 mapping and Yellow reload case.

## 0.3.3 — Audio diagnostics

Sound Effect Replacer now performs a conservative startup check of visible replacement files. It detects unsupported extensions, Ogg Opus streams, and clear Ogg/WAV/FLAC header mismatches before those files can replace a game cue. Files with one of those unambiguous problems are skipped, so the corresponding native sound remains active.

When one or more startup-detectable problems are found, the mod shows a single normal in-game text box after the player’s first overworld step and directs the player to the mod log. The log provides the relevant `SFXR-A##` diagnostic code, path, and reason. The warning does not repeat during the same game launch.

This release also documents the distinction between startup checks and later decoder failures, plus Android customization through USB debugging/ADB without root.
