-- MadAxeBuxbrew v2.5.5 (Vanilla/Turtle 1.12)
-- Per-character SavedVariables. Lua 5.0-safe string handling.

-------------------------------------------------
-- Emotes (edit as you like)
-------------------------------------------------
local EMOTES = {
  "laughs loud and wild, joy sparking in her eyes.",
  "beats her chest with her fists and grins.",
  "roars a challenge, hips swaying, shoulders loose.",
  "throws her head back and howls at the sky.",
  "finds the rhythm in her boots and drums it in.",
  "pounds her chest with both fists, smiling wide.",
  "lets a laugh tear out like a warhorn.",
  "swings her fists in a wide arc, daring the clash.",
  "bangs fist to armor and winks.",
  "spins her fists like a tavern dancer gone wild.",
  "taps her weapons on her thigh in a fighter’s beat.",
  "snaps her fists tight and flashes a grin.",
  "throws a jab into the air and laughs at the impact.",
  "slashes the air with a brutal cross, then bursts laughing.",
  "wipes foam from her lip and smirks wickedly.",
  "clinks two mugs from her belt and shouts loud.",
  "lifts an imaginary toast and winks at the foe.",
  "snaps her fists together and grins at the sound.",
  "slams her palm to fist and surges forward.",
  "stands tall, chest proud, daring the hit.",
  "raises a fist and the cheer explodes around her.",
  "howls so loud the stone walls throw it back.",
  "so full of joy even the quiet roar with her.",
  "steps forward, hips loose, the front surges.",
  "flexes her sturdy frame; grips tighten nearby.",
  "lets bliss spill until nerves turn into laughs.",
  "erupts with presence; doubt burns away.",
  "ignites a warm fire that spreads through the line.",
  "shakes her shoulders, letting her rowdy muttons jiggle bold.",
  "throws a wink and slams her fist against her hip.",
  "plants her boots firm, hips rolling to a rowdy beat.",
  "lets her laugh bubble over like a keg burst.",
  "twirls once, fists flashing like she’s dancing in the fight.",
  "licks foam from her lip, grinning wickedly.",
  "slaps her thigh and laughs loud enough to echo.",
  "arches her back and roars, big jugs bouncing with the sound.",
  "drums her weapons against her ribs, steady and loud.",
  "grins wide as if every strike is a tavern cheer.",
  "plants her fists to the ground, chest thrust proud.",
  "lets her joy spill out so strong it feels like music.",
  "throws her fists high, voice booming like a festival cheer.",
  "bites her knuckle-plate and smirks as the clash begins.",
  "roars with bliss so hearty even foes grin wide.",
  "stomps hard, sending dust and laughter skyward.",
  "twists her wrists once, hips rolling with the motion.",
  "bellows like a tavern song, all heat and joy.",
  "claps her hands once and howls as the fight begins.",

  -- Naughty rowdy ones (rewritten filth and fist style)
  "presses her big jugs together with her forearms and roars loud.",
  "grinds her hips like she’s riding the beat of the brawl.",
  "licks the edge of her fist weapon and moans with joy.",
  "smacks her fat ass with her palm and laughs wild.",
  "slams her chest into a foe, grinning as they stumble.",
  "lets her ale jugs bounce loose as she howls the challenge.",
  "runs her tongue across her cleavage, winking filthy.",
  "thrusts her hips forward, fists swinging low and dirty.",
  "rubs her rack over her weapons, laughing raw.",
  "throws her head back, moaning and roaring in one breath.",
  "squeezes her massive knockers together and drums them like tankards.",
  "bites her knuckle-plate while her chest heaves with filthy joy.",
  "arches her back, swinging udders jiggling as she bellows.",
  "slaps her rowdy muttons hard enough to echo through stone.",
  "runs her tongue slow across her lip, then explodes in a roar.",
  "presses her thick rack to her fists and grins wickedly.",
  "humps the air once, then laughs like a sinner in prayer.",
  "lets her barmaid’s bounty bounce as she pounds her chest.",
  "shakes her hips like a tavern dancer mid-brawl.",
  "moans out a laugh, cheeks flushed red with fight-lust.",
  "presses her ale jugs together with a wicked grin, daring stares.",
  "shakes her stacked rack so wild it looks like a war dance.",
  "laughs as her hefty breasts slap in rhythm to the fight.",
  "arches forward, giant boulders swinging like war-drums.",
  "cups her bosom once, then throws both fists high with a roar.",
  "lets her drunken melons jiggle bold as she leans into the clash.",
  "claps her bust together like tankards, grinning drunk on battle.",
  "gives her chest a playful lift before stomping into the fray.",
  "swings her shoulders, stone pillows bouncing like drums of war.",
  "presses her fist weapons between her buxom barrels, laughing wild.",
  "licks her lips slow, eyes daring anyone to taste more.",
  "arches her back, rack quivering, before roaring like thunder.",
  "lets foam drip down her cleavage, howling as it spills.",
  "grins filthy and waggles her rump before smashing forward.",
  "thrusts her chest high, voice cracking like a battle horn.",
  "wipes ale across her bust and bellows like a goddess of sin.",
  "roars so raw her full kegs jiggle like a tavern quake.",
  "bends low, ass jiggling, then slams forward fists first.",
  "grinds her stout rump as if shaking the war itself.",
  "plants her brewing buns firm and roars, daring the strike.",
  "shakes her rump-kegs wild, laughter spilling out filthy and free.",
  "smacks her plump backside, howling like a war-horned beast.",
  "rests her mug on her ale shelf, then lifts it high roaring.",
  "rolls her boulder buns, fists flashing dirty close.",
  "claps her stout cask ass once, making the line shake.",
  "lets her feast rump wobble bold as her fists fly.",
  "slaps her full moon rump and bellows until echoes split.",
  "grinds her rump like tavern music, fists ready to slam.",
  "jiggles her backside till mugs spill, roaring with laughter.",
  "plants her feast-seat heavy, voice exploding like stone cracking.",
  "waggles her rump and fists together, shaking both with wild joy.",
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
