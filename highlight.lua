--------------------------------------------------
-- 团队框架鼠标悬停高亮插件 (WoW 1.15.9 优化版)
--------------------------------------------------

local highlightedFrames = {}

local function ApplyHighlightToFrame(frame)
    if not frame or highlightedFrames[frame] then return end
    highlightedFrames[frame] = true

    -- 安全地 Hook 原有的 OnEnter 和 OnLeave 脚本
    -- 这样既能实现高亮，又绝不会破坏暴雪底层的任何功能
    
    local oldOnEnter = frame:GetScript("OnEnter")
    frame:SetScript("OnEnter", function(self, ...)
        if oldOnEnter then oldOnEnter(self, ...) end
        
        -- 鼠标移入：设置亮黄色高亮
        if self.background and self.background.SetVertexColor then
            self.background:SetVertexColor(1, 0.9, 0.2, 1) -- 亮黄色，不透明
        end
    end)

    local oldOnLeave = frame:GetScript("OnLeave")
    frame:SetScript("OnLeave", function(self, ...)
        if oldOnLeave then oldOnLeave(self, ...) end
        
        -- 鼠标移出：恢复默认颜色
        if self.background and self.background.SetVertexColor then
            self.background:SetVertexColor(1, 1, 1, 1) -- 恢复默认
        end
    end)
end

-- 扫描并绑定所有团队与小队框架
local function UpdateAllRaidFrames()
    -- 遍历 40 个团队框架
    for i = 1, 40 do
        local f = _G["CompactRaidFrame"..i]
        if f then
            ApplyHighlightToFrame(f)
        end
    end
    
    -- 遍历 5 人小队框架
    for i = 1, 5 do
        local f = _G["CompactPartyFrameMember"..i]
        if f then
            ApplyHighlightToFrame(f)
        end
    end
end

-- 创建事件监听器
local eventF = CreateFrame("Frame")
eventF:RegisterEvent("PLAYER_ENTERING_WORLD")
eventF:RegisterEvent("GROUP_ROSTER_UPDATE")
eventF:RegisterEvent("RAID_ROSTER_UPDATE")
eventF:RegisterEvent("PARTY_MEMBER_ENABLE")

eventF:SetScript("OnEvent", function(self, event)
    -- 如果不在战斗中，立即扫描绑定
    if not InCombatLockdown() then
        UpdateAllRaidFrames()
    else
        -- 如果在战斗中，注册一个脱战事件，等脱战瞬间立刻补全绑定
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
    end

    if event == "PLAYER_REGEN_ENABLED" then
        UpdateAllRaidFrames()
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end)
