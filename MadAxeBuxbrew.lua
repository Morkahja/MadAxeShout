-- MadAxeBuxbrew v1.3 (Turtle/Vanilla 1.12)
-- When you CAST or GAIN Battle Shout, post ONE random custom /e.

-------------------------------------------------
-- CONFIG
-------------------------------------------------
local SPELL_NAME  = "Battle Shout" -- /mae spell <localized name>
local COOLDOWN    = 4              -- seconds
local DEBUG       = false          -- /mae debug
local TRACE       = false          -- /mae trace (very verbose)

-- Buxbrew-flavored emotes (ASCII quotes only)
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
  "lashes the spirit of war into her kin with one brutal shout."
}

-------------------------------------------------
-- 1.12-safe helpers (no '#' operator, no varargs)
-------------------------------------------------
local function tlen(t)
  if not t then return 0 end
  if table.getn then return table.getn(t) end
  return 0
end

local function rand(t)
  local n = tlen(t)
  if n < 1 then return nil end
  return t[math.random(1, n)]
end

local function dprint(msg)
  if DEBUG then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE DEBUG:|r "..tostring(msg))
  end
end

local function tprint(event, msg)
  if TRACE then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00MAE TRACE:|r "..tostring(event).." :: "..tostring(msg or ""))
  end
end

-------------------------------------------------
-- core
-------------------------------------------------
local lastOut = 0
local function maybeEmote()
  local now = GetTime()
  if now - lastOut < COOLDOWN then
    dprint("cooldown")
    return
  end
  lastOut = now
  local e = rand(EMOTES)
  if e then
    SendChatMessage(e, "EMOTE")
    dprint("emote: "..e)
  end
end

-- unified handler for cast/gain events
local function handle(event, msg)
  tprint(event, msg)
  if not msg or msg == "" then return end
  -- match plain substring; user can set localized name via /mae spell
  if string.find(msg, SPELL_NAME, 1, true) then
    dprint("match: "..event)
    maybeEmote()
  end
end

-------------------------------------------------
-- events
-------------------------------------------------
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(_, event, arg1)
  if event == "PLAYER_ENTERING_WORLD" then
    math.randomseed(math.floor(GetTime()*1000))
    dprint("loaded; watching: "..SPELL_NAME)
  elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
    handle(event, arg1) -- e.g. "You cast Battle Shout."
  elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
    handle(event, arg1) -- e.g. "You gain Battle Shout."
  elseif event == "SPELLCAST_START" then
    tprint(event, arg1) -- arg1 = spell name
    if arg1 == SPELL_NAME then
      dprint("match: SPELLCAST_START")
      maybeEmote()
    end
  end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
f:RegisterEvent("SPELLCAST_START")

-------------------------------------------------
-- slash: /mae spell <name> | /mae debug | /mae trace | /mae test
-------------------------------------------------
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(msg)
  msg = msg or ""
  msg = string.gsub(msg, "^%s+", "")
  local cmd, rest = string.match(msg, "^(%S+)%s*(.-)$")
  if cmd == "spell" and rest and rest ~= "" then
    SPELL_NAME = rest
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r watching: "..SPELL_NAME)
  elseif cmd == "debug" then
    DEBUG = not DEBUG
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r debug "..(DEBUG and "ON" or "OFF"))
  elseif cmd == "trace" then
    TRACE = not TRACE
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r trace "..(TRACE and "ON" or "OFF"))
  elseif cmd == "test" then
    maybeEmote()
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r /mae spell <name> | /mae debug | /mae trace | /mae test")
  end
end
