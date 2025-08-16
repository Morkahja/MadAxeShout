-- MadAxe Shout (Turtle WoW 1.12)

-- ============ CONFIG ============
local SPELL_NAME = "Battle Shout"      -- /mas spell <name> to change if needed
local COOLDOWN   = 5                   -- anti-spam seconds
local enabled    = true

-- Classic dungeons by zone text (add Turtle custom ones if you want)
local DUNGEON_ZONES = {
  ["Ragefire Chasm"]=true, ["Wailing Caverns"]=true, ["The Deadmines"]=true,
  ["Shadowfang Keep"]=true, ["Blackfathom Deeps"]=true, ["The Stockade"]=true,
  ["Gnomeregan"]=true, ["Scarlet Monastery"]=true, ["Razorfen Kraul"]=true,
  ["Razorfen Downs"]=true, ["Uldaman"]=true, ["Zul'Farrak"]=true,
  ["Maraudon"]=true, ["The Temple of Atal'Hakkar"]=true, -- Sunken Temple
  ["Blackrock Depths"]=true, ["Lower Blackrock Spire"]=true, ["Upper Blackrock Spire"]=true,
  ["Dire Maul"]=true, ["Stratholme"]=true, ["Scholomance"]=true,
  -- Add Turtle custom dungeons here:
  -- ["Custom Dungeon Name"]=true,
}

-- ============ POOLS ============
-- These come from MAS_Emotes.lua / MAS_Yells.lua:
--   emotes, yellEmotes, builtInEmotes

-- ============ UTILS (no '#' operator) ============
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

local function isDungeon()
  local z = GetRealZoneText() or GetZoneText()
  if not z then return false end
  return DUNGEON_ZONES[z] == true
end

-- ============ CORE RANDOMIZER ============
local lastFire = 0
local function fireOne()
  local now = GetTime()
  if now - lastFire < COOLDOWN then return end
  lastFire = now

  local r = math.random()
  if isDungeon() then
    -- 30% YELL, 30% built-in, 40% EMOTE
    if r < 0.30 then
      local msg = rand(yellEmotes)
      if msg then SendChatMessage(msg, "YELL") end
    elseif r < 0.60 then
      local e = rand(builtInEmotes)
      if e then DoEmote(e) end
    else
      local msg = rand(emotes)
      if msg then SendChatMessage(msg, "EMOTE") end
    end
  else
    -- 30% built-in, 70% EMOTE
    if r < 0.30 then
      local e = rand(builtInEmotes)
      if e then DoEmote(e) end
    else
      local msg = rand(emotes)
      if msg then SendChatMessage(msg, "EMOTE") end
    end
  end
end

-- ============ BATTLE SHOUT DETECTION ============
-- We detect when the player GAINS the Battle Shout aura.
-- Turtle added spell IDs to UnitBuff(); we’ll use them if present.
-- Fallback: match the aura NAME to SPELL_NAME.
local BS_IDS = {
  [6673]=true, -- Rank 1
  -- add ranks if Turtle reports distinct IDs; we’ll still match by name if not
}

local hadBS = false

local function playerHasBattleShout()
  -- In 1.12, up to 16 buffs; Turtle may allow more, we’ll check 32 safely
  for i=1,32 do
    local name, _, _, _, _, _, spellId = UnitBuff("player", i)
    if not name then break end
    if spellId and BS_IDS[spellId] then
      return true
    end
    if name == SPELL_NAME then
      return true
    end
  end
  return false
end

local function onAurasChanged()
  if not enabled then return end
  local hasBS = playerHasBattleShout()
  if (not hadBS) and hasBS then
    fireOne()
  end
  hadBS = hasBS
end

-- ============ EVENTS ============
local f = CreateFrame("Frame", "MadAxeShoutFrame")
f:SetScript("OnEvent", function(self, event, arg1)
  if event == "PLAYER_ENTERING_WORLD" then
    math.randomseed(GetTime())
    hadBS = playerHasBattleShout()
  elseif event == "PLAYER_AURAS_CHANGED" then
    onAurasChanged()
  elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "MINIMAP_ZONE_CHANGED" then
    -- nothing special; isDungeon() reads zone when needed
  end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("MINIMAP_ZONE_CHANGED")

-- ============ SLASH ============
SLASH_MADAXESHOUT1 = "/mas"
SlashCmdList["MADAXESHOUT"] = function(msg)
  msg = string.lower(msg or "")
  if msg == "on" then
    enabled = true
    DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r enabled.")
  elseif msg == "off" then
    enabled = false
    DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r disabled.")
  elseif msg == "test" then
    fireOne()
  elseif string.sub(msg,1,5) == "spell" then
    local n = string.match(msg, "^spell%s+(.+)$")
    if n and n ~= "" then
      SPELL_NAME = n
      DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r spell set to: "..SPELL_NAME)
    end
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r /mas on | /mas off | /mas test | /mas spell <name>")
  end
end
