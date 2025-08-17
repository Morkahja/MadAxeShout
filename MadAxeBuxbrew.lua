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
  "Lets out a hearty roar that shakes her tits and her mug alike.",
  "Howls with laughter like the tavern just broke into a brawl.",
  "Beats her cleavage with her axe haft, daring the room to cheer louder.",
  "Laughs like she’s already drunk and already winning.",
  "Raises her axe high, foam dripping from her lips.",
  "Growls a rowdy tavern-chant, boots stomping in time.",
  "Roars a boozy challenge, hips swaying as she grins.",
  "Stomps the stone floor till mugs rattle on the tables.",
  "Throws her head back, tits bouncing, howling at the ceiling.",
  "Stomps a bawdy rhythm, hips and mutton shaking with each beat.",
  "Bellows loud enough to shake the barrels stacked in the corner.",
  "Pounds her chest and tits with both fists like a drunken champion.",
  "Throws her head back and howls, ale spraying from her grin.",
  "Radiates joy so fierce it feels like stone walls are shaking.",
  "Swings her axe in a wide arc, nearly toppling a keg.",
  "Lets her axe hum while her tits bounce to the rhythm.",
  "Bangs her axe on the bar, sparks flying with laughter.",
  "Spins her axe like a dance partner, grinning wild.",
  "Taps her axe haft on her thigh like a tavern drum.",
  "Hoists her axe with a grunt, tits wobbling, ready to strike.",
  "Snaps her axe into both hands, grinning ear to ear.",
  "Tosses her axe, catches it mid-spin, and winks.",
  "Leans into her axe, tits pressed tight, daring anyone to step up.",
  "Slashes the air, then roars like she just won a drinking contest.",
  "Holds her axe to her cleavage, then slams it down at her feet.",
  "Scrapes steel on her armor, sparks flying like barfight foreplay.",
  "Kicks over a chair and cackles like it’s just the start.",
  "Wipes ale foam off her tits and grins wickedly.",
  "Clinks two mugs between her breasts until they shatter.",
  "Lifts her mug high, tits bouncing with the cheer.",
  "Laughs as she lights a fuse with her cigar stub.",
  "Slams open a keg tap with her axe and roars.",
  "Grins wide as the keg froths over like her cleavage.",
  "Stands in the ale haze, tits gleaming, laughing.",
  "Slams a keg down so hard the stone floor trembles.",
  "Kicks a keg rolling, laughing as it bursts.",
  "Juggles mugs on her tits, tossing one in someone’s face.",
  "Lets her powder horn puff smoke while she smirks.",
  "Slaps a bar tab down on her cleavage and laughs.",
  "Slams her mug down, spilling ale as she charges.",
  "Strikes flint on her axe before rushing in.",
  "Boots stomp, tits bounce, keg spills — she laughs louder.",
  "Plants her boots on the table, the tavern roars back.",
  "Her joy flares, mugs slam in rhythm with her laugh.",
  "Unleashes a roar that rattles every mug and rib in the room.",
  "Lets her laugh tear through the tavern like a warhorn.",
  "Brims with hearty bliss, air thick with ale and joy.",
  "Lets her presence fire up every drunk within reach.",
  "Stands tall on the table, tits bouncing, rallying every brawler.",
  "Raises her mug, foam flying, the room explodes in cheers.",
  "Howls so loud mugs topple off stone tables.",
  "Stomps the stone floor till the whole hall shakes.",
  "Fills the air with joy, the tavern roars back in kind.",
  "Beats her tits with her fists, mugs sloshing harder nearby.",
  "So full of joy even the calm can’t help but shout.",
  "Drives her cheer into the air, and the crowd answers.",
  "Steps forward, tits jiggling, the front line surges.",
  "Flexes her sturdy frame, the room grips tighter.",
  "Calls the storm o’ stone through her veins.",
  "Lets bliss flow till even the earth feels ready to cheer.",
  "Erupts with presence, hesitation burns away.",
  "Ignites hearty fire, it spreads through every heart.",
  "Whips the spirit of brawling into her kin with one joyful shout.",
}

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
