-- MadAxeBuxbrew v2.1 (Vanilla/Turtle 1.12)
-- Fires one random custom emote when you press your chosen action slot.
-- Cooldown: 90 seconds. Slot is saved between sessions.
-- Commands: /mae slot <num>, /mae watch, /mae emote

-------------------------------------------------
-- CONFIG: Buxbrew emotes
-------------------------------------------------
local EMOTES = {
  "lets out a savage roar.",
  "howls like a beast unchained.",
  "beats her chest with her weapon hilt.",
  "laughs like a berserker as the scent of blood fills the air.",
  "raises her weapon high.",
  "growls a deep war-chant.",
  "roars a brutal challenge.",
  "stomps the ground.",
  "howls skyward.",
  "stomps in rhythm.",
  "bellows to the wind.",
  "pounds her chest with both fists.",
  "throws her head back and howls.",
  "radiates unshakable fury.",
  "swings her weapon in a wide arc.",
  "lets her weapon hum with fury.",
  "bangs her weapon on iron plates.",
  "spins her weapon with one hand, letting the wind scream through it.",
  "taps her weapon against her thigh like a war drum.",
  "raises her weapon with a grunt, rallying for the first strike.",
  "snaps her weapon into both hands, grinning ear to ear.",
  "throws her weapon up, catches it mid-spin, and laughs.",
  "leans into her weapon with a low growl, daring anyone to charge.",
  "slashes the air in front of her, then roars with glee.",
  "holds her weapon to her heart, then slams it down at her feet.",
  "scrapes her weapon across her armor, sparks flying before the storm.",
  "kicks over a chair and snarls like she's starting a bar fight.",
  "wipes ale foam from her mouth and grins.",
  "clinks two mugs together till they shatter.",
  "lifts her mug high, catching the torchlight in her grin.",
  "laughs as she lights a fuse with her cigar.",
  "slams a keg tap open as she lets out a war cry.",
  "grins wide as the fuse burns on her powder keg.",
  "stands in the ale haze, laughing as the fight starts.",
  "slams a keg down hard enough to make the tables jump.",
  "kicks a keg downhill and grins as it bursts open.",
  "juggles three mugs before throwing one in someone's face.",
  "lets her powder horn puff smoke as she laughs.",
  "slaps a bar tab down and walks away laughing.",
  "slams her mug down and charges.",
  "strikes flint on her mug handle before charging.",
  "kicks over a keg and grins as it spills.",
  "slams her boots on the table, the tavern roars.",
  "flares with rage, mugs start to slam.",
  "unleashes a roar that rattles every mug in the room.",
  "lets her laugh tear through the tavern like a warhorn.",
  "brims with fury so thick the air smells like spilled ale.",
  "lets her presence fire up every drunk in the hall.",
  "stands tall on the table, every brawler swings harder.",
  "raises her mug, the room drowns in cheers.",
  "howls so loud it makes mugs jump off tables.",
  "stomps the floorboards till dust falls from the rafters.",
  "channels her rage, the whole tavern roars with her.",
  "beats her chest as every mug nearby sloshes harder.",
  "unleashes such fury that even the calm start screaming.",
  "drives her will into the air and the air answers.",
  "steps forward, the front line surges with strength.",
  "tenses her muscles, as everyone tightens their grip.",
  "calls the storm through her veins.",
  "lets her fury flow, as even the earth seems ready to strike.",
  "erupts with presence and all hesitation burns away.",
  "ignites a fire so fierce it spreads through every heart.",
  "lashes the spirit of war into her kin with one brutal shout.",
}

-------------------------------------------------
-- STATE
-------------------------------------------------
local WATCH_SLOT = nil
local WATCH_MODE = false
local LAST_EMOTE_TIME = 0
local EMOTE_COOLDOWN = 90 -- seconds

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
      MadAxeBuxbrewDB.slot = n
      DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r watching action slot "..n.." (saved).")
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r usage: /mae slot <number>")
    end
  elseif cmd == "watch" then
    WATCH_MODE = not WATCH_MODE
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r watch mode "..(WATCH_MODE and "ON" or "OFF"))
  elseif cmd == "emote" then
    doEmoteNow()
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE:|r /mae slot <number>  |  /mae watch  |  /mae emote")
  end
end

-------------------------------------------------
-- On Login: init DB + random seed
-------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
  if not MadAxeBuxbrewDB then MadAxeBuxbrewDB = {} end
  if MadAxeBuxbrewDB.slot then WATCH_SLOT = MadAxeBuxbrewDB.slot end
  math.randomseed(math.floor(GetTime()*1000))
end)
