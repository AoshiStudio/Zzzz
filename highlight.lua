-- 让团队框架单位在鼠标悬停时高亮
local function HighlightOnMouseOver(frame)
    if frame.highlighted then return end -- 避免重复绑定
    frame.highlighted = true

    frame:SetScript("OnEnter", function()
        frame.healthBar:SetVertexColor(1, 1, 0) -- 亮黄色高亮
    end)

    frame:SetScript("OnLeave", function()
        frame.healthBar:SetVertexColor(1, 1, 1) -- 还原默认颜色
    end)
end

-- 绑定团队框架单位
local function ApplyHighlightToRaidFrames()
    if not CompactRaidFrameContainer.members then return end -- 确保团队框架存在

    for _, frame in pairs(CompactRaidFrameContainer.members) do
        if frame and not frame.highlighted then -- 避免重复绑定
            HighlightOnMouseOver(frame)
        end
    end
end

-- 监听团队更新事件
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD") -- 确保进入游戏时加载
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE") -- 团队成员变动时更新
eventFrame:SetScript("OnEvent", ApplyHighlightToRaidFrames)
