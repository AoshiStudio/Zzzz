-- 核心逻辑：将右键菜单的触发从“按下”改为“弹起”
-- 这样当你按住右键拖动视角时，不会触发菜单；只有快速点击并释放时才会触发。

local function FixRaidFrameRightClick(frame)
    if not frame or frame:IsForbidden() then return end

    -- 1. 重新注册点击：让框架在“弹起”时才发送点击指令
    frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    -- 2. 这里的关键在于：1.15.8 的默认行为是按下触发 menu
    -- 我们需要确保属性 attribute 也是在 Up 时触发
    frame:SetAttribute("type2", "menu")
end

-- 针对所有暴雪原版团队框架进行处理
local function ApplyToAllFrames()
    -- 处理 40 个标准的团队框架单元
    for i = 1, 40 do
        local f = _G["CompactRaidFrame"..i]
        if f then
            FixRaidFrameRightClick(f)
        end
    end
    
    -- 处理可能存在的各种组队框架
    for i = 1, 5 do
        local f = _G["CompactPartyFrameMember"..i]
        if f then FixRaidFrameRightClick(f) end
    end
end

-- 监听事件，确保在框架创建后立即应用
local hooker = CreateFrame("Frame")
hooker:RegisterEvent("PLAYER_ENTERING_WORLD")
hooker:RegisterEvent("GROUP_ROSTER_UPDATE")

hooker:SetScript("OnEvent", function(self, event)
    if InCombatLockdown() then
        -- 战斗中无法修改受保护框架，等待脱战
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        ApplyToAllFrames()
        if event == "PLAYER_REGEN_ENABLED" then
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
    end
end)