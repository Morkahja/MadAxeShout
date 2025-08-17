-- MadAxeBuxbrew v2.5 (Vanilla/Turtle 1.12)
-- Fires one random custom emote when you press your chosen action slot.
-- Cooldown: 90 seconds. Slot persists across reloads/logouts.

-------------------------------------------------
-- SavedVariables (classic 1.12 pattern)
-------------------------------------------------
MadAxeBuxbrewDB = MadAxeBuxbrewDB or {}     -- engine fills if present; otherwise keep {}

-------------------------------------------------
-- CONFIG: Buxbrew emotes
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
  "calls the storm o’ stone through her


-------------------------------------------------
-- STATE
-------------------------------------------------
local WATCH_SLOT       = MadAxeBuxbrewDB.slot or nil   -- load immediately
local WATCH_MODE       = false
local LAST_EMOTE_TIME  = 0
local EMOTE_COOLDOWN   = 90 -- seconds

-------------------------------------------------
-- Helpers
-------------------------------------------------
local function tlen(t) if t and table.getn then return table.getn(t) end return 0 end
local function pick(t) local n=tlen(t); if n<1 then return nil end; return t[math.random(1,n)] end

local function doEmoteNow()
  local now = GetTime()
  if now - LAST_EMOTE_TIME < EMOTE_COOLDOWN then return end
  LAST_EMOTE_TIME = now
  local e = pick(EMOTES)
  if e then SendChatMessage(e, "EMOTE") end
end

-------------------------------------------------
-- Hook UseAction
-------------------------------------------------
local _Orig_UseAction = UseAction
function UseAction(slot, checkCursor, onSelf)
  if WATCH_MODE then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r pressed slot "..tostring(slot))
  end
  if WATCH_SLOT and slot == WATCH_SLOT then
    doEmoteNow()
  end
  return _Orig_UseAction(slot, checkCursor, onSelf)
end

-------------------------------------------------
-- Slash Commands
-------------------------------------------------
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(msg)
  msg = msg or ""; msg = string.gsub(msg, "^%s+", "")
  local cmd, rest = string.match(msg, "^(%S+)%s*(.-)$")
  if cmd == "slot" then
    local n = tonumber(rest)
    if n then
      WATCH_SLOT = n
      MadAxeBuxbrewDB.slot = n       -- persist immediately
      DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r watching action slot "..n.." (saved).")
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r usage: /mae slot <number>")
    end
  elseif cmd == "watch" then
    WATCH_MODE = not WATCH_MODE
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r watch mode "..(WATCH_MODE and "ON" or "OFF"))
  elseif cmd == "emote" then
    doEmoteNow()
  elseif cmd == "info" then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r watching slot: "..(WATCH_SLOT or "none"))
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r cooldown: "..EMOTE_COOLDOWN.."s")
  elseif cmd == "timer" then
    local now = GetTime()
    local remain = EMOTE_COOLDOWN - (now - LAST_EMOTE_TIME)
    if remain < 0 then remain = 0 end
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r time left: "..string.format("%.1f", remain).."s")
  elseif cmd == "reset" then
    MadAxeBuxbrewDB.slot = nil
    WATCH_SLOT = nil
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r cleared saved slot.")
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r /mae slot <number> | /mae watch | /mae emote | /mae info | /mae timer | /mae reset")
  end
end

-------------------------------------------------
-- Seed RNG once on login
-------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
  math.randomseed(math.floor(GetTime()*1000))
end)
