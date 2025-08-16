-- MadAxeBuxbrew.lua
-- Buxbrew Battle Shout Emotes Addon

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_AURAS_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Saved config
MadAxeBuxbrewSaved = MadAxeBuxbrewSaved or {}
local spellName = MadAxeBuxbrewSaved.spellName or "Battle Shout"
local lastTrigger = 0

-- Emotes pool
local emotes = {
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

-- Helper to pick random emote
local function GetRandomEmote()
    return emotes[math.random(1, table.getn(emotes))]
end

-- Slash command to change spell name
SLASH_MADAXEBUXBREW1 = "/mae"
SlashCmdList["MADAXEBUXBREW"] = function(msg)
    local cmd, rest = msg:match("^(%S*)%s*(.-)$")
    if cmd == "spell" and rest ~= "" then
        spellName = rest
        MadAxeBuxbrewSaved.spellName = rest
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew:|r Watching spell: " .. rest)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8800MadAxeBuxbrew usage:|r /mae spell <Battle Shout name>")
    end
end

-- Aura check
local function CheckAura()
    for i=1,40 do
        local name = UnitBuff("player", i)
        if not name then break end
        if name == spellName then
            local now = GetTime()
            if now - lastTrigger > 4 then
                lastTrigger = now
                local emote = GetRandomEmote()
                SendChatMessage(emote, "EMOTE")
            end
            break
        end
    end
end

-- Event handler
frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_AURAS_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
        CheckAura()
    end
end)

-- Seed randomness
math.randomseed(time())
