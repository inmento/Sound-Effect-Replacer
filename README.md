# Sound Effect Replacer

**Sound Effect Replacer** lets players replace named sound effects, move-use sounds, evolution audio, optional Pokémon cries, and Yellow Pikachu voice clips in **Pokémon Red, Blue, Yellow, Gold, Silver, and Crystal**. Version **0.5.0** adds native Crystal routing through the established Gen 2 asset tree while retaining the player-facing asset structure, multiple-file behavior, and safety checks introduced with [Easy Custom Music v2.0.0](https://github.com/ty-mcdk/easy-custom-music/releases/tag/v2.0.0).

## Version 0.4.0: required layout change

The canonical replacement tree is now split by game generation. **Gen 1 and Gen 2 folders are separate on purpose.** This lets one cue use different audio in Red/Blue/Yellow and Gold/Silver/Crystal without ambiguity.

```text
assets/
├── Gen 1/
│   ├── General Sound Effects/
│   └── Specific Sound Effects/
└── Gen 2/
    ├── General Sound Effects/
    └── Specific Sound Effects/
```

| Loaded game | Active replacement tree |
|---|---|
| Red, Blue, or Yellow | `assets/Gen 1/` |
| Gold, Silver, or Crystal | `assets/Gen 2/` |

> **Migration notice.** Move existing files from the old unlabelled `assets/General Sound Effects/` and `assets/Specific Sound Effects/` paths into the matching `Gen 1` and/or `Gen 2` trees. Version 0.4.0 retains the old layout only as a lower-priority migration fallback. If both layouts contain a replacement for the same target, the generation-specific folder wins.

## Multiple files per target

A target folder can now contain **multiple compatible audio files**. Sound Effect Replacer registers each validated file and uses them in stable alphabetical rotation every time that target is triggered. This applies to friendly General categories, exact Named Effects, Move Sounds, Pokémon Cries, Yellow Pikachu voice clips, and both evolution folders.

```text
assets/Gen 1/Specific Sound Effects/Named Effects/Damage/
├── 01-light-hit.ogg
├── 02-heavy-hit.ogg
└── 03-critical-hit.ogg
```

The next occurrences of that sound use `01`, then `02`, then `03`, and repeat. The same target in `assets/Gen 2/` has its own independent playlist.

## General Sound Effects

`assets/Gen 1/General Sound Effects/` and `assets/Gen 2/General Sound Effects/` contain **36 friendly categories** for the most common replacement targets: damage, fainting, capture, item fanfares, menus, saving, PC actions, warps, running, field moves, healing, poison, and Pokédex fanfares.

```text
assets/Gen 1/General Sound Effects/Battle Damage/01-hit.ogg
assets/Gen 1/General Sound Effects/Menu Confirm/confirm.wav
assets/Gen 2/General Sound Effects/Healing Machine/01-heal.ogg
```

A friendly category maps to the appropriate native cue for the active generation. For example, `Healing Machine` routes to the Gen 1 healing-machine effect in Gen 1, while its Gen 2 counterpart routes through the `Music_HealPokemon` cue without altering ordinary map music.

## Specific Sound Effects

`assets/Gen 1/Specific Sound Effects/` and `assets/Gen 2/Specific Sound Effects/` provide direct access to exact cue families. Every folder is optional.

| Subfolder | Coverage | Example |
|---|---|---|
| `Named Effects/` | Complete named SFX catalog for the active generation. | `Named Effects/Damage/`, `Named Effects/Sfx_Damage/` |
| `Move Sounds/` | One optional folder for each supported move ID. | `Move Sounds/THUNDERBOLT/`, `Move Sounds/FUTURE_SIGHT/` |
| `Evolution/` | Evolution in-progress music and completion cue. | `Evolution/Evolution In Progress/` |
| `Pokemon Cries/` | Per-species cry replacements in the active generation. | `Pokemon Cries/PIKACHU/`, `Pokemon Cries/CHIKORITA/` |
| `Yellow Pikachu Voice Clips/` | Yellow’s 42 special PCM clip positions. Gen 1 only. | `Yellow Pikachu Voice Clips/11/` |

### Exact Named Effects

Technical labels under `Named Effects/` are the exhaustive fallback for effects beyond the friendly General categories. Exact folders take precedence over a matching General folder.

```text
assets/Gen 1/Specific Sound Effects/Named Effects/Ball_Toss/throw.ogg
assets/Gen 2/Specific Sound Effects/Named Effects/Sfx_BallWobble/wobble.ogg
```

### Move Sounds

Place audio under `Move Sounds/<MOVE_ID>/` to add a selected replacement once when that move is used. The behavior respects the battle-animation setting and runs once per move use, not once per individual hit of a multi-hit move. Custom move sounds intentionally **add to** native move sound behavior when one exists; they do not suppress native move audio.

```text
assets/Gen 1/Specific Sound Effects/Move Sounds/THUNDERBOLT/lightning.ogg
assets/Gen 2/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future.ogg
```

### Evolution audio

| Folder | Behavior |
|---|---|
| `Evolution/Evolution In Progress/` | Rotates the evolution scene music. In Gen 1, only an actual pending evolution is retargeted; map music remains unchanged. In Gen 2, selection is routed only when `Music_Evolution` is chosen. |
| `Evolution/Evolution Complete/` | Rotates the completion sound immediately before the evolved form’s cry. In Gen 2, it routes only the native `Sfx_Evolved` cue. In Gen 1, it plays before the native new-species cry because Gen 1 has no separate named completion SFX. |

```text
assets/Gen 1/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg
assets/Gen 2/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg
```

### Pokémon cries and Yellow voice clips

A file under `Pokemon Cries/<SPECIES>/` is used wherever the active game plays that species’ ordinary cry, including battle send-outs, Pokédex viewing, party/box viewing, and evolution reveal.

```text
assets/Gen 1/Specific Sound Effects/Pokemon Cries/PIKACHU/pikachu.ogg
assets/Gen 2/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg
```

Yellow’s voiced Pikachu uses a separate PCM system. Its 42 numbered folders are only active in Yellow and retain native fallback playback when unassigned.

```text
assets/Gen 1/Specific Sound Effects/Yellow Pikachu Voice Clips/01/title.ogg
assets/Gen 1/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg
```

## Complete coverage map

See **[SOUND_EFFECT_MAP.md](SOUND_EFFECT_MAP.md)** for the full catalog of General categories, exact Named Effects, supported Move Sound folders, numbered Yellow clips, and evolution targets. It contains identifiers only and no game audio.

## Audio rules and diagnostics

Sound Effect Replacer accepts every audio extension decoded by the bundled LÖVE 11.5 runtime: Ogg Vorbis (`.ogg`, `.oga`, `.ogv`), `.wav`, `.mp3`, `.flac`, and supported tracker/module formats. Short files are recommended; the mod warns for a replacement larger than 5 MiB.

> **Ogg Opus is not supported.** An `.ogg`, `.oga`, or `.ogv` file must contain Ogg Vorbis. The mod detects and skips an Opus stream before it can fail silently.

At startup, the mod conservatively scans visible replacement files. It skips only clear setup problems so the native cue remains available.

| Code | Meaning | Resolution |
|---|---|---|
| `SFXR-A01` | Unsupported filename extension | Convert to a supported format. |
| `SFXR-A02` | Ogg Opus stream | Re-encode as Ogg Vorbis. |
| `SFXR-A03` | Clear `.ogg`, `.wav`, or `.flac` container/header mismatch | Export again in the format matching the extension. |
| `SFXR-A04` | The advisory diagnostic text box could not be queued | Read the mod log for the original warning. |

If the scan finds an issue, one standard text box appears after the player’s first overworld step and directs the player to the log. The warning does not alter saves, encounters, battle state, or unassigned native audio.

## Included PotatoVoxel detection sound

The optional [PotatoVoxel](https://github.com/ShaneMcGovernIE/potato_voxel) integration remains unchanged. If that mod is installed and enabled, Sound Effect Replacer detects its manifest ID and plays one short original confirmation cue assembled through Gen1Recomp’s supported `src.audio.ChipAsm` API. It packages no WAV and does not replace a native game sound.

## Desktop and mobile setup

**Desktop is the supported customization route.** Place compatible audio files in the intended folder under the installed mod’s `assets/` directory, then fully restart Gen1Recomp.

Sound Effect Replacer deliberately does **not** provide an arbitrary-audio importer. Gen1Recomp’s protected user-file import flow is for specifically declared, hash-verified files; it cannot safely accept an arbitrary custom track. The mod does not bypass that protection.

On Android, standard file-manager access to a mod directory may be restricted. A desktop computer is the simplest supported setup method. Android USB debugging/ADB can copy files into the app’s external files area when appropriate, while rooted devices can access folders directly. In all cases, finish by fully restarting Gen1Recomp.

## Recommended test sequence

Test one folder from each active-generation category: a General effect, a Named Effect, a two-file playlist, a Move Sound, an Evolution folder, and a Pokémon Cry. For Yellow, also test one numbered Pikachu voice clip. When reporting a problem, include the game, exact folder, filename/codec, player action, any `SFXR-A##` code, and the relevant **MOD ERRORS** text.

## Credits

The drop-in asset-folder workflow and the v0.4.0 generation/multiple-file update are informed by [Easy Custom Music](https://github.com/ty-mcdk/easy-custom-music) by **ty-mcdk**. Sound Effect Replacer remains an independent implementation for sound-effect, cry, move-event, Yellow voice-clip, and evolution surfaces.

> Crystal uses the shared Gen 2 catalog and `assets/Gen 2/` folder. The release does not package, extract, or replace any Crystal ROM audio; it only routes player-supplied replacement files through the current engine APIs.

This project is **AI assisted**, not AI created.
