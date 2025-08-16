-- MadAxeBuxbrew v1.4 (Turtle/Vanilla 1.12)
-- Robust path: wrap CastSpellByName / CastSpell, confirm via aura gain, then /e once.

-------------------------------------------------
-- CONFIG
-------------------------------------------------
local SPELL_NAME  = "Battle Shout" -- /mae spell <localized name> to change
local COOLDOWN    = 4              -- seconds between outputs
local DEBUG       = false          -- /mae debug
local TRACE       = false          -- /mae trace (verbose events)

-- Buxbrew-flavored emotes
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
local function tlen(t) if t and table.getn then return table.getn(t) end return 0 end
local function rand(t) local n=tlen(t); if n<1 then return nil end; return t[math.random(1,n)] end
local function dprint(msg) if DEBUG then DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE DEBUG:|r "..tostring(msg)) end end
local function tprint(event,msg) if TRACE then DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00MAE TRACE:|r "..tostring(event).." :: "..tostring(msg or "")) end end

-------------------------------------------------
-- State
-------------------------------------------------
local lastOut   = 0
local pendingBS = false
local pendingTS = 0
local PENDING_WINDOW = 3 -- seconds to wait for aura gain after cast

-------------------------------------------------
-- Emote fire with cooldown
-------------------------------------------------
local function maybeEmote()
  local now = GetTime()
  if now - lastOut < COOLDOWN then dprint("cooldown"); return end
  lastOut = now
  local e = rand(EMOTES)
  if e then SendChatMessage(e, "EMOTE"); dprint("emote: "..e) end
end

-------------------------------------------------
-- Aura check (Vanilla UnitBuff)
-------------------------------------------------
local function playerHasBS()
  for i=1,32 do
    local name = UnitBuff("player", i)
    if not name then break end
    if name == SPELL_NAME then return true end
  end
  return false
end

-------------------------------------------------
-- Wrap the old spellcast APIs
-------------------------------------------------
local _Orig_CastSpellByName = CastSpellByName
function CastSpellByName(name, onSelf)
  if name and string.find(name, SPELL_NAME, 1, true) then
    pendingBS = true; pendingTS = GetTime()
    dprint("CastSpellByName match: "..name)
  end
  return _Orig_CastSpellByName(name, onSelf)
end

local _Orig_CastSpell = CastSpell
function CastSpell(slot, bookType)
  -- Try to resolve spell name from spellbook (Vanilla: GetSpellName exists)
  local sName = nil
  if slot and bookType then
    sName = GetSpellName(slot, bookType)
  end
  if sName and string.find(sName, SPELL_NAME, 1, true) then
    pendingBS = true; pendingTS = GetTime()
    dprint("CastSpell match: "..sName)
  end
  return _Orig_CastSpell(slot, bookType)
end

-------------------------------------------------
-- Events: confirm aura gain and timeout pending
-------------------------------------------------
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_ENTERING_WORLD" then
    math.randomseed(math.floor(GetTime()*1000))
    dprint("loaded; watching: "..SPELL_NAME)
    pendingBS = playerHasBS() -- initialize state
  elseif event == "PLAYER_AURAS_CHANGED" then
    if pendingBS and playerHasBS() then
      dprint("aura confirmed")
      pendingBS = false
      maybeEmote()
    end
  end
end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_AURAS_CHANGED")

-- simple OnUpdate to timeout a failed/blocked cast so pending doesn't stick forever
f:SetScript("OnUpdate", function()
  if pendingBS and (GetTime() - pendingTS > PENDING_WINDOW) then
    dprint("pending timeout")
    pendingBS = false
  end
end)

-------------------------------------------------
-- /mae commands
-------------------------------------------------
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(msg)
  msg = msg or ""; msg = string.gsub(msg, "^%s+", "")
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
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r /mae spell <name> | /mae debug | /mae test")
  end
end
