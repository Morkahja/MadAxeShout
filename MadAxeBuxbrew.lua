-- MadAxeBuxbrew v1.1 (Turtle WoW 1.12)
-- Posts one random custom /e when you CAST Battle Shout.
-- Uses classic CHAT_MSG_SPELL_SELF_BUFF instead of aura scanning for reliability.

-------------------------------------------------
-- CONFIG
-------------------------------------------------
local SPELL_NAME  = "Battle Shout" -- change via /mae spell <name> (localized)
local COOLDOWN    = 4              -- seconds anti-spam
local DEBUG       = false          -- /mae debug to toggle

-- Emotes pool (add as many as you want; keep ASCII quotes)
local EMOTES = {
  "slams a keg down hard enough to make the tables jump.",
  "howls so loud it makes mugs jump off tables.",
  "bangs a mug against her shield, froth flying everywhere.",
  "cracks her knuckles like breaking bones before a brawl.",
  "lets out a roar that rattles bottles on the shelves.",
  "pounds the table with her fist, making tankards spill.",
  "kicks over a chair and snarls like she's starting a bar fight.",
  "laughs like a lunatic with foam dripping from her beard.",
  "stomps the stone floor, shaking dust from the ceiling.",
  "throws her head back and bellows like a mad drunken queen."
}

-------------------------------------------------
-- helpers (1.12 safe, no '#' operator)
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
  local msg = rand(EMOTES)
  if msg then
    SendChatMessage(msg, "EMOTE")
    dprint("emote: "..msg)
  else
    dprint("no emotes in pool")
  end
end

-- When you cast a self buff, Vanilla fires CHAT_MSG_SPELL_SELF_BUFF.
-- Example (enUS): "You cast Battle Shout."
local function handleSelfBuff(msg)
  if not msg or msg == "" then return end
  if string.find(msg, SPELL_NAME, 1, true) then
    dprint("matched: "..msg)
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
    dprint("loaded; watching for: "..SPELL_NAME)
  elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
    handleSelfBuff(arg1)
  end
end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")

-------------------------------------------------
-- slash: /mae spell <name>  |  /mae debug  |  /mae test
-------------------------------------------------
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(msg)
  msg = msg or ""
  msg = string.gsub(msg, "^%s+", "")
  local cmd, rest = string.match(msg, "^(%S+)%s*(.-)$")
  if cmd == "spell" and rest and rest ~= "" then
    SPELL_NAME = rest
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r watching spell: "..SPELL_NAME)
  elseif cmd == "debug" then
    DEBUG = not DEBUG
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r debug is "..(DEBUG and "ON" or "OFF"))
  elseif cmd == "test" then
    maybeEmote()
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r /mae spell <name>  |  /mae debug  |  /mae test")
  end
end
