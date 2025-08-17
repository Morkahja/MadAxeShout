-- MadAxeBuxbrew v2.5.5 (Vanilla/Turtle 1.12)
-- Per-character SavedVariables. Lua 5.0-safe string handling.

-------------------------------------------------
-- Emotes (edit as you like)
-------------------------------------------------
local EMOTES = {
  "lets out a hearty roar that shakes her tits and her mug alike.",
  "howls with laughter like the tavern just broke into a brawl.",
  "beats her cleavage with her axe haft, daring the room to cheer louder.",
  "laughs like she’s already drunk and already winning.",
  "raises her axe high, foam dripping from her lips.",
  "growls a rowdy tavern-chant, boots stomping in time.",
  "roars a boozy challenge, hips swaying as she grins.",
  "stomps the stone floor till mugs rattle on the tables.",
  "throws her head back, tits bouncing, howling at the ceiling.",
  "stomps a bawdy rhythm, hips and mutton shaking with each beat.",
  "bellows loud enough to shake the barrels stacked in the corner.",
  "pounds her chest and tits with both fists like a drunken champion.",
  "throws her head back and howls, ale spraying from her grin.",
  "radiates joy so fierce it feels like stone walls are shaking.",
  "swings her axe in a wide arc, nearly toppling a keg.",
  "lets her axe hum while her tits bounce to the rhythm.",
  "bangs her axe on the bar, sparks flying with laughter.",
  "spins her axe like a dance partner, grinning wild.",
  "taps her axe haft on her thigh like a tavern drum.",
  "hoists her axe with a grunt, tits wobbling, ready to strike.",
  "snaps her axe into both hands, grinning ear to ear.",
  "tosses her axe, catches it mid-spin, and winks.",
  "leans into her axe, tits pressed tight, daring anyone to step up.",
  "slashes the air, then roars like she just won a drinking contest.",
  "holds her axe to her cleavage, then slams it down at her feet.",
  "scrapes steel on her armor, sparks flying like barfight foreplay.",
  "kicks over a chair and cackles like it’s just the start.",
  "wipes ale foam off her tits and grins wickedly.",
  "clinks two mugs between her breasts until they shatter.",
  "lifts her mug high, tits bouncing with the cheer.",
  "laughs as she lights a fuse with her cigar stub.",
  "slams open a keg tap with her axe and roars.",
  "grins wide as the keg froths over like her cleavage.",
  "stands in the ale haze, tits gleaming, laughing.",
  "slams a keg down so hard the stone floor trembles.",
  "kicks a keg rolling, laughing as it bursts.",
  "juggles mugs on her tits, tossing one in someone’s face.",
  "lets her powder horn puff smoke while she smirks.",
  "slaps a bar tab down on her cleavage and laughs.",
  "slams her mug down, spilling ale as she charges.",
  "strikes flint on her axe before rushing in.",
  "boots stomp, tits bounce, keg spills — she laughs louder.",
  "plants her boots on the table, the tavern roars back.",
  "her joy flares, mugs slam in rhythm with her laugh.",
  "unleashes a roar that rattles every mug and rib in the room.",
  "lets her laugh tear through the tavern like a warhorn.",
  "brims with hearty bliss, air thick with ale and joy.",
  "lets her presence fire up every drunk within reach.",
  "stands tall on the table, tits bouncing, rallying every brawler.",
  "raises her mug, foam flying, the room explodes in cheers.",
  "howls so loud mugs topple off stone tables.",
  "stomps the stone floor till the whole hall shakes.",
  "fills the air with joy, the tavern roars back in kind.",
  "beats her tits with her fists, mugs sloshing harder nearby.",
  "so full of joy even the calm can’t help but shout.",
  "drives her cheer into the air, and the crowd answers.",
  "steps forward, tits jiggling, the front line surges.",
  "flexes her sturdy frame, the room grips tighter.",
  "calls the storm o’ stone through her veins.",
  "lets bliss flow till even the earth feels ready to cheer.",
  "erupts with presence, hesitation burns away.",
  "ignites hearty fire, it spreads through every heart.",
  "whips the spirit of brawling into her kin with one joyful shout.",
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
