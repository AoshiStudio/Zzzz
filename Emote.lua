-- 1. 建立一个映射表：[法术ID] = "表情名称"
local spellEmoteMap = {
    [11578]  = "charge",    -- 冲锋
    [136080] = "whistle",   -- 嘲讽
    [1161]   = "taunt",     -- 群嘲
    [10901]  = "openfire",  -- 盾
    [14751]  = "taunt",     -- 心灵专注
    [19243]  = "helpme",    -- 绝望祷言
    [10942]  = "flee",      -- 渐隐术
    [10230]  = "train",     -- 冰环
    [20770]  = "train",     -- 冰环（另一级）
}

local function OnEvent(self, event, unit, _, spellID)
    if unit == "player" then
        -- 2. 直接从表中查找，省去了长串的 if-else 判断，效率极高
        local emote = spellEmoteMap[spellID]
        if emote then
            DoEmote(emote, "target")
        end
    end
end

local addon = CreateFrame("Frame")
addon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
addon:SetScript("OnEvent", OnEvent)
