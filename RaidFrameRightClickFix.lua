-- 核心逻辑：将右键菜单的触发从"按下"改为"弹起"
-- 这样当你按住右键拖动视角时，不会触发菜单；只有快速点击并释放时才会触发。

local function FixRaidFrameRightClick(frame)
    if not frame or frame:IsForbidden() then return end
    frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    frame:SetAttribute("type2", "menu")
end

local function ApplyToAllFrames()
    for i = 1, 40 do
        local f = _G["CompactRaidFrame"..i]
        if f then FixRaidFrameRightClick(f) end
    end
end

-- hook 框架布局更新，确保动态新增的框架也能被覆盖
hooksecurefunc("CompactRaidFrameManager_UpdateLayout", ApplyToAllFrames)

local hooker = CreateFrame("Frame")
hooker:RegisterEvent("PLAYER_ENTERING_WORLD")

hooker:SetScript("OnEvent", function(self, event)
    if not InCombatLockdown() then
        ApplyToAllFrames()
    end
end)
