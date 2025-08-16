-- MadAxe Shout (Turtle WoW, 1.12 compatible)

-- CONFIG
local SPELL_NAME = "Battle Shout" -- change via /mas spell <name> if needed
local COOLDOWN = 5                -- anti-spam seconds
local enabled  = true

-- Classic dungeons (zone names as shown on your client)
local DUNGEON_ZONES = {
    ["Ragefire Chasm"] = true, ["Wailing Caverns"] = true, ["The Deadmines"] = true,
    ["Shadowfang Keep"] = true, ["Blackfathom Deeps"] = true, ["The Stockade"] = true,
    ["Gnomeregan"] = true, ["Scarlet Monastery"] = true, ["Razorfen Kraul"] = true,
    ["Razorfen Downs"] = true, ["Uldaman"] = true, ["Zul'Farrak"] = true,
    ["Maraudon"] = true, ["The Temple of Atal'Hakkar"] = true, -- Sunken Temple
    ["Blackrock Depths"] = true, ["Lower Blackrock Spire"] = true, ["Upper Blackrock Spire"] = true,
    ["Dire Maul"] = true, ["Stratholme"] = true, ["Scholomance"] = true,
    -- add Turtle custom dungeons here:
    -- ["Custom Name"] = true,
}

-- POOLS are loaded from MAS_Emotes.lua / MAS_Yells.lua:
--   emotes, yellEmotes, builtInEmotes

-- -------- utils (no '#' operator anywhere) --------
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

-- -------- core --------
local frame    = CreateFrame("Frame", "MadAxeShoutFrame")
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
            local em = rand(builtInEmotes)
            if em then DoEmote(em) end
        else
            local msg = rand(emotes)
            if msg then SendChatMessage(msg, "EMOTE") end
        end
    else
        -- 30% built-in, 70% EMOTE
        if r < 0.30 then
            local em = rand(builtInEmotes)
            if em then DoEmote(em) end
        else
            local msg = rand(emotes)
            if msg then SendChatMessage(msg, "EMOTE") end
        end
    end
end

-- Detect Battle Shout via classic chat event
local function onSpellSelfBuff(msg)
    if not enabled or not msg or msg == "" then return end
    if string.find(msg, SPELL_NAME, 1, true) then
        fireOne()
    end
end

-- -------- events --------
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
        math.randomseed(GetTime())
    elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
        onSpellSelfBuff(arg1)
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "MINIMAP_ZONE_CHANGED" then
        -- nothing needed; isDungeon() reads zone text on demand
    end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("MINIMAP_ZONE_CHANGED")

-- -------- slash commands --------
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
        DEFAULT_CHAT_FRAME:AddMessage("|cffff5500MadAxeShout|r commands: /mas on, /mas off, /mas test, /mas spell <name>")
    end
end
