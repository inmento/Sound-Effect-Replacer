-- Isolated regression harness for Sound Effect Replacer.
-- Exercises the public mod-object surface used by main.lua without game assets.

local activeGame = "red"
local played = {}

package.preload["src.core.GameVersion"] = function()
  return { get = function() return activeGame end }
end

package.preload["src.core.Sound"] = function()
  return {
    play = function(data, id)
      played[#played + 1] = { data = data, id = id }
    end,
  }
end

local function run(game, files)
  activeGame = game
  played = {}
  package.loaded["src.core.GameVersion"] = nil
  package.loaded["src.core.Sound"] = nil

  local overrides, registered, warnings, infos, listeners = {}, {}, {}, {}, {}
  local mod = {
    content = {
      sfx = {
        override = function(_, id, def)
          overrides[id] = def.file
        end,
        register = function(_, id, def)
          registered[id] = def.file
        end,
      },
    },
    assets = {
      path = function(_, relative)
        return "mods/sound_effect_replacer/" .. relative
      end,
    },
    events = {
      on = function(_, name, callback)
        listeners[name] = callback
      end,
    },
    log = {
      warn = function(_, fmt, ...) warnings[#warnings + 1] = string.format(fmt, ...) end,
      info = function(_, fmt, ...) infos[#infos + 1] = string.format(fmt, ...) end,
    },
  }

  function mod:info(relative)
    if files[relative] then
      return { type = "file", size = #files[relative] }
    end
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
        -- The real `mod:list` returns immediate files and directories. A test
        -- fixture stores only leaf files, so synthesize the immediate segment.
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

  local entry, err = loadfile("/home/ubuntu/sound_effect_replacement/main.lua")
  assert(entry, err)
  local init = entry()
  assert(type(init) == "function")
  init(mod)
  return overrides, registered, warnings, infos, listeners
end

local vorbis = "OggS\0\2\1vorbis"
local opus = "OggS\0\2OpusHead"

local gen1, gen1Registered, gen1Warnings, _, gen1Listeners = run("red", {
  ["assets/Battle Damage/damage.ogg"] = vorbis,
  ["assets/Battle Faint/faint.ogg"] = vorbis,
  ["assets/Menu Confirm/unsupported.ogg"] = opus,
  ["assets/Evolution Success/evolution.ogg"] = vorbis,
  ["assets/Move Tackle/tackle.ogg"] = vorbis,
  ["assets/Move Sounds/Gen 1/THUNDERBOLT/thunderbolt.ogg"] = vorbis,
  ["assets/Move Sounds/Gold/THUNDERBOLT/gold-thunderbolt.ogg"] = vorbis,
  ["assets/Move Sounds/Gen 1/PSYCHIC/unsupported.ogg"] = opus,
})
assert(gen1.Damage == "mods/sound_effect_replacer/assets/Battle Damage/damage.ogg")
assert(gen1.Faint_Fall and gen1.Faint_Thud, "Gen 1 faint folder must replace both cues")
assert(gen1.Press_AB == nil, "Ogg Opus must be skipped")
assert(gen1["Sfx_Damage"] == nil, "Gold SFX must not load on Gen 1")
assert(gen1["Sfx_Evolved"] == nil, "Gold-only evolution SFX must not load on Gen 1")
assert(gen1Registered.SFX_SOUND_EFFECT_REPLACER_MOVE_THUNDERBOLT
  == "mods/sound_effect_replacer/assets/Move Sounds/Gen 1/THUNDERBOLT/thunderbolt.ogg")
assert(gen1Registered.SFX_SOUND_EFFECT_REPLACER_MOVE_PSYCHIC == nil,
  "Ogg Opus move file must be skipped")
assert(gen1Listeners["battle.move_used"], "Move Sounds must subscribe to battle.move_used")
assert(#gen1Warnings >= 2, "Ogg Opus general and move files must produce warnings")

gen1Listeners["battle.move_used"]({
  battle = { data = { generation = 1 }, animationsOn = function() return true end },
  move = { id = "THUNDERBOLT" },
})
assert(#played == 1 and played[1].id == "SFX_SOUND_EFFECT_REPLACER_MOVE_THUNDERBOLT",
  "Gen 1 custom move sound must play once when the move is used")

gen1Listeners["battle.move_used"]({
  battle = { data = { generation = 1 }, animationsOn = function() return false end },
  move = { id = "THUNDERBOLT" },
})
assert(#played == 1, "Custom move sound must respect disabled battle animations")

local gold, goldRegistered, _, _, goldListeners = run("gold", {
  ["assets/Battle Damage/damage.ogg"] = vorbis,
  ["assets/Evolution Success/evolution.ogg"] = vorbis,
  ["assets/Menu Confirm/confirm.ogg"] = vorbis,
  ["assets/Healing Machine/heal.ogg"] = vorbis,
  ["assets/Move Tackle/tackle.ogg"] = vorbis,
  ["assets/Move Sounds/Gen 1/THUNDERBOLT/gen1-thunderbolt.ogg"] = vorbis,
  ["assets/Move Sounds/Gold/THUNDERBOLT/gold-thunderbolt.ogg"] = vorbis,
  ["assets/Move Sounds/Gold/FUTURE_SIGHT/future-sight.ogg"] = vorbis,
})
assert(gold.Sfx_Damage == "mods/sound_effect_replacer/assets/Battle Damage/damage.ogg")
assert(gold.Sfx_Evolved == "mods/sound_effect_replacer/assets/Evolution Success/evolution.ogg")
assert(gold.Sfx_ReadText == "mods/sound_effect_replacer/assets/Menu Confirm/confirm.ogg")
assert(gold.Sfx_HealBell == nil, "Healing Machine must not map to an unrelated Gold move sound")
assert(gold.Sfx_Tackle == "mods/sound_effect_replacer/assets/Move Tackle/tackle.ogg")
assert(gold.Damage == nil, "Gen 1 SFX must not load on Gold")
assert(goldRegistered.SFX_SOUND_EFFECT_REPLACER_MOVE_THUNDERBOLT
  == "mods/sound_effect_replacer/assets/Move Sounds/Gold/THUNDERBOLT/gold-thunderbolt.ogg")
assert(goldRegistered.SFX_SOUND_EFFECT_REPLACER_MOVE_FUTURE_SIGHT
  == "mods/sound_effect_replacer/assets/Move Sounds/Gold/FUTURE_SIGHT/future-sight.ogg")
assert(goldListeners["battle.move_used"], "Gold Move Sounds must subscribe to battle.move_used")

goldListeners["battle.move_used"]({
  battle = { data = { generation = 2 }, animationsOn = function() return true end },
  move = { id = "FUTURE_SIGHT" },
})
assert(#played == 1 and played[1].id == "SFX_SOUND_EFFECT_REPLACER_MOVE_FUTURE_SIGHT",
  "Gold-only move must use the Gold folder assignment")

print("sound effect replacer harness: passed")
