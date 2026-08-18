# Sound Effect Replacer

**Sound Effect Replacer** lets players replace selected game sound effects with their own audio in **Pokémon Red, Blue, Yellow, and Gold** for Gen1Recomp.

Drop one compatible audio file into a named folder inside this mod’s `assets/` directory, then restart the game. The replacement applies to the corresponding in-game cue or cue group.

> **Use Ogg Vorbis for `.ogg` files.** Ogg is a container: Ogg Opus files also end in `.ogg`, but LÖVE/Gen1Recomp does not support them. Do not merely rename an extension; re-encode Opus files as **Ogg Vorbis**.

## Installation and use

1. Import the mod ZIP through **MODS > Import mod .zip** and enable it for the game you are playing.
2. Open the installed mod directory, then open `assets/`.
3. Place **one audio file** in each replacement folder you want to use.
4. Fully close and restart Gen1Recomp. The mod scans its asset folders at startup.

On a standard Windows installation, the active path is usually:

```text
%APPDATA%\pokelove2d\mods\sound_effect_replacer\assets\<folder>\your_sound.ogg
```

The same audio file may be copied into as many different folders as desired. The only limit is **one usable audio file per individual folder**. If a folder contains more than one, the mod chooses the first supported filename alphabetically.

Supported formats are `.ogg` (**Vorbis only**), `.wav`, `.mp3`, and `.flac`. Sound effects load as static audio, so short files are strongly recommended; the mod warns in its log when a replacement is larger than 5 MiB.

## Replacement folders

The following table lists each friendly asset folder and the game support in this first build.

| Folder | Red / Blue / Yellow | Gold |
| --- | --- | --- |
| `Battle Damage` | Damage cue | Damage cue |
| `Battle Super Effective` | Super-effective cue | Super-effective cue |
| `Battle Not Very Effective` | Not-very-effective cue | Not-very-effective cue |
| `Battle Faint` | Both faint sounds | Faint cue |
| `Capture Throw` | Poké Ball throw | Ball throw |
| `Capture Success` | Successful capture | Successful capture |
| `Level Up` | Level-up fanfare | Level-up fanfare |
| `Evolution Success` | Not a standalone SFX; see limitation | Evolution-complete cue |
| `Egg Hatch` | Not available | Egg-hatch cue |
| `Item Received` | Both ordinary item fanfares | Item cue |
| `Key Item` | Key-item fanfare | Key-item cue |
| `Badge Received` | Badge/item fanfare | Badge cue |
| `TM Received` | TM/item fanfare | TM cue |
| `Trade Complete` | Trade-machine cue | Trade send/receive cues |
| `Menu Open` | Start-menu cue | Menu cue |
| `Menu Confirm` | A/B confirmation cue | Text-confirmation cue |
| `Menu Denied` | Denied cue | Wrong/denied cue |
| `Save` | Save cue | Save cue |
| `Enter Building` | Door-entry cue | Door-entry cue |
| `Exit Building` | Door-exit cue | Door-exit cue |
| `Warp` | All four teleport/warp cues | Warp-from and warp-to cues |
| `Run` | Run cue | Run cue |
| `Jump Ledge` | Ledge-jump cue | Ledge-jump cue |
| `PC Boot` | PC power-on cue | PC boot cue |
| `PC Shutdown` | PC power-off cue | PC shutdown cue |
| `Pokemon Switch` | Party/battle switch cues | Pokémon-switch cue |
| `Heal HP` | HP-heal cue | Potion/heal cue |
| `Heal Status` | Status-heal cue | Full-heal cue |
| `Healing Machine` | Pokémon Center recovery machine | Not a standalone SFX; see limitation |
| `Move Tackle` | Not yet mapped; Gen 1 exposes this as an unnamed battle SFX | Tackle cue |
| `Move Scratch` | Not yet mapped; Gen 1 exposes this as an unnamed battle SFX | Scratch cue |
| `Move Water Gun` | Not yet mapped; Gen 1 exposes this as an unnamed battle SFX | Water Gun cue |
| `Move Psychic` | Psychic cue | Psychic cue |
| `Move Psybeam` | Psybeam cue | Psybeam cue |
| `Move Hyper Beam` | Not yet mapped; Gen 1 exposes this as an unnamed battle SFX | Hyper Beam cue |
| `Move Vine Whip` | Vine Whip cue | Vine Whip cue |
| `Move Cut` | Cut cue | Cut cue |
| `Move Fly` | Fly cue | Fly cue |
| `Move Surf` | Not yet mapped; Gen 1 exposes this as an unnamed battle SFX | Surf cue |
| `Move Strength` | Push-boulder cue | Strength cue |
| `Status Poison` | Poison status cue | Poison cue |
| `Pokedex Fanfare` | Pokédex page/rating fanfares | All eight Pokédex milestone fanfares |

## Important limitations

This mod replaces **sound effects only**. Some moments that seem like sound effects are actually handled as music or Pokémon cries.

| Moment | Why it is not replaced by this build |
| --- | --- |
| Red/Blue/Yellow evolution completion | Uses evolution music followed by the evolved Pokémon’s cry, rather than a standalone SFX. |
| Gold Pokémon Center recovery | Uses a music jingle rather than a standalone SFX. |
| Pokémon cries | They are species-specific cry data, not general SFX. |
| Several Gen 1 move sounds | The current R/B/Y extracted data exposes them as anonymous `Battle_XX` IDs. They need an explicitly verified mapping before a friendly folder can safely replace them. |

## Diagnostics

If an `.ogg` file is actually Ogg Opus, the mod skips it and logs a message telling the player to re-encode it as Ogg Vorbis. It also logs each loaded folder and a warning when no replacement files are found.

This first build is intended for testing. Please test one folder at a time, starting with `Battle Damage`, `Menu Open`, or `Level Up`, and report the game version, folder name, and any **MOD ERRORS** text if a replacement does not play.

## Credits

The user-friendly drop-in asset-folder workflow was inspired by [Easy Custom Music](https://github.com/ty-mcdk/easy-custom-music) by **ty-mcdk**. See [CREDITS.md](CREDITS.md) for the full attribution and implementation distinction.

This project is **AI assisted**, not AI created.
