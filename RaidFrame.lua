-- ==========================================
-- 暴雪团队/小队框架综合增强与缩放脚本（最终正确版）
-- ==========================================

local RAID_FRAME_SCALE = 0.7  -- 修改缩放比例

------------------------------------------------------------
-- 正确缩放：直接缩放实际框体（不会报错，不依赖 EditMode）
------------------------------------------------------------
local function ApplyRaidFrameScale()
    if CompactRaidFrameContainer then
        CompactRaidFrameContainer:SetScale(RAID_FRAME_SCALE)
    end
    if CompactPartyFrame then
        CompactPartyFrame:SetScale(RAID_FRAME_SCALE)
    end
end

------------------------------------------------------------
-- 事件监听：进入世界、队伍变化、团队变化时应用缩放
------------------------------------------------------------
local addonFrame = CreateFrame("Frame")
addonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
addonFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
addonFrame:RegisterEvent("RAID_ROSTER_UPDATE")

addonFrame:SetScript("OnEvent", function()
    ApplyRaidFrameScale()
end)

------------------------------------------------------------
-- 团队框体内部元素美化与逻辑更新
------------------------------------------------------------
hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
    if not frame or (type(frame.IsForbidden) == "function" and frame:IsForbidden()) then return end
    if not frame:IsVisible() then return end

    --------------------------------------------------------
    -- 1. 血条与能量条高度适配
    --------------------------------------------------------
    if frame.healthBar and frame.displayedUnit then
        local barHeight = UnitGroupRolesAssigned(frame.displayedUnit) == "HEALER" and 4 or 2.5
        frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1 + barHeight)
        
        if frame.buffFrames and frame.buffFrames[1] then
            frame.buffFrames[1]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, (CUF_AURA_BOTTOM_OFFSET or 0) + barHeight)
        end
        if frame.debuffFrames and frame.debuffFrames[1] then
            frame.debuffFrames[1]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, (CUF_AURA_BOTTOM_OFFSET or 0) + barHeight)
        end
    end

    --------------------------------------------------------
    -- 2. 职责图标调整
    --------------------------------------------------------
    if frame.roleIcon then
        frame.roleIcon:SetSize(8, 8)
        frame.roleIcon:ClearAllPoints()
        frame.roleIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    end

    --------------------------------------------------------
    -- 3. 团队标记（正确版）
    --------------------------------------------------------
    if frame.raidTargetIcon and frame.displayedUnit then
        CompactUnitFrame_UpdateRaidTarget(frame)

        local index = GetRaidTargetIndex(frame.displayedUnit)
        if index then
            frame.raidTargetIcon:SetSize(12, 12)
            frame.raidTargetIcon:ClearAllPoints()
            frame.raidTargetIcon:SetPoint("LEFT", frame, "LEFT", 2, 0)
            frame.raidTargetIcon:SetDrawLayer("OVERLAY", 7)
        end
    end

    --------------------------------------------------------
    -- 4. 名字字体调整
    --------------------------------------------------------
    if frame.name then
        frame.name:ClearAllPoints()
        frame.name:SetFont("Fonts\\FZLTLC.ttf", 12)
        frame.name:SetPoint("TOP", 0, 0)
        frame.name:SetShadowOffset(-1, -1)
        frame.name:SetShadowColor(0, 0, 0, 1)
    end

    --------------------------------------------------------
    -- 5. 数值字体（按你要求：完全替换成 healthBar.text）
    --------------------------------------------------------
 --[[    if frame.statusText then
        frame.statusText:ClearAllPoints()
        frame.statusText:SetFont("Fonts\\ledfont.TTF", 16, "THICKOUTLINE")
        frame.statusText:SetPoint("TOP", frame, "TOP", 0, -18)
        frame.statusText:SetTextColor(0, 1, 0)
        frame.statusText:SetShadowOffset(0, -1)
        frame.statusText:SetShadowColor(0, 0, 0, 1)
    end
]]--
    if frame.hbcStatusText then
        frame.hbcStatusText:ClearAllPoints()
        frame.hbcStatusText:SetFont("Fonts\\ledfont.TTF", 16, "THICKOUTLINE")
        frame.hbcStatusText:SetPoint("TOP", frame, "TOP", 0, -15)
        frame.hbcStatusText:SetTextColor(0, 1, 0)
        frame.hbcStatusText:SetShadowOffset(0, -1)
        frame.hbcStatusText:SetShadowColor(0, 0, 0, 1)
    end
	end)