-- ==========================================
-- 暴雪团队/小队框架综合增强与缩放脚本（含团队标记修复）
-- ==========================================

local RAID_FRAME_SCALE = 0.75  -- 修改缩放比例

------------------------------------------------------------
-- 主监听框体（统一调度所有事件）
------------------------------------------------------------
local addon = CreateFrame("Frame")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("GROUP_ROSTER_UPDATE")
addon:RegisterEvent("RAID_ROSTER_UPDATE")

------------------------------------------------------------
-- 缩放应用
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
-- 团队标记图标：创建与更新
------------------------------------------------------------
local function AddRaidIconToFrame(frame)
    if frame.myRaidIcon then return end
    local icon = frame:CreateTexture(nil, "OVERLAY", nil, 7)
    icon:SetSize(10, 10)
    icon:SetPoint("LEFT", frame, "LEFT", -2, 6)
    icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    frame.myRaidIcon = icon
end

local function UpdateIconOnFrame(frame)
    if not frame.unit then return end
    AddRaidIconToFrame(frame)
    local index = GetRaidTargetIndex(frame.unit)
    if index then
        SetRaidTargetIconTexture(frame.myRaidIcon, index)
        frame.myRaidIcon:Show()
    else
        frame.myRaidIcon:Hide()
    end
end

------------------------------------------------------------
-- 统一事件分发
------------------------------------------------------------
addon:SetScript("OnEvent", function(self, event, ...)
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
    -- 3. 名字字体调整
    --------------------------------------------------------
    if frame.name then
        frame.name:ClearAllPoints()
        frame.name:SetFont("Fonts\\FZLTLC.ttf", 12)
        frame.name:SetPoint("TOP", 0, 0)
        frame.name:SetShadowOffset(-1, -1)
        frame.name:SetShadowColor(0, 0, 0, 1)
    end

    --------------------------------------------------------
    -- 4. 数值字体（按你要求：完全替换成 healthBar.text）
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

    --------------------------------------------------------
    -- 5. 团队标记图标更新
    --------------------------------------------------------
    UpdateIconOnFrame(frame)
	end)
