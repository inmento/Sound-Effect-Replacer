-- Isolated regression harness for Sound Effect Replacer 0.3.2.
-- Exercises the public mod-object surface without starting Gen1Recomp.

local activeGame = "red"
local played = {}
local nativePikaCalls = {}
local latestSound = nil
local latestChipSfx = nil
local gameFacade = { data = nil }

package.preload["src.core.GameVersion"] = function()
  return { get = function() return activeGame end }
end
package.preload["src.core.Sound"] = function()
  local sound = {
    play = function(data, id)
      played[#played + 1] = { data = data, id = id }
      return { custom = id }
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
package.preload["src.audio.ChipAsm"] = function()
  return {
    sfx = function(spec)
      latestChipSfx = spec
      return { chip = { authored = spec } }
    end,
  }
end

local function run(game, files, foundMods)
  activeGame = game
  played = {}
  nativePikaCalls = {}
  gameFacade.data = { audio = {} }
  latestChipSfx = nil
  package.loaded["src.core.GameVersion"] = nil
  package.loaded["src.core.Sound"] = nil
  package.loaded["src.core.Game"] = nil
  package.loaded["src.audio.ChipAsm"] = nil

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
    or "/home/ubuntu/sound_effect_replacement/main.lua"
  local entry, err = loadfile(mainPath)
  assert(entry, err)
  local init = entry()
  assert(type(init) == "function")
  init(mod)
  return overrides, registered, warnings, infos, events, hooks
end

local vorbis = "OggS\0\2\1vorbis"
local opus = "OggS\0\2OpusHead"

local gen1, gen1Registered, gen1Warnings, _, gen1Events, gen1Hooks = run("red", {
  ["assets/General Sound Effects/Battle Damage/general.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Damage/exact.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Named Effects/Press_AB/unsupported.oga"] = opus,
  ["assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Pokemon Cries/PIKACHU/pikachu.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg"] = vorbis,
  ["assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg"] = vorbis,
})

-- Exact Named Effects load after General Sound Effects and therefore win.
assert(gen1.sfx.Damage == "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Damage/exact.ogg")
assert(gen1.sfx.Press_AB == nil, "Ogg Opus exact effect must be skipped")
assert(gen1Registered.sfx.SFX_SOUND_EFFECT_REPLACER_MOVE_THUNDERBOLT
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg")
assert(gen1.cries.PIKACHU
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Pokemon Cries/PIKACHU/pikachu.ogg")
assert(gen1Registered.music.Music_SOUND_EFFECT_REPLACER_EVOLUTION_PROGRESS
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg")
assert(gen1Registered.sfx.SFX_SOUND_EFFECT_REPLACER_EVOLUTION_COMPLETE
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg")
assert(gen1Events["battle.move_used"], "Move Sounds must subscribe to battle.move_used")
assert(gen1Events["pokemon.evolved"], "Gen 1 Evolution Complete must subscribe to pokemon.evolved")
assert(gen1Hooks["evolution.check"], "Gen 1 Evolution In Progress must wrap evolution.check")
assert(#gen1Warnings >= 1, "Ogg Opus must produce an actionable warning")

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
local formatFiles = {}
for index, ext in ipairs(runtimeExtensions) do
  local cue = runtimeCueIds[index]
  formatFiles["assets/Specific Sound Effects/Named Effects/" .. cue .. "/probe." .. ext] = "probe"
end
local formatOverrides = run("red", formatFiles)
for index, ext in ipairs(runtimeExtensions) do
  local cue = runtimeCueIds[index]
  assert(formatOverrides.sfx[cue]
    == "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/" .. cue .. "/probe." .. ext,
    "Runtime extension ." .. ext .. " must be accepted for " .. cue)
end

-- Gen 1 progress changes only the pending evolution scene’s selected special song.
local evolveGame = { data = { audio = {} } }
local outcome = gen1Hooks["evolution.check"].callback(function() return true end,
  evolveGame, { species = "PIKACHU" }, { species = "RAICHU" }, { kind = "levelup" })
assert(outcome == true)
assert(evolveGame.data.audio.special.evolution == "Music_SOUND_EFFECT_REPLACER_EVOLUTION_PROGRESS")

gen1Events["battle.move_used"]({
  battle = { data = { generation = 1 }, animationsOn = function() return true end },
  move = { id = "THUNDERBOLT" },
})
assert(#played == 1 and played[1].id == "SFX_SOUND_EFFECT_REPLACER_MOVE_THUNDERBOLT")

gen1Events["pokemon.evolved"]({ mon = { species = "RAICHU" } })
assert(#played == 2 and played[2].id == "SFX_SOUND_EFFECT_REPLACER_EVOLUTION_COMPLETE")

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
assert(gold.sfx.Sfx_Damage == "mods/sound_effect_replacer/assets/Specific Sound Effects/Named Effects/Sfx_Damage/exact.ogg")
assert(gold.music.Music_HealPokemon
  == "mods/sound_effect_replacer/assets/General Sound Effects/Healing Machine/heal.ogg")
assert(goldRegistered.sfx.SFX_SOUND_EFFECT_REPLACER_MOVE_THUNDERBOLT
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Move Sounds/THUNDERBOLT/thunderbolt.ogg")
assert(goldRegistered.sfx.SFX_SOUND_EFFECT_REPLACER_MOVE_FUTURE_SIGHT
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Move Sounds/FUTURE_SIGHT/future-sight.ogg")
assert(gold.cries.CHIKORITA
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Pokemon Cries/CHIKORITA/chikorita.ogg")
assert(gold.music.Music_Evolution
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution In Progress/evolving.ogg")
assert(gold.sfx.Sfx_Evolved
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Evolution/Evolution Complete/complete.ogg")
assert(goldEvents["battle.move_used"], "Gold Move Sounds must subscribe to battle.move_used")
assert(goldHooks["evolution.check"] == nil, "Gold evolution progress uses Music_Evolution directly")

goldEvents["battle.move_used"]({
  battle = { data = { generation = 2 }, animationsOn = function() return true end },
  move = { id = "FUTURE_SIGHT" },
})
assert(#played == 1 and played[1].id == "SFX_SOUND_EFFECT_REPLACER_MOVE_FUTURE_SIGHT")

local yellow, yellowRegistered = run("yellow", {
  ["assets/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg"] = vorbis,
})
assert(yellowRegistered.sfx.SFX_SOUND_EFFECT_REPLACER_PIKACHU_PCM_11
  == "mods/sound_effect_replacer/assets/Specific Sound Effects/Yellow Pikachu Voice Clips/11/battle.ogg")
local customClip = latestSound.playPikaCry({ audio = { pikaCries = 42 } }, 11)
assert(customClip and customClip.custom == "SFX_SOUND_EFFECT_REPLACER_PIKACHU_PCM_11")
assert(#nativePikaCalls == 0, "Assigned Yellow clip must bypass the native PCM path")
local nativeClip = latestSound.playPikaCry({ audio = { pikaCries = 42 } }, 12)
assert(nativeClip and nativeClip.native == 12)
assert(#nativePikaCalls == 1 and nativePikaCalls[1].index == 12)

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

print("sound effect replacer 0.3.2 harness: passed")
