-- MadAxeBuxbrew v1.5 (Turtle/Vanilla 1.12)
-- Fires ONE random /e when YOU GAIN Battle Shout (any rank).
-- Locale-agnostic: matches by buff ICON and (if available) SPELL ID.

-------------------------------------------------
-- CONFIG
-------------------------------------------------
local COOLDOWN = 4   -- seconds between outputs
local DEBUG    = false  -- /mae debug

-- All ranks of Battle Shout (Vanilla IDs); Turtle may add more, icon match covers that.
local BS_IDS = {
  [6673]=true,  -- Rank 1
  [5242]=true,  -- Rank 2
  [6192]=true,  -- Rank 3
  [11549]=true, -- Rank 4
  [11550]=true, -- Rank 5
  [11551]=true, -- Rank 6 (highest in 1.12)
}

-- Icon used by Battle Shout buffs in Vanilla/Turtle (locale independent)
local BS_ICON = "Interface\\Icons\\Ability_Warrior_BattleShout"

-- Your Buxbrew emotes (ASCII quotes only)
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
-- 1.12-safe helpers (no '#' operator, no varargs)
-------------------------------------------------
local function tlen(t)
  if t and table.getn then return table.getn(t) end
  return 0
end

local function rand(t)
  local n = tlen(t)
  if n < 1 then return nil end
  return t[math.random(1, n)]
end

local function dprint(msg)
  if DEBUG then DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MAE DEBUG:|r "..tostring(msg)) end
end

-------------------------------------------------
-- Buff detection (works on any locale)
-------------------------------------------------
local function playerHasBattleShout()
  -- Vanilla shows up to 16 buffs; Turtle often supports more. Loop safely.
  for i = 1, 32 do
    local icon, _, _, _, _, _, spellId = UnitBuff("player", i)
    if not icon then break end
    -- Prefer spellId if Turtle provides it:
    if spellId and BS_IDS[spellId] then return true end
    -- Fallback to icon match:
    if icon == BS_ICON then return true end
  end
  return false
end

-------------------------------------------------
-- Core
-------------------------------------------------
local lastOut = 0
local hadBS   = false

local function maybeEmote()
  local now = GetTime()
  if now - lastOut < COOLDOWN then dprint("cooldown"); return end
  lastOut = now
  local e = rand(EMOTES)
  if e then
    SendChatMessage(e, "EMOTE")
    dprint("emote: "..e)
  else
    dprint("no emotes in pool")
  end
end

local function onAurasChanged()
  local has = playerHasBattleShout()
  if (not hadBS) and has then
    dprint("Battle Shout gained")
    maybeEmote()
  end
  hadBS = has
end

-------------------------------------------------
-- Events
-------------------------------------------------
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_ENTERING_WORLD" then
    math.randomseed(math.floor(GetTime()*1000))
    hadBS = playerHasBattleShout()
    dprint("loaded; BS present: "..tostring(hadBS))
  elseif event == "PLAYER_AURAS_CHANGED" then
    onAurasChanged()
  end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_AURAS_CHANGED")

-------------------------------------------------
-- Slash: /mae debug | /mae test
-------------------------------------------------
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(msg)
  msg = msg or ""
  msg = string.gsub(msg, "^%s+", "")
  if msg == "debug" then
    DEBUG = not DEBUG
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r debug "..(DEBUG and "ON" or "OFF"))
  elseif msg == "test" then
    maybeEmote()
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r /mae debug  |  /mae test")
  end
end
