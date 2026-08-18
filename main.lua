-- Sound Effect Replacer 0.1.0
-- API 2 content mod for Red, Blue, Yellow, and Gold.
--
-- User audio is scanned once at startup from this mod's assets/<folder>/ tree.
-- Each folder can replace one or more native cues; place one compatible file in
-- each folder and restart Gen1Recomp after changing files.

return function(mod)
  local GameVersion = require("src.core.GameVersion")
  local playing = GameVersion.get()
  local isGold = playing == "gold"

  local SUPPORTED_FORMATS = {
    mp3 = true,
    ogg = true,
    wav = true,
    flac = true,
  }

  local MAX_RECOMMENDED_SFX_BYTES = 5 * 1024 * 1024

  -- Each friendly folder maps to the actual extracted sound IDs for the active
  -- cartridge. A folder may intentionally replace several closely related
  -- vanilla effects, such as both Gen 1 faint sounds or both directions of a
  -- warp animation.
  local REPLACEMENTS = {
    { folder = "Battle Damage",             gen1 = { "Damage" },                         gold = { "Sfx_Damage" } },
    { folder = "Battle Super Effective",    gen1 = { "Super_Effective" },                gold = { "Sfx_SuperEffective" } },
    { folder = "Battle Not Very Effective", gen1 = { "Not_Very_Effective" },             gold = { "Sfx_NotVeryEffective" } },
    { folder = "Battle Faint",              gen1 = { "Faint_Fall", "Faint_Thud" },      gold = { "Sfx_Faint" } },

    { folder = "Capture Throw",             gen1 = { "Ball_Toss" },                      gold = { "Sfx_ThrowBall" } },
    { folder = "Capture Success",           gen1 = { "Caught_Mon" },                     gold = { "Sfx_CaughtMon" } },
    { folder = "Level Up",                  gen1 = { "Level_Up" },                       gold = { "Sfx_LevelUp" } },
    -- Red/Blue/Yellow use the evolution music followed by the evolved
    -- Pokémon's cry, not a standalone evolution SFX. Gold exposes Sfx_Evolved.
    { folder = "Evolution Success",         gen1 = {},                                   gold = { "Sfx_Evolved" } },
    { folder = "Egg Hatch",                 gen1 = {},                                   gold = { "Sfx_EggHatch" } },

    { folder = "Item Received",             gen1 = { "Get_Item1", "Get_Item2" },        gold = { "Sfx_Item" } },
    { folder = "Key Item",                  gen1 = { "Get_Key_Item" },                   gold = { "Sfx_KeyItem" } },
    { folder = "Badge Received",            gen1 = { "Get_Item1" },                      gold = { "Sfx_GetBadge" } },
    { folder = "TM Received",               gen1 = { "Get_Item2" },                      gold = { "Sfx_GetTm" } },
    { folder = "Trade Complete",            gen1 = { "Trade_Machine" },                  gold = { "Sfx_GetTrademon", "Sfx_GiveTrademon" } },

    { folder = "Menu Open",                 gen1 = { "Start_Menu" },                     gold = { "Sfx_Menu" } },
    { folder = "Menu Confirm",              gen1 = { "Press_AB" },                       gold = { "Sfx_ReadText" } },
    { folder = "Menu Denied",               gen1 = { "Denied" },                         gold = { "Sfx_Wrong" } },
    { folder = "Save",                      gen1 = { "Save" },                           gold = { "Sfx_Save" } },

    { folder = "Enter Building",            gen1 = { "Go_Inside" },                      gold = { "Sfx_EnterDoor" } },
    { folder = "Exit Building",             gen1 = { "Go_Outside" },                     gold = { "Sfx_ExitBuilding" } },
    { folder = "Warp",                      gen1 = { "Teleport_Enter1", "Teleport_Enter2", "Teleport_Exit1", "Teleport_Exit2" }, gold = { "Sfx_WarpFrom", "Sfx_WarpTo" } },
    { folder = "Run",                       gen1 = { "Run" },                            gold = { "Sfx_Run" } },
    { folder = "Jump Ledge",                gen1 = { "Ledge" },                          gold = { "Sfx_JumpOverLedge" } },

    { folder = "PC Boot",                   gen1 = { "Turn_On_PC" },                     gold = { "Sfx_BootPc" } },
    { folder = "PC Shutdown",               gen1 = { "Turn_Off_PC" },                    gold = { "Sfx_ShutDownPc" } },
    { folder = "Pokemon Switch",            gen1 = { "Swap", "Switch" },                gold = { "Sfx_SwitchPokemon" } },

    { folder = "Heal HP",                   gen1 = { "Heal_HP" },                        gold = { "Sfx_Potion" } },
    { folder = "Heal Status",               gen1 = { "Heal_Ailment" },                   gold = { "Sfx_FullHeal" } },
    -- Gold's Pokémon Center recovery is a music jingle rather than an extracted SFX.
    { folder = "Healing Machine",           gen1 = { "Healing_Machine" },                gold = {} },

    { folder = "Move Tackle",               gen1 = {},                                   gold = { "Sfx_Tackle" } },
    { folder = "Move Scratch",              gen1 = {},                                   gold = { "Sfx_Scratch" } },
    { folder = "Move Water Gun",            gen1 = {},                                   gold = { "Sfx_WaterGun" } },
    { folder = "Move Psychic",              gen1 = { "Psychic_M" },                      gold = { "Sfx_Psychic" } },
    { folder = "Move Psybeam",              gen1 = { "Psybeam" },                        gold = { "Sfx_Psybeam" } },
    { folder = "Move Hyper Beam",           gen1 = {},                                   gold = { "Sfx_HyperBeam" } },
    { folder = "Move Vine Whip",            gen1 = { "Vine_Whip" },                      gold = { "Sfx_VineWhip" } },
    { folder = "Move Cut",                  gen1 = { "Cut" },                            gold = { "Sfx_Cut" } },
    { folder = "Move Fly",                  gen1 = { "Fly" },                            gold = { "Sfx_Fly" } },
    { folder = "Move Surf",                 gen1 = {},                                   gold = { "Sfx_Surf" } },
    { folder = "Move Strength",             gen1 = { "Push_Boulder" },                   gold = { "Sfx_Strength" } },

    { folder = "Status Poison",             gen1 = { "Poisoned" },                       gold = { "Sfx_Poison" } },
    { folder = "Pokedex Fanfare",           gen1 = { "Dex_Page_Added", "Pokedex_Rating" }, gold = { "Sfx_DexFanfareLessThan20", "Sfx_DexFanfare2049", "Sfx_DexFanfare5079", "Sfx_DexFanfare80109", "Sfx_DexFanfare140169", "Sfx_DexFanfare170199", "Sfx_DexFanfare200229", "Sfx_DexFanfare230Plus" } },
  }

  local function extension(name)
    return type(name) == "string" and name:match("^.+%.([^.]+)$")
  end

  -- LÖVE supports Ogg Vorbis. Many download/conversion tools produce Ogg Opus
  -- with the same .ogg extension, which fails only when LÖVE tries to open the
  -- source. Detect the Opus signature now so the player receives an actionable
  -- startup warning instead of a silent missing sound later.
  local function isOggOpus(relative, info)
    if not info or not info.size or info.size > MAX_RECOMMENDED_SFX_BYTES then
      return false
    end
    local ok, data = pcall(function() return mod:read(relative) end)
    return ok and type(data) == "string" and data:find("OpusHead", 1, true) ~= nil
  end

  local function firstCompatibleFile(relativeDir)
    local directory = mod:info(relativeDir)
    if not directory or directory.type ~= "directory" then return nil end

    for _, name in ipairs(mod:list(relativeDir)) do
      local ext = extension(name)
      if ext and SUPPORTED_FORMATS[ext:lower()] then
        local relative = relativeDir .. "/" .. name
        local info = mod:info(relative)
        if info and info.type == "file" then
          if ext:lower() == "ogg" and isOggOpus(relative, info) then
            mod.log:warn("Skipped Ogg Opus file in %s: %s. Re-encode it as Ogg Vorbis.", relativeDir, name)
          else
            if info.size and info.size > MAX_RECOMMENDED_SFX_BYTES then
              mod.log:warn("Large SFX file in %s: %s is %.1f MiB. Sound effects load as static audio; shorter files are recommended.", relativeDir, name, info.size / (1024 * 1024))
            end
            return relative, name
          end
        end
      end
    end
    return nil
  end

  local generationName = isGold and "Gold" or "Red/Blue/Yellow"
  local foldersLoaded, cuesReplaced = 0, 0

  for _, replacement in ipairs(REPLACEMENTS) do
    local targets = isGold and replacement.gold or replacement.gen1
    if #targets > 0 then
      local relativeDir = "assets/" .. replacement.folder
      local relativeFile, filename = firstCompatibleFile(relativeDir)
      if relativeFile then
        local file = mod.assets:path(relativeFile)
        for _, id in ipairs(targets) do
          mod.content.sfx:override(id, { file = file })
          cuesReplaced = cuesReplaced + 1
        end
        foldersLoaded = foldersLoaded + 1
        mod.log:info("%s: %s replaced %d %s cue(s).", replacement.folder, filename, #targets, generationName)
      end
    end
  end

  if foldersLoaded == 0 then
    mod.log:warn("No replacement sounds were found for %s. Add one supported file to a folder under assets/ and restart.", generationName)
  else
    mod.log:info("Loaded %d replacement file(s), covering %d %s sound-effect cue(s).", foldersLoaded, cuesReplaced, generationName)
  end
end
