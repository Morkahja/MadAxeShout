-- MadAxe Shout (Turtle WoW, 1.12 API)

-- CONFIG
local SPELL_NAME = "Battle Shout" -- change if you play on a non-English client
local COOLDOWN = 5 -- seconds anti-spam
local enabled = true

-- Classic dungeon list (zone names as they appear on your client)
local DUNGEON_ZONES = {
    ["Ragefire Chasm"] = true,
    ["Wailing Caverns"] = true,
    ["The Deadmines"] = true,
    ["Shadowfang Keep"] = true,
    ["Blackfathom Deeps"] = true,
    ["The Stockade"] = true,
    ["Gnomeregan"] = true,
    ["Scarlet Monastery"] = true,
    ["Razorfen Kraul"] = true,
    ["Razorfen Downs"] = true,
    ["Uldaman"] = true,
    ["Zul'Farrak"] = true,
    ["Maraudon"] = true,
    ["The Temple of Atal'Hakkar"] = true, -- Sunken Temple
    ["Blackrock Depths"] = true,
    ["Lower Blackrock Spire"] = true,
    ["Upper Blackrock Spire"] = true,
    ["Dire Maul"] = true, -- covers East/West/North
    ["Stratholme"] = true,
    ["Scholomance"] = true,
    -- Add Turtle WoW custom dungeons here by their zone text:
    -- ["Custom Dungeon Name"] = true,
}

-- POOLS are loaded from MAS_Emotes.lua and MAS_Yells.lua:
--   emotes, yellEmotes, builtInEmotes

-- STATE
local frame = CreateFrame("Frame", "MadAxeShoutFrame")
local lastFire = 0
local currentZone = nil

-- UTILS
local function rand(t) return t[math.random(1, #t)] end

local function isDungeon()
    -- Vanilla has no IsInInstance, so we check zone text against a list
    local z = GetRealZoneText() or GetZoneText()
    if not z then return false end
    return DUNGEON_ZONES[z] == true
end

local function fireOne()
    local now = GetTime()
    if now - lastFire < COOLDOWN then return end
    lastFire = now

    local r = math.random()
    if isDungeon() then
        -- 30% yell, 30% built-in, 40% emote
        if r < 0.30 then
            if yellEmotes and #yellEmotes > 0 then
                SendChatMessage(rand(yellEmotes), "YELL")
            end
        elseif r < 0.60 then
            if builtInEmotes and #builtInEmotes > 0 then
                DoEmote(rand(builtInEmotes))
            end
        else
            if emotes and #emotes > 0 then
                SendChatMessage(rand(emotes), "EMOTE")
            end
        end
    else
        -- 30% built-in, 70% emote
        if r < 0.30 then
            if builtInEmotes and #builtInEmotes > 0 then
                DoEmote(rand(builtInEmotes))
            end
        else
            if emotes and #emotes > 0 then
                SendChatMessage(rand(emotes), "EMOTE")
            end
        end
    end
end

-- DETECTION (1.12): listen to spell chat event for self buffs
-- English client example line: "You cast Battle Shout."
-- We'll look for the spell name within the message.
local function onSpellSelfBuff(msg)
    if not msg or msg == "" then return end
    if string.find(msg, SPELL_NAME, 1, true) then
        fireOne()
    end
end

-- EVENTS
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
        math.randomseed(GetTime())
        currentZone = GetRealZoneText() or GetZoneText()
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "MINIMAP_ZONE_CHANGED" then
        currentZone = GetRealZoneText() or GetZoneText()
    elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
        onSpellSelfBuff(arg1)
    end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("MINIMAP_ZONE_CHANGED")
frame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")

-- SLASH
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
        -- /mas spell Battle Shout (change localized name)
        local n = string.match(msg, "^spell%s+(.+)$")
        if n and n ~= "" then
            SPELL_NAME = n
            DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r spell set to: "..SPELL_NAME)
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r commands: /mas on, /mas off, /mas test, /mas spell <name>")
    end
end