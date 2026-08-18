# Changelog

## 0.3.0 — Complete editable audio coverage

Sound Effect Replacer now uses a simple two-folder workflow modeled on Easy Custom Music: `assets/General Sound Effects/` for friendly everyday categories and `assets/Specific Sound Effects/` for exact control. There are no player-facing Gen 1/Gold folder trees; the mod selects the correct internal cue for the game currently loaded.

The update adds direct folders for every current named engine effect: **104 Red/Blue/Yellow labels** and **187 Gold labels**, with exact Named Effects folders taking priority over a matching friendly General folder. It also provides one shared folder for each of **251 move IDs**, folders for **250 named species cries**, and a generated `SOUND_EFFECT_MAP.md` that documents every exact effect folder.

Evolution is now editable at both stages. `Evolution In Progress` replaces the music while forms flash between one another; `Evolution Complete` replaces Gold’s native completion cue and adds a completion sound before the evolved Pokémon’s cry in Red/Blue/Yellow.

The player-facing layout, complete catalog, Ogg Opus rejection, and Gen 1/Gold routing were checked in an isolated harness and current official validation tools. This remains a WIP/testing release and needs live tests for normal effects, exact effects, move sounds, both evolution stages, and cries.
