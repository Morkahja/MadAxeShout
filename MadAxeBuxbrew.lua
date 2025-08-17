-- MadAxeBuxbrew v2.5.5 (Vanilla/Turtle 1.12)
-- Per-character SavedVariables. Lua 5.0-safe string handling.

-------------------------------------------------
-- Emotes (edit as you like)
-------------------------------------------------
local EMOTES = {
  "lets out a hearty roar that rolls across the field.",
  "laughs loud and wild, joy sparking in her eyes.",
  "beats her chest with her axe haft and grins.",
  "raises her axe high, breath misting in the air.",
  "growls a bold chant that lifts every spine.",
  "roars a challenge, hips swaying, shoulders loose.",
  "stomps once, hard, and the ground seems to answer.",
  "throws her head back and howls at the sky.",
  "finds the rhythm in her boots and drums it in.",
  "bellows until birds scatter from the trees.",
  "pounds her chest with both fists, smiling wide.",
  "lets a laugh tear out like a warhorn.",
  "radiates hearty bliss that pulls others forward.",
  "swings her axe in a wide arc, ready to start.",
  "lets her axe hum as her shoulders roll.",
  "bangs axe to armor and winks.",
  "spins her axe like a dance partner.",
  "taps her axe haft on her thigh in a fighter’s beat.",
  "hoists her axe with a grunt, eager to go.",
  "snaps her grip firm and flashes a grin.",
  "tosses her axe and catches it mid-spin, laughing.",
  "leans into her stance, daring anyone to charge.",
  "slashes the air, then laughs like the fun began.",
  "holds her axe to her heart, then plants it to earth.",
  "scrapes steel across steel, sparks in the wind.",
  "wipes a bit of foam from her lip and smirks.",
  "clinks two small mugs on her belt and smiles.",
  "lifts an imaginary toast and winks at the foe.",
  "lights a fuse in her heart—then roars.",
  "stands in the dust and grins as it swirls.",
  "drops a shoulder and laughs, ready to crash in.",
  "juggles her grip once and flicks a stray lock aside.",
  "lets her powder horn puff the faintest smoke and smiles.",
  "slaps a coin into a glove like a bet, then charges.",
  "slams her fist to palm and surges forward.",
  "strikes flint on her axe edge, sparks dancing.",
  "boots set, shoulders loose—she laughs louder.",
  "plants her feet, back straight, voice rising.",
  "her joy flares; hands tighten all around her.",
  "unleashes a roar that rattles shields.",
  "brims with hearty fire; the air tastes bright.",
  "lifts her chin and the line steps with her.",
  "stands tall, chest proud, inviting the hit.",
  "raises a fist and the cheer swells.",
  "howls so loud the hills throw it back.",
  "stamps once and dust jumps at her heels.",
  "fills the air with courage, and the band answers.",
  "beats her chest; weapons around her seem lighter.",
  "so full of joy even the quiet shout with her.",
  "drives her cheer into the wind; it carries far.",
  "steps forward, hips loose, the front surges.",
  "flexes her sturdy frame; grips tighten nearby.",
  "calls the pulse of the earth through her veins.",
  "lets bliss flow until nerves turn into laughs.",
  "erupts with presence; doubt burns away.",
  "ignites a warm fire that spreads through the line.",
  "lashes bright spirit into her kin with one shout.",
}



-------------------------------------------------
-- State
-------------------------------------------------
local WATCH_SLOT = nil
local WATCH_MODE = false
local LAST_EMOTE_TIME = 0
local EMOTE_COOLDOWN = 90

-------------------------------------------------
-- Helpers
-------------------------------------------------
local function chat(text)
  if DEFAULT_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r " .. text)
  end
end

local function ensureDB()
  if type(MadAxeBuxbrewDB) ~= "table" then
    MadAxeBuxbrewDB = {}
  end
  return MadAxeBuxbrewDB
end

-- one-time lazy load in case events fire oddly on this client
local _mae_loaded_once = false
local function ensureLoaded()
  if not _mae_loaded_once then
    local db = ensureDB()
    if WATCH_SLOT == nil then
      WATCH_SLOT = db.slot or nil
    end
    _mae_loaded_once = true
  end
end

local function tlen(t)
  if t and table.getn then return table.getn(t) end
  return 0
end

local function pick(t)
  local n = tlen(t)
  if n < 1 then return nil end
  return t[math.random(1, n)]
end

local function doEmoteNow()
  local now = GetTime()
  if now - LAST_EMOTE_TIME < EMOTE_COOLDOWN then return end
  LAST_EMOTE_TIME = now
  local e = pick(EMOTES)
  if e then SendChatMessage(e, "EMOTE") end
end

-------------------------------------------------
-- Hook UseAction (1.12)
-------------------------------------------------
local _Orig_UseAction = UseAction
function UseAction(slot, checkCursor, onSelf)
  ensureLoaded()
  if WATCH_MODE then
    chat("pressed slot " .. tostring(slot))
  end
  if WATCH_SLOT and slot == WATCH_SLOT then
    doEmoteNow()
  end
  return _Orig_UseAction(slot, checkCursor, onSelf)
end

-------------------------------------------------
-- Slash Commands (Lua 5.0-safe: use string.*)
-------------------------------------------------
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(raw)
  ensureLoaded()
  local s = raw or ""
  s = string.gsub(s, "^%s+", "")
  local cmd, rest = string.match(s, "^(%S+)%s*(.-)$")

  if cmd == "slot" then
    local n = tonumber(rest)
    if n then
      WATCH_SLOT = n
      local db = ensureDB()
      db.slot = n
      chat("watching action slot " .. n .. " (saved).")
    else
      chat("usage: /mae slot <number>")
    end

  elseif cmd == "watch" then
    WATCH_MODE = not WATCH_MODE
    chat("watch mode " .. (WATCH_MODE and "ON" or "OFF"))

  elseif cmd == "emote" then
    doEmoteNow()

  elseif cmd == "info" then
    chat("watching slot: " .. (WATCH_SLOT and tostring(WATCH_SLOT) or "none"))
    chat("cooldown: " .. EMOTE_COOLDOWN .. "s")

  elseif cmd == "timer" then
    local remain = EMOTE_COOLDOWN - (GetTime() - LAST_EMOTE_TIME)
    if remain < 0 then remain = 0 end
    chat("time left: " .. string.format("%.1f", remain) .. "s")

  elseif cmd == "reset" then
    WATCH_SLOT = nil
    local db = ensureDB()
    db.slot = nil
    chat("cleared saved slot.")

  elseif cmd == "save" then
    local db = ensureDB()
    db.slot = WATCH_SLOT
    chat("saved now.")

  elseif cmd == "debug" then
    local t = type(MadAxeBuxbrewDB)
    local v = (t == "table") and tostring(MadAxeBuxbrewDB.slot) or "n/a"
    chat("type(MadAxeBuxbrewDB)=" .. t .. " | SV slot=" .. v .. " | WATCH_SLOT=" .. tostring(WATCH_SLOT))

  else
    chat("/mae slot <number> | /mae watch | /mae emote | /mae info | /mae timer | /mae reset | /mae save | /mae debug")
  end
end

-------------------------------------------------
-- Init / Save / RNG
-------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD") -- some 1.12 forks prefer this order
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOGOUT")

f:SetScript("OnEvent", function(self, event)
  if event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
    local db = ensureDB()
    WATCH_SLOT = db.slot or WATCH_SLOT
    -- uncomment if you want a boot message:
    chat("loaded slot " .. tostring(WATCH_SLOT or "none"))
  elseif event == "PLAYER_LOGIN" then
    math.randomseed(math.floor(GetTime() * 1000)); math.random()
  elseif event == "PLAYER_LOGOUT" then
    ensureDB().slot = WATCH_SLOT
  end
end)
