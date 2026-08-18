# Sound Effect Coverage Map

This map is generated from the current local Gen1Recomp Red/Blue/Yellow ROM manifest and Gold audio table. It contains identifiers and user-facing folder names only; it contains no ROM audio data.

The mod deliberately has only two player-facing top-level folders:

```text
assets/General Sound Effects/
assets/Specific Sound Effects/
```

The active game selects the correct internal target automatically. A folder is harmless when its cue does not exist in the currently loaded game.

## General Sound Effects

| Folder | Intended cue |
|---|---|
| `Battle Damage` | Damage hit cue. |
| `Battle Super Effective` | Super-effective feedback cue. |
| `Battle Not Very Effective` | Not-very-effective feedback cue. |
| `Battle Faint` | Pokémon faint feedback cue. |
| `Trainer Appeared` | Gen 1 trainer encounter cue; Gold has no separately named equivalent. |
| `Capture Throw` | Poké Ball throw cue. |
| `Capture Success` | Capture-success cue. |
| `Capture Ball Bounce` | Gold ball-bounce cue. |
| `Capture Ball Wobble` | Gold ball-wobble cue. |
| `Level Up` | Level-up fanfare. |
| `Item Received` | Ordinary item fanfare. |
| `Key Item` | Key-item fanfare. |
| `Badge Received` | Badge-received fanfare. |
| `TM Received` | TM-received fanfare. |
| `Trade Complete` | Trade-machine completion cue. |
| `Purchase` | Shop purchase/transaction cue. |
| `Menu Open` | Start/menu opening cue. |
| `Menu Confirm` | Confirm/read-text cue. |
| `Menu Denied` | Invalid-choice cue. |
| `Save` | Save confirmation cue. |
| `PC Boot` | PC startup cue. |
| `PC Shutdown` | PC shutdown cue. |
| `Pokemon Switch` | Party/box switching cue. |
| `Enter Building` | Door/building entry cue. |
| `Exit Building` | Building exit cue. |
| `Warp` | Warp/teleport transition cue. |
| `Run` | Running cue. |
| `Jump Ledge` | Ledge-jump cue. |
| `Cut Field Move` | Overworld Cut cue. |
| `Fly Field Move` | Overworld Fly cue. |
| `Strength Field Move` | Overworld Strength/push cue. |
| `Heal HP` | HP restoration cue. |
| `Heal Status` | Status restoration cue. |
| `Healing Machine` | Gen 1 healing-machine cue; Gold Music_HealPokemon jingle. |
| `Poison` | Poison/status cue. |
| `Pokedex Fanfare` | Pokédex page/rating fanfare. |

Place one compatible audio file inside any chosen folder. General folders are friendly grouped shortcuts. A matching exact folder under `Specific Sound Effects/Named Effects/` loads afterward and therefore takes priority when both are populated.

## Specific Sound Effects

### Evolution

| Folder | What it changes | Red / Blue / Yellow | Gold |
|---|---|---|---|
| `Evolution/Evolution In Progress` | The music heard while the species flashes between forms. | Retargets the evolution scene only through the evolution check flow. | Replaces `Music_Evolution`. |
| `Evolution/Evolution Complete` | The sound immediately before the new form’s cry. | Adds the chosen completion sound before the native new-species cry. | Replaces `Sfx_Evolved`. |

### Move Sounds

There is one folder for each of the **251** move IDs: `Move Sounds/<MOVE_ID>/`. Examples include `THUNDERBOLT`, `FLAMETHROWER`, `SURF`, `PSYCHIC_M`, and Gold-only `FUTURE_SIGHT`. The same folder name works in every generation where the move exists. The selected sound plays once when that move is used and currently adds to any native move sound.

### Pokémon Cries

There is one folder for each of the **250** named species in the Gold catalog: `Pokemon Cries/<SPECIES>/`. Shared species folders also apply to Red/Blue/Yellow. Gold-only species folders are simply inactive outside Gold.

### Yellow Pikachu Voice Clips

Pokémon Yellow routes Pikachu through a separate 42-clip PCM voice system instead of the ordinary species-cry table. Folders `Yellow Pikachu Voice Clips/01/` through `Yellow Pikachu Voice Clips/42/` expose every numbered clip. They are inactive in Red, Blue, and Gold.

### Named Effects

The current engine exposes **104** named Red/Blue/Yellow effects and **187** named Gold effects. Every named identifier has a direct folder under `Named Effects/<ID>/`. These are exact technical labels, intended for a player who wants a specific cue beyond the General Sound Effects shortcuts.

| Exact folder | R/B/Y | Gold |
|---|---:|---:|
| `Named Effects/59` | Yes | — |
| `Named Effects/Arrow_Tiles` | Yes | — |
| `Named Effects/Ball_Poof` | Yes | — |
| `Named Effects/Ball_Toss` | Yes | — |
| `Named Effects/Battle_09` | Yes | — |
| `Named Effects/Battle_0B` | Yes | — |
| `Named Effects/Battle_0C` | Yes | — |
| `Named Effects/Battle_0D` | Yes | — |
| `Named Effects/Battle_0E` | Yes | — |
| `Named Effects/Battle_0F` | Yes | — |
| `Named Effects/Battle_12` | Yes | — |
| `Named Effects/Battle_13` | Yes | — |
| `Named Effects/Battle_14` | Yes | — |
| `Named Effects/Battle_16` | Yes | — |
| `Named Effects/Battle_17` | Yes | — |
| `Named Effects/Battle_18` | Yes | — |
| `Named Effects/Battle_19` | Yes | — |
| `Named Effects/Battle_1B` | Yes | — |
| `Named Effects/Battle_1C` | Yes | — |
| `Named Effects/Battle_1E` | Yes | — |
| `Named Effects/Battle_20` | Yes | — |
| `Named Effects/Battle_21` | Yes | — |
| `Named Effects/Battle_22` | Yes | — |
| `Named Effects/Battle_23` | Yes | — |
| `Named Effects/Battle_24` | Yes | — |
| `Named Effects/Battle_25` | Yes | — |
| `Named Effects/Battle_26` | Yes | — |
| `Named Effects/Battle_27` | Yes | — |
| `Named Effects/Battle_28` | Yes | — |
| `Named Effects/Battle_29` | Yes | — |
| `Named Effects/Battle_2A` | Yes | — |
| `Named Effects/Battle_2B` | Yes | — |
| `Named Effects/Battle_2C` | Yes | — |
| `Named Effects/Battle_2E` | Yes | — |
| `Named Effects/Battle_2F` | Yes | — |
| `Named Effects/Battle_31` | Yes | — |
| `Named Effects/Battle_32` | Yes | — |
| `Named Effects/Battle_33` | Yes | — |
| `Named Effects/Battle_34` | Yes | — |
| `Named Effects/Battle_35` | Yes | — |
| `Named Effects/Battle_36` | Yes | — |
| `Named Effects/Caught_Mon` | Yes | — |
| `Named Effects/Collision` | Yes | — |
| `Named Effects/Cut` | Yes | — |
| `Named Effects/Damage` | Yes | — |
| `Named Effects/Denied` | Yes | — |
| `Named Effects/Dex_Page_Added` | Yes | — |
| `Named Effects/Doubleslap` | Yes | — |
| `Named Effects/Enter_PC` | Yes | — |
| `Named Effects/Faint_Fall` | Yes | — |
| `Named Effects/Faint_Thud` | Yes | — |
| `Named Effects/Fly` | Yes | — |
| `Named Effects/Get_Item1` | Yes | — |
| `Named Effects/Get_Item2` | Yes | — |
| `Named Effects/Get_Key_Item` | Yes | — |
| `Named Effects/Go_Inside` | Yes | — |
| `Named Effects/Go_Outside` | Yes | — |
| `Named Effects/Heal_Ailment` | Yes | — |
| `Named Effects/Heal_HP` | Yes | — |
| `Named Effects/Healing_Machine` | Yes | — |
| `Named Effects/Horn_Drill` | Yes | — |
| `Named Effects/Intro_Crash` | Yes | — |
| `Named Effects/Intro_Hip` | Yes | — |
| `Named Effects/Intro_Hop` | Yes | — |
| `Named Effects/Intro_Lunge` | Yes | — |
| `Named Effects/Intro_Raise` | Yes | — |
| `Named Effects/Intro_Whoosh` | Yes | — |
| `Named Effects/Ledge` | Yes | — |
| `Named Effects/Level_Up` | Yes | — |
| `Named Effects/Not_Very_Effective` | Yes | — |
| `Named Effects/Peck` | Yes | — |
| `Named Effects/Poisoned` | Yes | — |
| `Named Effects/Pokedex_Rating` | Yes | — |
| `Named Effects/Pokeflute` | Yes | — |
| `Named Effects/Pound` | Yes | — |
| `Named Effects/Press_AB` | Yes | — |
| `Named Effects/Psybeam` | Yes | — |
| `Named Effects/Psychic_M` | Yes | — |
| `Named Effects/Purchase` | Yes | — |
| `Named Effects/Push_Boulder` | Yes | — |
| `Named Effects/Run` | Yes | — |
| `Named Effects/SS_Anne_Horn` | Yes | — |
| `Named Effects/Safari_Zone_PA` | Yes | — |
| `Named Effects/Save` | Yes | — |
| `Named Effects/Sfx_1stPlace` | — | Yes |
| `Named Effects/Sfx_2Boops` | — | Yes |
| `Named Effects/Sfx_2ndPlace` | — | Yes |
| `Named Effects/Sfx_3rdPlace` | — | Yes |
| `Named Effects/Sfx_Aeroblast` | — | Yes |
| `Named Effects/Sfx_Attract` | — | Yes |
| `Named Effects/Sfx_BallBounce` | — | Yes |
| `Named Effects/Sfx_BallPoof` | — | Yes |
| `Named Effects/Sfx_BallWobble` | — | Yes |
| `Named Effects/Sfx_BatonPass` | — | Yes |
| `Named Effects/Sfx_BeatUp` | — | Yes |
| `Named Effects/Sfx_BellyDrum` | — | Yes |
| `Named Effects/Sfx_Bind` | — | Yes |
| `Named Effects/Sfx_Bite` | — | Yes |
| `Named Effects/Sfx_Boat` | — | Yes |
| `Named Effects/Sfx_BoneClub` | — | Yes |
| `Named Effects/Sfx_BootPc` | — | Yes |
| `Named Effects/Sfx_Bubblebeam` | — | Yes |
| `Named Effects/Sfx_Bump` | — | Yes |
| `Named Effects/Sfx_Burn` | — | Yes |
| `Named Effects/Sfx_Call` | — | Yes |
| `Named Effects/Sfx_CaughtMon` | — | Yes |
| `Named Effects/Sfx_ChangeDexMode` | — | Yes |
| `Named Effects/Sfx_Charge` | — | Yes |
| `Named Effects/Sfx_ChooseACard` | — | Yes |
| `Named Effects/Sfx_ChoosePcOption` | — | Yes |
| `Named Effects/Sfx_CometPunch` | — | Yes |
| `Named Effects/Sfx_Curse` | — | Yes |
| `Named Effects/Sfx_Cut` | — | Yes |
| `Named Effects/Sfx_Damage` | — | Yes |
| `Named Effects/Sfx_DexFanfare140169` | — | Yes |
| `Named Effects/Sfx_DexFanfare170199` | — | Yes |
| `Named Effects/Sfx_DexFanfare200229` | — | Yes |
| `Named Effects/Sfx_DexFanfare2049` | — | Yes |
| `Named Effects/Sfx_DexFanfare230Plus` | — | Yes |
| `Named Effects/Sfx_DexFanfare5079` | — | Yes |
| `Named Effects/Sfx_DexFanfare80109` | — | Yes |
| `Named Effects/Sfx_DexFanfareLessThan20` | — | Yes |
| `Named Effects/Sfx_DoubleKick` | — | Yes |
| `Named Effects/Sfx_Doubleslap` | — | Yes |
| `Named Effects/Sfx_EggBomb` | — | Yes |
| `Named Effects/Sfx_EggCrack` | — | Yes |
| `Named Effects/Sfx_EggHatch` | — | Yes |
| `Named Effects/Sfx_Elevator` | — | Yes |
| `Named Effects/Sfx_ElevatorEnd` | — | Yes |
| `Named Effects/Sfx_Ember` | — | Yes |
| `Named Effects/Sfx_Encore` | — | Yes |
| `Named Effects/Sfx_EnterDoor` | — | Yes |
| `Named Effects/Sfx_EscapeRope` | — | Yes |
| `Named Effects/Sfx_Evolved` | — | Yes |
| `Named Effects/Sfx_ExitBuilding` | — | Yes |
| `Named Effects/Sfx_ExpBar` | — | Yes |
| `Named Effects/Sfx_Faint` | — | Yes |
| `Named Effects/Sfx_Fanfare` | — | Yes |
| `Named Effects/Sfx_Fanfare2` | — | Yes |
| `Named Effects/Sfx_Flash` | — | Yes |
| `Named Effects/Sfx_Fly` | — | Yes |
| `Named Effects/Sfx_Foresight` | — | Yes |
| `Named Effects/Sfx_FullHeal` | — | Yes |
| `Named Effects/Sfx_GameFreakLogoGs` | — | Yes |
| `Named Effects/Sfx_GetBadge` | — | Yes |
| `Named Effects/Sfx_GetCoinFromSlots` | — | Yes |
| `Named Effects/Sfx_GetEgg` | — | Yes |
| `Named Effects/Sfx_GetTm` | — | Yes |
| `Named Effects/Sfx_GetTrademon` | — | Yes |
| `Named Effects/Sfx_GigaDrain` | — | Yes |
| `Named Effects/Sfx_GiveTrademon` | — | Yes |
| `Named Effects/Sfx_GotSafariBalls` | — | Yes |
| `Named Effects/Sfx_GrassRustle` | — | Yes |
| `Named Effects/Sfx_GsIntroCharizardFireball` | — | Yes |
| `Named Effects/Sfx_GsIntroPokemonAppears` | — | Yes |
| `Named Effects/Sfx_HangUp` | — | Yes |
| `Named Effects/Sfx_Headbutt` | — | Yes |
| `Named Effects/Sfx_HealBell` | — | Yes |
| `Named Effects/Sfx_HitEndOfExpBar` | — | Yes |
| `Named Effects/Sfx_HornAttack` | — | Yes |
| `Named Effects/Sfx_HydroPump` | — | Yes |
| `Named Effects/Sfx_HyperBeam` | — | Yes |
| `Named Effects/Sfx_Item` | — | Yes |
| `Named Effects/Sfx_JumpKick` | — | Yes |
| `Named Effects/Sfx_JumpOverLedge` | — | Yes |
| `Named Effects/Sfx_KarateChop` | — | Yes |
| `Named Effects/Sfx_KeyItem` | — | Yes |
| `Named Effects/Sfx_Kinesis` | — | Yes |
| `Named Effects/Sfx_Kinesis2` | — | Yes |
| `Named Effects/Sfx_Leer` | — | Yes |
| `Named Effects/Sfx_LevelUp` | — | Yes |
| `Named Effects/Sfx_Lick` | — | Yes |
| `Named Effects/Sfx_MasterBall` | — | Yes |
| `Named Effects/Sfx_MeanLook` | — | Yes |
| `Named Effects/Sfx_MegaKick` | — | Yes |
| `Named Effects/Sfx_MegaPunch` | — | Yes |
| `Named Effects/Sfx_Menu` | — | Yes |
| `Named Effects/Sfx_Metronome` | — | Yes |
| `Named Effects/Sfx_MilkDrink` | — | Yes |
| `Named Effects/Sfx_MindReader` | — | Yes |
| `Named Effects/Sfx_Moonlight` | — | Yes |
| `Named Effects/Sfx_MorningSun` | — | Yes |
| `Named Effects/Sfx_MoveDeleted` | — | Yes |
| `Named Effects/Sfx_MovePuzzlePiece` | — | Yes |
| `Named Effects/Sfx_Nightmare` | — | Yes |
| `Named Effects/Sfx_NoSignal` | — | Yes |
| `Named Effects/Sfx_NotVeryEffective` | — | Yes |
| `Named Effects/Sfx_Outrage` | — | Yes |
| `Named Effects/Sfx_PayDay` | — | Yes |
| `Named Effects/Sfx_Peck` | — | Yes |
| `Named Effects/Sfx_PerishSong` | — | Yes |
| `Named Effects/Sfx_PlacePuzzlePieceDown` | — | Yes |
| `Named Effects/Sfx_Poison` | — | Yes |
| `Named Effects/Sfx_PoisonSting` | — | Yes |
| `Named Effects/Sfx_PokeballsPlacedOnTable` | — | Yes |
| `Named Effects/Sfx_Pokeflute` | — | Yes |
| `Named Effects/Sfx_Potion` | — | Yes |
| `Named Effects/Sfx_Pound` | — | Yes |
| `Named Effects/Sfx_Powder` | — | Yes |
| `Named Effects/Sfx_Present` | — | Yes |
| `Named Effects/Sfx_Protect` | — | Yes |
| `Named Effects/Sfx_Psybeam` | — | Yes |
| `Named Effects/Sfx_Psychic` | — | Yes |
| `Named Effects/Sfx_PushButton` | — | Yes |
| `Named Effects/Sfx_QuitSlots` | — | Yes |
| `Named Effects/Sfx_Rage` | — | Yes |
| `Named Effects/Sfx_RainDance` | — | Yes |
| `Named Effects/Sfx_RazorWind` | — | Yes |
| `Named Effects/Sfx_ReadText` | — | Yes |
| `Named Effects/Sfx_ReadText2` | — | Yes |
| `Named Effects/Sfx_RegisterPhoneNumber` | — | Yes |
| `Named Effects/Sfx_Return` | — | Yes |
| `Named Effects/Sfx_Run` | — | Yes |
| `Named Effects/Sfx_Sandstorm` | — | Yes |
| `Named Effects/Sfx_Save` | — | Yes |
| `Named Effects/Sfx_Scratch` | — | Yes |
| `Named Effects/Sfx_Screech` | — | Yes |
| `Named Effects/Sfx_SecondPartOfItemfinder` | — | Yes |
| `Named Effects/Sfx_Sharpen` | — | Yes |
| `Named Effects/Sfx_Shine` | — | Yes |
| `Named Effects/Sfx_ShutDownPc` | — | Yes |
| `Named Effects/Sfx_Sing` | — | Yes |
| `Named Effects/Sfx_Sketch` | — | Yes |
| `Named Effects/Sfx_SlotMachineStart` | — | Yes |
| `Named Effects/Sfx_SludgeBomb` | — | Yes |
| `Named Effects/Sfx_Snore` | — | Yes |
| `Named Effects/Sfx_Spark` | — | Yes |
| `Named Effects/Sfx_SpiderWeb` | — | Yes |
| `Named Effects/Sfx_Spite` | — | Yes |
| `Named Effects/Sfx_Squeak` | — | Yes |
| `Named Effects/Sfx_Stomp` | — | Yes |
| `Named Effects/Sfx_StopSlot` | — | Yes |
| `Named Effects/Sfx_Strength` | — | Yes |
| `Named Effects/Sfx_Submission` | — | Yes |
| `Named Effects/Sfx_SuperEffective` | — | Yes |
| `Named Effects/Sfx_Supersonic` | — | Yes |
| `Named Effects/Sfx_Surf` | — | Yes |
| `Named Effects/Sfx_SweetKiss` | — | Yes |
| `Named Effects/Sfx_SweetKiss2` | — | Yes |
| `Named Effects/Sfx_SweetScent` | — | Yes |
| `Named Effects/Sfx_SweetScent2` | — | Yes |
| `Named Effects/Sfx_SwitchPockets` | — | Yes |
| `Named Effects/Sfx_SwitchPokemon` | — | Yes |
| `Named Effects/Sfx_SwordsDance` | — | Yes |
| `Named Effects/Sfx_Tackle` | — | Yes |
| `Named Effects/Sfx_TailWhip` | — | Yes |
| `Named Effects/Sfx_Tally` | — | Yes |
| `Named Effects/Sfx_Thief` | — | Yes |
| `Named Effects/Sfx_Thief2` | — | Yes |
| `Named Effects/Sfx_ThrowBall` | — | Yes |
| `Named Effects/Sfx_Thunder` | — | Yes |
| `Named Effects/Sfx_Thundershock` | — | Yes |
| `Named Effects/Sfx_TitleScreenEntrance` | — | Yes |
| `Named Effects/Sfx_Toxic` | — | Yes |
| `Named Effects/Sfx_TrainArrived` | — | Yes |
| `Named Effects/Sfx_Transaction` | — | Yes |
| `Named Effects/Sfx_Unknown5F` | — | Yes |
| `Named Effects/Sfx_Unknown60` | — | Yes |
| `Named Effects/Sfx_Unknown61` | — | Yes |
| `Named Effects/Sfx_Unknown63` | — | Yes |
| `Named Effects/Sfx_Unknown66` | — | Yes |
| `Named Effects/Sfx_Vicegrip` | — | Yes |
| `Named Effects/Sfx_VineWhip` | — | Yes |
| `Named Effects/Sfx_WallOpen` | — | Yes |
| `Named Effects/Sfx_WarpFrom` | — | Yes |
| `Named Effects/Sfx_WarpTo` | — | Yes |
| `Named Effects/Sfx_WaterGun` | — | Yes |
| `Named Effects/Sfx_Whirlwind` | — | Yes |
| `Named Effects/Sfx_WingAttack` | — | Yes |
| `Named Effects/Sfx_Wrong` | — | Yes |
| `Named Effects/Sfx_ZapCannon` | — | Yes |
| `Named Effects/Shooting_Star` | Yes | — |
| `Named Effects/Shrink` | Yes | — |
| `Named Effects/Slots_New_Spin` | Yes | — |
| `Named Effects/Slots_Reward` | Yes | — |
| `Named Effects/Slots_Stop_Wheel` | Yes | — |
| `Named Effects/Start_Menu` | Yes | — |
| `Named Effects/Super_Effective` | Yes | — |
| `Named Effects/Swap` | Yes | — |
| `Named Effects/Switch` | Yes | — |
| `Named Effects/Teleport_Enter1` | Yes | — |
| `Named Effects/Teleport_Enter2` | Yes | — |
| `Named Effects/Teleport_Exit1` | Yes | — |
| `Named Effects/Teleport_Exit2` | Yes | — |
| `Named Effects/Tink` | Yes | — |
| `Named Effects/Trade_Machine` | Yes | — |
| `Named Effects/Trainer_Appeared` | Yes | — |
| `Named Effects/Turn_Off_PC` | Yes | — |
| `Named Effects/Turn_On_PC` | Yes | — |
| `Named Effects/Vine_Whip` | Yes | — |
| `Named Effects/Withdraw_Deposit` | Yes | — |

## Audio format and precedence

Use Ogg Vorbis for `.ogg` files. Ogg Opus is detected and skipped because it is not supported by the current LÖVE runtime. The first supported filename alphabetically within a folder is used. An exact Named Effects folder wins over a populated General Sound Effects shortcut for the same internal cue.

Every folder is optional. Empty folders leave the game’s native audio unchanged.
