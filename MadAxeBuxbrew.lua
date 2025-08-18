-- MadAxeBuxbrew v2.5.5 (Vanilla/Turtle 1.12)
-- Per-character SavedVariables. Lua 5.0-safe string handling.

-------------------------------------------------
-- Emotes (edit as you like)
-------------------------------------------------
local EMOTES = {
  "laughs loud and wild, joy sparking in her eyes.",
  "beats her chest with her axe haft and grins.",
  "roars a challenge, hips swaying, shoulders loose.",
  "throws her head back and howls at the sky.",
  "finds the rhythm in her boots and drums it in.",
  "pounds her chest with both fists, smiling wide.",
  "lets a laugh tear out like a warhorn.",
  "swings her axe in a wide arc, ready to start.",
  "bangs axe to armor and winks.",
  "spins her axe like a dance partner.",
  "taps her axe haft on her thigh in a fighter’s beat.",
  "snaps her grip firm and flashes a grin.",
  "tosses her axe and catches it mid-spin, laughing.",
  "slashes the air, then laughs like the fun began.",
  "wipes a bit of foam from her lip and smirks.",
  "clinks two small mugs on her belt and smiles.",
  "lifts an imaginary toast and winks at the foe.",
  "juggles her grip once and flicks a stray lock aside.",
  "slams her fist to palm and surges forward.",
  "stands tall, chest proud, inviting the hit.",
  "raises a fist and the cheer swells.",
  "howls so loud the hills throw it back.",
  "so full of joy even the quiet shout with her.",
  "steps forward, hips loose, the front surges.",
  "flexes her sturdy frame; grips tighten nearby.",
  "lets bliss flow until nerves turn into laughs.",
  "erupts with presence; doubt burns away.",
  "ignites a warm fire that spreads through the line.",
  "shakes her shoulders, letting her mutton jiggle bold.",
  "throws a wink and smacks her axe haft against her hip.",
  "plants her boots firm, hips rolling to a rowdy beat.",
  "lets her laugh bubble over like ale from a keg.",
  "twirls once, axe flashing like she’s dancing in the fight.",
  "licks foam from her lip, grinning wickedly.",
  "slaps her thigh and laughs loud enough to echo.",
  "arches her back and roars, tits bouncing with the sound.",
  "drums the flat of her axe against her ribs, steady and loud.",
  "grins wide as if every strike is a tavern cheer.",
  "plants her axe in the ground, chest thrust proud.",
  "lets her joy spill out so strong it feels like music.",
  "throws her fist high, voice booming like a festival cheer.",
  "bites her lip and smirks as the clash begins.",
  "roars with bliss so hearty even foes grin wide.",
  "stomps hard, sending dust and laughter skyward.",
  "twists her axe once, hips rolling with the motion.",
  "bellows like a tavern song, all heat and joy.",
  "claps her hands once and howls as the fight begins.",

  -- Naughty new ones
  "presses her tits together with her arms and roars.",
  "grinds her hips like she’s dancing on a tavern table.",
  "licks the edge of her axe and moans with joy.",
  "smacks her ass with her palm and laughs loud.",
  "presses her mutton against her foe, grinning wide.",
  "lets her tits bounce free as she howls the challenge.",
  "licks foam dripping down her cleavage and winks.",
  "thrusts her hips forward, axe swinging low and dirty.",
  "rubs her chest against the haft of her axe, laughing.",
  "throws her head back, moaning and roaring all at once.",
  "squeezes her tits together and laughs like a wild drumbeat.",
  "bites her axe haft while her chest heaves with joy.",
  "arches her back, tits jiggling as she bellows.",
  "slaps her mutton hard enough to echo through the hills.",
  "runs her tongue slow across her lip, then roars.",
  "presses her cleavage on the axe haft and grins wickedly.",
  "humps the air once, then breaks into laughter.",
  "lets her tits bounce as she pounds her chest.",
  "shakes her hips like a tavern dancer mid-brawl.",
  "moans out a laugh, cheeks flushed with heat and fight.",
  "presses her tits together with a wicked grin, daring the foe to look.",
"shakes her jugs so wild it looks like part of the war dance.",
"laughs as her tits slap against her chest in rhythm.",
"arches forward, tits swinging like battering rams of joy.",
"cups her breasts once, then throws her axe high with a roar.",
"lets her cleavage jiggle bold as she leans into the fight.",
"claps her tits together like tankards, grinning drunk on battle.",
"gives her tits a playful lift before stomping into the fray.",
"swings her shoulders, tits bouncing like twin drums of war.",
"presses her axe haft between her tits, laughing loud as steel hums.",
  "licks sauce off her lips slow, eyes daring anyone to taste more.",
"grabs a rib bone, bites deep, and moans loud like it’s more than food.",
"lets ale foam spill over her chest, laughing as it runs down.",
"sucks marrow from a bone with a grin that’s filthy as sin.",
"wipes grease across her cleavage and smirks, 'who’s hungry?'",
"tilts a mug back too far, ale pouring down her neck between her tits.",
"bites her lip as she licks her fingers clean of sauce.",
"shoves a rib in her mouth, shakes her tits, and growls with joy.",
"slaps her axe haft into a half-eaten rib and licks it clean.",
"drinks deep, burps loud, and winks with foam on her chin.",
  "slurps ale and lets it drip down her rack like it’s a showpiece.",
"wipes rib-grease across her bosom and laughs wickedly.",
"grabs a mug with both jugs pressed round it, chugging deep.",
"licks marrow from a bone, moaning like it’s no feast at all.",
"lets foam slide down her cleavage, winking at the nearest fool.",
"takes a bite of meat and shakes her melons with the chew.",
"smears sauce across her bust, grinning at the mess.",
"presses a mug to her chest, ale spilling everywhere as she roars.",
"licks her fingers clean, then drags them slow over her bosom.",
"snaps a bone in half with her teeth, juice running down her chin.",
"presses a rib to her lips, juice running down her chin and over her bust.",
"lets ale foam spill down her cleavage, licking slow and shameless.",
"buries her teeth in a boar rib, grease shining on her melons as she laughs.",
"tips a mug between her jugs and drinks as it spills everywhere.",
"cracks a bone, sucking it loud, eyes wicked with mischief.",
"shoves a frothing mug deep into her cleavage, laughing as ale spills everywhere.",
  "lets a mug slide down her busty chest, catching it with a wicked grin.",
  "pours ale between her heavy jugs and drinks it straight from the flow.",
  "clinks her mug against her stacked rack, foam splashing wild.",
  "tips a tankard over her full breasts, licking the foam with a smirk.",
  "presses a frothing mug into her fat cleavage, shaking till it spills over.",
  "balances her axe on her wide bouncy rack, grinning like it’s a party trick.",
  "smears ale foam across her busty chest and licks it off slow.",
  "lets her overflowing tankard slide down her stacked shelf, giggling wickedly.",
  "slams her mug down and makes her hefty jugs jiggle with the cheer.",
  "squeezes her ale-soaked rack together, foam spraying everywhere.",
  "pours brew down her deep valley and drinks from the stream with a roar.",
  "rests her frothy mug on her bouncing tits, hands free and grinning.",
  "shakes her dripping bust so ale splatters the front row.",
  "tucks a tankard between her wobbling melons and drinks hands-free.",
  "presses her mugs tight to her chest, ale spilling like a waterfall.",
  "lets her soft heavy rack jiggle while she chugs a full keg.",
  "rubs her soaked cleavage against her mug before slamming it down.",
  "squeezes her bust hard enough to make the ale foam rise higher.",
  "throws her head back, tits bouncing, ale pouring straight into her mouth.",
  "slaps her barrel-bottom and roars like the tavern shook.",
  "bounces her keg-seat as if daring foes to sit and try.",
  "shakes her thunder rump, laughing like thunder rolling back.",
  "plants her stone buns firm, hips steady as anvils.",
  "swings her axe while her iron haunches flex with joy.",
  "grinds her feast rump as if dancing with the clash.",
  "shakes her round rump roast until the line cheers loud.",
  "drops her mountain mounds low, roaring like a quake.",
  "waggles her stout backside, smirking wickedly mid-brawl.",
  "balances her axe on her tavern shelf, then roars drunk loud.",
  "claps her stout cask once, making the war feel rowdy.",
  "wiggles her brewing buns like she’s stirring the fight itself.",
  "plants her thick rump roast down like a dwarf keg-drop.",
  "rolls her boulder buns, laughing as steel flashes close.",
  "rests her mug on her cellar shelves, then throws it high.",
  "slaps her full moon rump and bellows until echoes break.",
  "flexes her festival haunches like a dancer gone wild.",
  "jiggles her hearthside rump until mugs spill from laughter.",
  "bends with her boar-butt shaking bold as a drumbeat.",
  "plants her feast-seat firm and roars, daring a strike.",
  "claps her rump-kegs together like tankards at a toast.",
  "lets her bounce barrels wobble as she stomps loud.",
  "grinds her taproom rump like it’s tavern music.",
  "bends over her brewer’s backside, then roars with wicked joy.",
  "drums her banquet buns as if calling war to the feast.",
  "rocks her harvest rump with every step into battle.",
  "rests her mug atop her mug-stand and drinks mid-roar.",
  "smacks her plump planks and howls like a warhorn.",
  "balances steel on her ale shelf, laughing loud.",
  "slaps her feast drums like warbeat thunder.",
  "plants her barstool cushions down, roaring like a chair broke.",
  "grinds her brewer’s rump as her axe hums dirty.",
  "drums her feast drums till the front shakes apart.",
  "shakes her taproom kegs until ale feels ready to pour.",
  "drops her plank seat heavy, roaring like tavern brawls.",

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
