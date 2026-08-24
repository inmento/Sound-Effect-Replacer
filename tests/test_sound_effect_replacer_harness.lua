-- Isolated regression harness for Sound Effect Replacer 0.3.2.
-- Exercises the public mod-object surface without starting Gen1Recomp.
local root = arg[1] or "."

local activeGame = "red"
local played = {}
local nativePikaCalls = {}
local latestSound = nil
local latestChipSfx = nil
local shownTextBoxes = {}
local gameFacade = { data = nil, stack = {} }

package.preload["src.core.GameVersion"] = function()
  return {
    get = function() return activeGame end,
    generation = function(id)
      assert(id == activeGame, "Sound Effect Replacer must classify the active game")
      return (id == "gold" or id == "silver" or id == "crystal") and 2 or 1
    end,
  }
end
package.preload["src.core.Sound"] = function()
  local sound = {
    play = function(data, id)
      played[#played + 1] = { data = data, id = id }
      return { custom = id }
    end,
    playCry = function(data, species)
      played[#played + 1] = { data = data, id = species, cry = true }
      return { custom = species }
    end,
    playPikaCry = function(data, index)
      nativePikaCalls[#nativePikaCalls + 1] = { data = data, index = index }
      return { native = index }
    end,
  }
  latestSound = sound
  return sound
end
package.preload["src.core.Game"] = function() return gameFacade end
package.preload["src.render.TextBox"] = function()
  return {
    new = function(game, text)
      return { game = game, text = text }
    end,
  }
end
package.preload["src.audio.ChipAsm"] = function()
  return {
    sfx = function(spec)
      latestChipSfx = spec
      return { chip = { authored = spec } }
    end,
  }
end

local function run(game, files, foundMods, reuseModules)
  activeGame = game
  played = {}
  nativePikaCalls = {}
  gameFacade.data = { audio = {} }
  latestChipSfx = nil
  shownTextBoxes = {}
  gameFacade.stack = {
    push = function(_, box) shownTextBoxes[#shownTextBoxes + 1] = box end,
  }
  if not reuseModules then
    package.loaded["src.core.GameVersion"] = nil
    package.loaded["src.core.Sound"] = nil
    package.loaded["src.core.Game"] = nil
    package.loaded["src.render.TextBox"] = nil
    package.loaded["src.audio.ChipAsm"] = nil
  end

  local overrides, registered = { sfx = {}, cries = {}, music = {} }, { sfx = {}, music = {} }
  local warnings, infos, events, hooks = {}, {}, {}, {}
  local mod = {
    content = {
      sfx = {
        override = function(_, id, def) overrides.sfx[id] = def.file end,
        register = function(_, id, def) registered.sfx[id] = def.file or def end,
      },
      cries = {
        override = function(_, id, def) overrides.cries[id] = def.file end,
        register = function(_, id, def) registered.cries = registered.cries or {}; registered.cries[id] = def.file or def end,
      },
      music = {
        override = function(_, id, def) overrides.music[id] = def.file end,
        register = function(_, id, def) registered.music[id] = def.file end,
      },
    },
    assets = {
      path = function(_, relative) return "mods/sound_effect_replacer/" .. relative end,
    },
    events = {
      on = function(_, name, callback) events[name] = callback end,
    },
    game = gameFacade,
    find = function(id)
      return foundMods and foundMods[id] or nil
    end,
    hooks = {
      wrap = function(_, name, callback, priority)
        hooks[name] = { callback = callback, priority = priority }
      end,
    },
    log = {
      warn = function(_, fmt, ...) warnings[#warnings + 1] = string.format(fmt, ...) end,
      info = function(_, fmt, ...) infos[#infos + 1] = string.format(fmt, ...) end,
    },
  }

  function mod:info(relative)
    if files[relative] then return { type = "file", size = #files[relative] } end
    local prefix = relative .. "/"
    for path in pairs(files) do
      if path:sub(1, #prefix) == prefix then return { type = "directory" } end
    end
    return nil
  end

  function mod:list(relative)
    local prefix, seen, names = relative .. "/", {}, {}
    for path in pairs(files) do
      if path:sub(1, #prefix) == prefix then
        local name = path:sub(#prefix + 1):match("^([^/]+)")
        if name and not seen[name] then
          seen[name] = true
          names[#names + 1] = name
        end
      end
    end
    table.sort(names)
    return names
  end

  function mod:read(relative) return files[relative] end

  local mainPath = os.getenv("SOUND_EFFECT_REPLACER_MAIN")
    or (root .. "/main.lua")
  local entry, err = loadfile(mainPath)
  assert(entry, err)
  local init = entry()
  assert(type(init) == "function")
  init(mod)
  return overrides, registered, warnings, infos, events, hooks
end

local vorbis = "OggS\0\2\1vorbis"
local opus = "OggS\0\2OpusHead"

local function registeredIdFor(records, path)
  for id, value in pairs(records or {}) do
    if value == path then return id end
  end
  return nil
end

local gen1, gen1Registered, gen1Warnings, _, gen1Events, gen1Hooks = run("red", {
  ["assets/General Sound Effects/Battle Damage/general.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Damage/exact.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Press_AB/unsupported.oga"] = opus,
  ["assets/Specific Sound Effects/Named Effects/Start_Menu/wrong-format.wav"] = "not a wav",
  ["assets/Specific Sound Effects/Named Effects/Save/unsupported.m4a"] = "not a supported runtime format",
  ["assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Pokemon Cries/PIKACHU/pikachu.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg"] = vorbis,
})

-- Exact Named Effects replace General folders in the active routing table.
-- Legacy paths remain accepted for this migration release, but register private
-- playlist IDs rather than replacing base game definitions directly.
local gen1Damage = registeredIdFor(gen1Registered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Damage/exact.ogg")
local gen1Move = registeredIdFor(gen1Registered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg")
local gen1Cry = registeredIdFor(gen1Registered.cries,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Pokemon Cries/PIKACHU/pikachu.ogg")
local gen1Progress = registeredIdFor(gen1Registered.music,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg")
local gen1Complete = registeredIdFor(gen1Registered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg")
assert(gen1.sfx.Damage == nil and gen1Damage, "exact named effect must route through a registered playlist")
assert(gen1.sfx.Press_AB == nil, "Ogg Opus exact effect must be skipped")
assert(gen1.sfx.Start_Menu == nil, "header-mismatched WAV must be skipped so native audio remains")
assert(gen1.sfx.Save == nil, "unsupported extension must be skipped so native audio remains")
assert(gen1Move and gen1Cry and gen1Progress and gen1Complete,
  "move, cry, and evolution playlists must register their selected variants")
assert(gen1Events["battle.move_used"], "Move Sounds must subscribe to battle.move_used")
assert(gen1Events["pokemon.evolved"], "Gen 1 Evolution Complete must subscribe to pokemon.evolved")
assert(gen1Hooks["evolution.check"], "Gen 1 Evolution In Progress must wrap evolution.check")
assert(#gen1Warnings >= 3, "startup-detectable audio problems must produce actionable warnings")
assert(gen1Events["world.stepped"], "audio diagnostics must defer a text box until overworld control")
gen1Events["world.stepped"]({ mapId = "PALLET_TOWN" })
assert(#shownTextBoxes == 1 and shownTextBoxes[1].game == gameFacade,
  "first overworld step must queue exactly one standard text box")
assert(shownTextBoxes[1].text == ("SFX REPLACER:" .. string.char(10)
  .. "3 AUDIO ISSUES." .. string.char(10) .. "CHECK THE MOD LOG."),
  "text box must summarize the detected startup diagnostics")
gen1Events["world.stepped"]({ mapId = "PALLET_TOWN" })
assert(#shownTextBoxes == 1, "diagnostic text box must not repeat on later steps")

-- Every extension decoded by the LÖVE 11.5 runtime bundled with Gen1Recomp
-- 0.2.3 must survive the mod's discovery filter. Runtime decoding itself is
-- verified against that official build; this harness verifies the Lua routing.
local runtimeExtensions = {
  "mp3", "wav", "flac", "ogg", "oga", "ogv",
  "699", "abc", "amf", "ams", "dbm", "dmf", "dsm", "far", "it",
  "j2b", "mdl", "med", "mid", "mod", "mt2", "mtm", "okt", "pat",
  "psm", "s3m", "stm", "ult", "umx", "xm",
}
local runtimeCueIds = {
  "Ball_Poof", "Ball_Toss", "Battle_09", "Battle_0B", "Battle_0C",
  "Battle_0D", "Battle_0E", "Battle_0F", "Battle_12", "Battle_13",
  "Battle_14", "Battle_16", "Battle_17", "Battle_18", "Battle_19",
  "Battle_1B", "Battle_1C", "Battle_1E", "Battle_20", "Battle_21",
  "Battle_22", "Battle_23", "Battle_24", "Battle_25", "Battle_29",
  "Battle_2A", "Battle_2B", "Battle_2E", "Battle_2F", "Battle_31",
}
-- Gen 1 progress changes only the pending evolution scene’s selected special song.
local evolveGame = { data = { audio = {} } }
local outcome = gen1Hooks["evolution.check"].callback(function() return true end,
  evolveGame, { species = "PIKACHU" }, { species = "RAICHU" }, { kind = "levelup" })
assert(outcome == true)
assert(evolveGame.data.audio.special.evolution == gen1Progress)

local damageSource = latestSound.play({ audio = {} }, "Damage")
assert(damageSource and damageSource.custom == gen1Damage,
  "exact named playlist must win over its general folder")
local crySource = latestSound.playCry({ audio = {} }, "PIKACHU")
assert(crySource and crySource.custom == gen1Cry,
  "cry playlist must route through its registered active variant")

gen1Events["battle.move_used"]({
  battle = { data = { generation = 1 }, animationsOn = function() return true end },
  move = { id = "THUNDERBOLT" },
})
assert(#played == 3 and played[3].id == gen1Move)

gen1Events["pokemon.evolved"]({ mon = { species = "RAICHU" } })
assert(#played == 4 and played[4].id == gen1Complete)

-- The discovery filter remains deliberately broad for the audio formats
-- accepted by the bundled runtime, now under the generation-specific tree.
local formatFiles = {}
local formatProbeBytes = {
  ogg = vorbis, oga = vorbis, ogv = vorbis,
  wav = "RIFF\0\0\0\0WAVE", flac = "fLaC",
}
for index, ext in ipairs(runtimeExtensions) do
  local cue = runtimeCueIds[index]
  formatFiles["assets/Gen 1/Specific Sound Effects/Named Effects/" .. cue .. "/probe." .. ext]
    = formatProbeBytes[ext] or "probe"
end
local _, formatRegistered = run("red", formatFiles)
for index, ext in ipairs(runtimeExtensions) do
  local cue = runtimeCueIds[index]
  assert(registeredIdFor(formatRegistered.sfx,
      "mods/sound_effect_replacer/assets/Gen 1/Specific Sound Effects/Named Effects/" .. cue .. "/probe." .. ext),
    "Runtime extension ." .. ext .. " must be accepted for " .. cue)
end

local gold, goldRegistered, _, _, goldEvents, goldHooks = run("gold", {
  ["assets/General Sound Effects/Battle Damage/general.ogg"] = vorbis,
  ["assets/General Sound Effects/Healing Machine/heal.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future-sight.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg"] = vorbis,
})
local goldDamage = registeredIdFor(goldRegistered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg")
local goldHeal = registeredIdFor(goldRegistered.music,
  "mods/sound_effect_replacer/assets/General Sound Effects/Healing Machine/heal.ogg")
local goldMove = registeredIdFor(goldRegistered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future-sight.ogg")
local goldCry = registeredIdFor(goldRegistered.cries,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg")
local goldProgress = registeredIdFor(goldRegistered.music,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg")
local goldComplete = registeredIdFor(goldRegistered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg")
assert(gold.sfx.Sfx_Damage == nil and goldDamage and goldHeal and goldMove and goldCry
    and goldProgress and goldComplete,
  "Gold must register each active playlist without overwriting base definitions")
assert(goldEvents["battle.move_used"], "Gold Move Sounds must subscribe to battle.move_used")
assert(goldHooks["evolution.check"] == nil and goldHooks["music.select"],
  "Gold evolution progress must use the targeted music-selection playlist")
assert(goldHooks["music.select"].callback(function(song) return song end, "Music_HealPokemon", {}) == goldHeal)
assert(goldHooks["music.select"].callback(function(song) return song end, "Music_Evolution", {}) == goldProgress)
assert(latestSound.play({ audio = {} }, "Sfx_Damage").custom == goldDamage)
assert(latestSound.playCry({ audio = {} }, "CHIKORITA").custom == goldCry)

goldEvents["battle.move_used"]({
  battle = { data = { generation = 2 }, animationsOn = function() return true end },
  move = { id = "FUTURE_SIGHT" },
})
assert(#played == 3 and played[3].id == goldMove)

local silver, silverRegistered, _, _, silverEvents, silverHooks = run("silver", {
  ["assets/General Sound Effects/Battle Damage/general.ogg"] = vorbis,
  ["assets/General Sound Effects/Healing Machine/heal.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg"] = vorbis,
})
assert(silver.sfx.Sfx_Damage == nil
    and registeredIdFor(silverRegistered.sfx,
      "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg")
    and registeredIdFor(silverRegistered.music,
      "mods/sound_effect_replacer/assets/General Sound Effects/Healing Machine/heal.ogg"),
  "Silver must select the Gen 2 named-effect and healing-jingle playlists")
assert(registeredIdFor(silverRegistered.sfx,
      "mods/sound_effect_replacer/assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg")
    and registeredIdFor(silverRegistered.cries,
      "mods/sound_effect_replacer/assets/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg"),
  "Silver must select the Gen 2 move-sound and cry playlists")
assert(registeredIdFor(silverRegistered.music,
      "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg")
    and registeredIdFor(silverRegistered.sfx,
      "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg"),
  "Silver must select the Gen 2 evolution playlists")
assert(silverEvents["battle.move_used"] and silverHooks["evolution.check"] == nil and silverHooks["music.select"],
  "Silver must install the Gen 2 move and music playlist routes")

local crystal, crystalRegistered, _, crystalInfos, crystalEvents, crystalHooks = run("crystal", {
  ["assets/Gen 2/General Sound Effects/Battle Damage/general.ogg"] = vorbis,
  ["assets/Gen 2/General Sound Effects/Healing Machine/heal.ogg"] = vorbis,
  ["assets/Gen 2/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg"] = vorbis,
  ["assets/Gen 2/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future-sight.ogg"] = vorbis,
  ["assets/Gen 2/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg"] = vorbis,
  ["assets/Gen 2/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg"] = vorbis,
  ["assets/Gen 2/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg"] = vorbis,
})
local crystalDamage = registeredIdFor(crystalRegistered.sfx,
  "mods/sound_effect_replacer/assets/Gen 2/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg")
local crystalHeal = registeredIdFor(crystalRegistered.music,
  "mods/sound_effect_replacer/assets/Gen 2/General Sound Effects/Healing Machine/heal.ogg")
local crystalMove = registeredIdFor(crystalRegistered.sfx,
  "mods/sound_effect_replacer/assets/Gen 2/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future-sight.ogg")
local crystalCry = registeredIdFor(crystalRegistered.cries,
  "mods/sound_effect_replacer/assets/Gen 2/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg")
assert(crystal.sfx.Sfx_Damage == nil and crystalDamage and crystalHeal and crystalMove and crystalCry,
  "Crystal must register its shared Gen 2 playlists from the canonical asset tree")
assert(crystalEvents["battle.move_used"] and crystalHooks["evolution.check"] == nil and crystalHooks["music.select"],
  "Crystal must install the Gen 2 move and music playlist routes")
assert(crystalHooks["music.select"].callback(function(song) return song end, "Music_HealPokemon", {}) == crystalHeal,
  "Crystal must select the healing-machine music playlist")
assert(table.concat(crystalInfos, "\n"):find("Gen 2 (Gold/Silver/Crystal)", 1, true),
  "Crystal logs must use the Crystal-inclusive Gen 2 label")
crystalEvents["battle.move_used"]({
  battle = { data = { generation = 2 }, animationsOn = function() return true end },
  move = { id = "FUTURE_SIGHT" },
})
assert(#played == 1 and played[1].id == crystalMove,
  "Crystal must play the selected shared Gen 2 move playlist")

-- The canonical Gen 2 tree is independent of Gen 1 and takes priority over a
-- legacy folder. Music-backed sound-effect categories rotate through the same
-- narrow music.select bridge used for Gen 2 healing/evolution cues.
local _, canonicalGen2Registered, _, _, _, canonicalGen2Hooks = run("gold", {
  ["assets/Gen 2/Specific Sound Effects/Named Effects/Sfx_Damage/canonical.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Sfx_Damage/legacy.ogg"] = vorbis,
  ["assets/Gen 2/General Sound Effects/Healing Machine/01-heal.ogg"] = vorbis,
  ["assets/Gen 2/General Sound Effects/Healing Machine/02-heal.ogg"] = vorbis,
})
local canonicalDamage = registeredIdFor(canonicalGen2Registered.sfx,
  "mods/sound_effect_replacer/assets/Gen 2/Specific Sound Effects/Named Effects/Sfx_Damage/canonical.ogg")
local canonicalHealA = registeredIdFor(canonicalGen2Registered.music,
  "mods/sound_effect_replacer/assets/Gen 2/General Sound Effects/Healing Machine/01-heal.ogg")
local canonicalHealB = registeredIdFor(canonicalGen2Registered.music,
  "mods/sound_effect_replacer/assets/Gen 2/General Sound Effects/Healing Machine/02-heal.ogg")
assert(canonicalDamage and canonicalHealA and canonicalHealB
    and not registeredIdFor(canonicalGen2Registered.sfx,
      "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Sfx_Damage/legacy.ogg"),
  "Gen 2 folders must take precedence over legacy replacements")
assert(latestSound.play({ audio = {} }, "Sfx_Damage").custom == canonicalDamage)
assert(canonicalGen2Hooks["music.select"].callback(function(song) return song end, "Music_HealPokemon", {}) == canonicalHealA
    and canonicalGen2Hooks["music.select"].callback(function(song) return song end, "Music_HealPokemon", {}) == canonicalHealB,
  "multiple Gen 2 music-backed cue files must rotate in alphabetical order")

local yellow, yellowRegistered = run("yellow", {
  ["assets/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg"] = vorbis,
})
local yellowPika = registeredIdFor(yellowRegistered.sfx,
  "mods/sound_effect_replacer/assets/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg")
assert(yellowPika, "Yellow voice clip must register an active playlist variant")
local customClip = latestSound.playPikaCry({ audio = { pikaCries = 42 } }, 11)
assert(customClip and customClip.custom == yellowPika)
assert(#nativePikaCalls == 0, "Assigned Yellow clip must bypass the native PCM path")
local nativeClip = latestSound.playPikaCry({ audio = { pikaCries = 42 } }, 12)
assert(nativeClip and nativeClip.native == 12)
assert(#nativePikaCalls == 1 and nativePikaCalls[1].index == 12)

-- Hot reload reruns an entry chunk after owner-managed hooks/events are
-- removed, but direct Sound-table mutations survive. The same Sound module
-- must retain exactly one wrapper instead of nesting native fallbacks.
local pikaWrapper = latestSound.playPikaCry
local yellowFiles = {
  ["assets/Gen 1/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg"] = vorbis,
}
local _, yellowReloaded = run("yellow", yellowFiles, nil, true)
assert(latestSound.playPikaCry == pikaWrapper and latestSound._sfxReplacerPikaWrapped == true,
  "Pikachu wrapper must not be replaced or nested during same-module reinitialization")
local reloadedCustom = latestSound.playPikaCry({ audio = { pikaCries = 42 } }, 11)
local reloadedPika = registeredIdFor(yellowReloaded.sfx,
  "mods/sound_effect_replacer/assets/Gen 1/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg")
assert(reloadedPika and reloadedCustom and reloadedCustom.custom == reloadedPika,
  "reinitialized Pikachu wrapper must use the current replacement clip table")
local reloadedNative = latestSound.playPikaCry({ audio = { pikaCries = 42 } }, 12)
assert(reloadedNative and reloadedNative.native == 12
  and #nativePikaCalls == 1 and nativePikaCalls[1].index == 12,
  "reinitialized Pikachu wrapper must call the native fallback exactly once")

-- Easy Custom Music v2 accepts multiple files in one target folder. Sound
-- Effect Replacer uses the same Gen 1/Gen 2 layout and advances its narrow
-- sound playlist once per playback request; the legacy path must not win when
-- a matching generation-specific folder is populated.
local _, multiRegistered = run("red", {
  ["assets/Gen 1/Specific Sound Effects/Named Effects/Damage/alpha.ogg"] = vorbis,
  ["assets/Gen 1/Specific Sound Effects/Named Effects/Damage/bravo.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Damage/legacy.ogg"] = vorbis,
})
local alpha = registeredIdFor(multiRegistered.sfx,
  "mods/sound_effect_replacer/assets/Gen 1/Specific Sound Effects/Named Effects/Damage/alpha.ogg")
local bravo = registeredIdFor(multiRegistered.sfx,
  "mods/sound_effect_replacer/assets/Gen 1/Specific Sound Effects/Named Effects/Damage/bravo.ogg")
assert(alpha and bravo and not registeredIdFor(multiRegistered.sfx,
    "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Damage/legacy.ogg"),
  "generation-specific files must register in preference to legacy layout files")
assert(latestSound.play({ audio = {} }, "Damage").custom == alpha
    and latestSound.play({ audio = {} }, "Damage").custom == bravo
    and latestSound.play({ audio = {} }, "Damage").custom == alpha,
  "multiple sound files must cycle in deterministic folder order")

-- PotatoVoxel is optional: no detection means no startup SFX is registered
-- or played, preserving ordinary Sound Effect Replacer behavior.
local _, absentRegistered, _, _, absentEvents = run("red", {})
assert(absentRegistered.sfx.SFX_SOUND_EFFECT_REPLACER_POTATO_VOXEL_DETECTED == nil)
assert(absentEvents["game.ready"] == nil)

-- A loaded PotatoVoxel handle enables the original Lua-authored chip cue.
-- The event handler must use the live game data and play exactly once even if
-- game.ready is re-emitted by a development hot reload.
local _, potatoRegistered, _, _, potatoEvents = run("gold", {}, {
  potato_voxel = { id = "potato_voxel", version = "1.7.11", exports = {} },
})
local potatoCue = potatoRegistered.sfx.SFX_SOUND_EFFECT_REPLACER_POTATO_VOXEL_DETECTED
assert(type(potatoCue) == "table" and potatoCue.chip and potatoCue.chip.authored,
  "PotatoVoxel cue must be registered as a ChipAsm SFX")
local potatoProgram = potatoCue.chip.authored
assert(potatoProgram.engine == 1 and #potatoProgram.channels == 1,
  "PotatoVoxel cue must use the intended engine-1 square channel program")
local potatoRows = potatoProgram.channels[1].program
assert(potatoRows[1].duty == 2
  and potatoRows[2].squareNote.frequency == 0x74C
  and potatoRows[2].squareNote.len == 3
  and potatoRows[3].squareNote.frequency == 0x76F
  and potatoRows[3].squareNote.len == 4,
  "PotatoVoxel cue must retain its original two-part upward confirmation shape")
assert(latestChipSfx == potatoProgram, "PotatoVoxel cue must be assembled through ChipAsm.sfx")
assert(potatoEvents["game.ready"], "PotatoVoxel detection must subscribe to game.ready")
local startupGame = { data = { audio = { sfx = {} } } }
potatoEvents["game.ready"]({ game = startupGame })
potatoEvents["game.ready"]({ game = startupGame })
assert(#played == 1 and played[1].data == startupGame.data
  and played[1].id == "SFX_SOUND_EFFECT_REPLACER_POTATO_VOXEL_DETECTED")

print("sound effect replacer audio diagnostics harness: passed")
