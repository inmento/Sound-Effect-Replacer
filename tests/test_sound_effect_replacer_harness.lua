-- Isolated regression harness for Sound Effect Replacer.
-- Exercises the public mod-object surface used by main.lua without game assets.

local activeGame = "red"
package.preload["src.core.GameVersion"] = function()
  return { get = function() return activeGame end }
end

local function run(game, files)
  activeGame = game
  package.loaded["src.core.GameVersion"] = nil

  local overrides, warnings, infos = {}, {}, {}
  local mod = {
    content = {
      sfx = {
        override = function(_, id, def)
          overrides[id] = def.file
        end,
      },
    },
    assets = {
      path = function(_, relative)
        return "mods/sound_effect_replacer/" .. relative
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
        local name = path:sub(#prefix + 1)
        if not name:find("/", 1, true) and not seen[name] then
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
  return overrides, warnings, infos
end

local vorbis = "OggS\0\2\1vorbis"
local opus = "OggS\0\2OpusHead"

local gen1, gen1Warnings = run("red", {
  ["assets/Battle Damage/damage.ogg"] = vorbis,
  ["assets/Battle Faint/faint.ogg"] = vorbis,
  ["assets/Menu Confirm/unsupported.ogg"] = opus,
  ["assets/Evolution Success/evolution.ogg"] = vorbis,
  ["assets/Move Tackle/tackle.ogg"] = vorbis,
})
assert(gen1.Damage == "mods/sound_effect_replacer/assets/Battle Damage/damage.ogg")
assert(gen1.Faint_Fall and gen1.Faint_Thud, "Gen 1 faint folder must replace both cues")
assert(gen1.Press_AB == nil, "Ogg Opus must be skipped")
assert(gen1["Sfx_Damage"] == nil, "Gold SFX must not load on Gen 1")
assert(gen1["Sfx_Evolved"] == nil, "Gold-only evolution SFX must not load on Gen 1")
assert(#gen1Warnings >= 1, "Ogg Opus must produce a warning")

local gold = run("gold", {
  ["assets/Battle Damage/damage.ogg"] = vorbis,
  ["assets/Evolution Success/evolution.ogg"] = vorbis,
  ["assets/Menu Confirm/confirm.ogg"] = vorbis,
  ["assets/Healing Machine/heal.ogg"] = vorbis,
  ["assets/Move Tackle/tackle.ogg"] = vorbis,
})
assert(gold.Sfx_Damage == "mods/sound_effect_replacer/assets/Battle Damage/damage.ogg")
assert(gold.Sfx_Evolved == "mods/sound_effect_replacer/assets/Evolution Success/evolution.ogg")
assert(gold.Sfx_ReadText == "mods/sound_effect_replacer/assets/Menu Confirm/confirm.ogg")
assert(gold.Sfx_HealBell == nil, "Healing Machine must not map to an unrelated Gold move sound")
assert(gold.Sfx_Tackle == "mods/sound_effect_replacer/assets/Move Tackle/tackle.ogg")
assert(gold.Damage == nil, "Gen 1 SFX must not load on Gold")

print("sound effect replacer harness: passed")
