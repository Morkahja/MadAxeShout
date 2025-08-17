-- SavedVariables table: don't touch at top; create on VARIABLES_LOADED
MadAxeBuxbrewDB = MadAxeBuxbrewDB -- leave as-is; WoW will load it

local WATCH_SLOT      = nil
local WATCH_MODE      = false
local LAST_EMOTE_TIME = 0
local EMOTE_COOLDOWN  = 90

-- ... (EMOTES + helpers + UseAction hook stay the same) ...

-- Slash command: when setting, write to DB (unchanged)
-- WATCH_SLOT = n; MadAxeBuxbrewDB.slot = n;

-- Proper 1.12 init: SavedVariables are guaranteed after VARIABLES_LOADED
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("VARIABLES_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(_, event)
  if event == "VARIABLES_LOADED" then
    -- Ensure table exists, then pull saved slot
    if type(MadAxeBuxbrewDB) ~= "table" then MadAxeBuxbrewDB = {} end
    WATCH_SLOT = MadAxeBuxbrewDB.slot or nil
  elseif event == "PLAYER_LOGIN" then
    -- Seed RNG once per login for variety
    math.randomseed(math.floor(GetTime() * 1000))
  end
end)
