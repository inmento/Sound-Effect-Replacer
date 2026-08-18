# Sound Effect Replacer

**Sound Effect Replacer** lets players replace the current Gen1Recomp engine’s named sound effects in **Pokémon Red, Blue, Yellow, and Gold**. It now uses the same simple two-top-level-folder idea as Easy Custom Music:

```text
assets/
├── General Sound Effects/
└── Specific Sound Effects/
```

Place one compatible audio file in any selected folder, fully restart Gen1Recomp, and the mod routes it to the matching cue for the game currently loaded. There are **no player-facing Gen 1 or Gold folder trees**. A shared folder such as `Move Sounds/THUNDERBOLT` works in every supported game where Thunderbolt exists; a Gold-only folder such as `Move Sounds/FUTURE_SIGHT` simply does nothing outside Gold.

> **For `.ogg` files, use Ogg Vorbis—not Ogg Opus.** Both use the `.ogg` extension, but the current LÖVE runtime can play Vorbis and cannot play Opus. The mod detects and skips Opus files with a diagnostic warning.

## General Sound Effects

`assets/General Sound Effects/` holds **36 friendly categories** for the cues most players will want first: damage, fainting, capture, item fanfares, menus, saving, PC actions, warps, running, field moves, healing, poison, and Pokédex fanfares.

```text
assets/General Sound Effects/Battle Damage/your-hit.ogg
assets/General Sound Effects/Capture Success/your-capture.ogg
assets/General Sound Effects/Menu Confirm/your-confirm.ogg
```

A General folder can map to a different native cue in Red/Blue/Yellow and Gold, but the mod chooses the appropriate active-game cue automatically. For example, `Healing Machine` replaces Gen 1’s named healing-machine SFX and Gold’s dedicated `Music_HealPokemon` jingle. These friendly folders are optional shortcuts, not a reduced feature set.

## Specific Sound Effects

`assets/Specific Sound Effects/` provides direct access to the complete named audio catalog plus per-move, evolution, and cry choices.

| Subfolder | Coverage | Example |
|---|---|---|
| `Named Effects/` | Every current named engine SFX: **104** R/B/Y labels and **187** Gold labels. | `Named Effects/Damage/`, `Named Effects/Sfx_Damage/` |
| `Move Sounds/` | One optional folder for each of the **251** move IDs. | `Move Sounds/THUNDERBOLT/`, `Move Sounds/FUTURE_SIGHT/` |
| `Evolution/` | The evolution scene’s in-progress music and completion cue. | `Evolution/Evolution In Progress/` |
| `Pokemon Cries/` | One folder for each of the **250** named species in the Gold catalog; shared names work in R/B/Y. | `Pokemon Cries/PIKACHU/` |
| `Yellow Pikachu Voice Clips/` | All 42 special Yellow Pikachu PCM clips, outside the ordinary cry table. | `Yellow Pikachu Voice Clips/01/` |

### Exact Named Effects

The technical labels under `Named Effects/` are the exhaustive fallback. They include named Gen 1 battle entries such as `Battle_09`, UI/field labels such as `Ball_Toss` and `Healing_Machine`, and Gold labels such as `Sfx_BallWobble`, `Sfx_EscapeRope`, and `Sfx_TrainArrived`.

```text
assets/Specific Sound Effects/Named Effects/Ball_Toss/your-throw.ogg
assets/Specific Sound Effects/Named Effects/Sfx_BallWobble/your-wobble.ogg
```

If both a friendly General folder and its corresponding exact Named Effects folder contain audio, the **Named Effects** file loads later and wins. This gives a player a simple path for ordinary use and an exact path for complete control.

### Move Sounds

Place a sound in `Move Sounds/<MOVE_ID>/` to add that sound once whenever the move is used. It respects the battle-animation setting and plays once per move use—not once per hit of a multi-hit move. In this testing release, a custom Move Sound **adds to** the native move sound when one exists; it does not suppress the native sound.

```text
assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/lightning.ogg
assets/Specific Sound Effects/Move Sounds/FLAMETHROWER/flame.ogg
assets/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future.ogg
```

### Yellow Pikachu Voice Clips

Pokémon Yellow’s voiced Pikachu uses a separate 42-clip PCM system instead of the ordinary `PIKACHU` cry. The numbered folders below expose those clips directly; they are inactive in Red, Blue, and Gold.

```text
assets/Specific Sound Effects/Yellow Pikachu Voice Clips/01/pikachu-title.ogg
assets/Specific Sound Effects/Yellow Pikachu Voice Clips/11/pikachu-battle.ogg
```

### Evolution Sounds

Evolution has two separately editable moments:

| Folder | What it changes |
|---|---|
| `Evolution/Evolution In Progress/` | The music playing while the old and new forms flash between one another. In R/B/Y, the mod retargets only an actual pending evolution; it does not change a map theme. In Gold, it replaces `Music_Evolution`. |
| `Evolution/Evolution Complete/` | The completion sound immediately before the evolved form’s cry. In Gold, it replaces `Sfx_Evolved`. In R/B/Y, it adds the supplied completion sound before the native new-species cry, because the original game has no separate named evolution-complete SFX. |

```text
assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg
assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg
```

### Pokémon Cries

A file in `Pokemon Cries/<SPECIES>/` replaces that species’ cry wherever the current game plays it, including battle send-outs, Pokédex viewing, party/box viewing, and evolution reveal.

```text
assets/Specific Sound Effects/Pokemon Cries/PIKACHU/pikachu.ogg
assets/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg
```

## Complete Coverage Map

See **[SOUND_EFFECT_MAP.md](SOUND_EFFECT_MAP.md)** for the full generated catalog and every exact `Named Effects` folder. The map also lists all General folders, every numbered Yellow Pikachu voice clip, and both evolution folders. It is generated from the current Gen1Recomp Red/Blue/Yellow ROM manifest and Gold audio table; it contains only identifiers, not ROM-derived audio.

## File Rules

The same audio file may be copied to as many folders as desired. Each individual folder should contain **one usable replacement file**. If a folder contains several supported files, the mod uses the first filename alphabetically.

Supported formats are `.ogg` (**Vorbis only**), `.wav`, `.mp3`, and `.flac`. Sound effects load as static audio, so short files are recommended. The mod warns when a replacement is larger than 5 MiB.

Every folder is optional. Empty folders leave the native game audio unchanged.

## Testing Focus

This is a testing build. Please first test one friendly General folder, one exact Named Effects folder, one Move Sounds folder, and both evolution folders. Useful controls are:

```text
General Sound Effects/Battle Damage/
Specific Sound Effects/Named Effects/Damage/
Specific Sound Effects/Move Sounds/THUNDERBOLT/
Specific Sound Effects/Evolution/Evolution In Progress/
Specific Sound Effects/Evolution/Evolution Complete/
```

When reporting a problem, include the game, exact folder, filename/codec, what action was performed, and any **MOD ERRORS** text.

## Credits

The simple drop-in asset-folder workflow was inspired by [Easy Custom Music](https://github.com/ty-mcdk/easy-custom-music) by **ty-mcdk**, who explicitly permitted using its code as a base. Sound Effect Replacer is an independent implementation for the sound-effect, cry, move-event, and evolution audio surfaces.

This project is **AI assisted**, not AI created.
