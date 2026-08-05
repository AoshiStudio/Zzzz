-- ==========================================
-- 1. 创建核心的安全状态句柄
-- ==========================================
local SecureHandler = CreateFrame("Frame", "WoWClassicRightClickFixer", UIParent, "SecureHandlerClickTemplate")

-- 按下右键时：备份并抹除 type2，阻止默认菜单
SecureHandler:SetAttribute("_preclick", [[
    local button = ...
    if button == "RightButton" then
        self:SetAttribute("saved_type2", self:GetAttribute("type2"))
        self:SetAttribute("type2", nil)
    end
]])

-- 松开右键时：还原 type2
SecureHandler:SetAttribute("_postclick", [[
    local button = ...
    if button == "RightButton" then
        local saved = self:GetAttribute("saved_type2")
        if saved then
            self:SetAttribute("type2", saved)
        end
    end
]])


-- ==========================================
-- 2. 时间与位移判定逻辑
-- ==========================================
local startX, startY, startTime
local hookedFrames = {}

local function OnCustomMouseDown(self, button)
    if button == "RightButton" then
        startX, startY = GetCursorPosition()
        startTime = GetTime()
        if not IsMouselooking() then
            MouselookStart()
        end
    end
end

local function OnCustomMouseUp(self, button)
    if button == "RightButton" then
        MouselookStop()

        if not startTime then return end

        local endX, endY = GetCursorPosition()
        local duration = GetTime() - startTime
        local deltaX = math.abs(endX - startX)
        local deltaY = math.abs(endY - startY)

        -- 位移小于 5 像素，且按住时间短于 0.2 秒，判定为短按
        if deltaX < 5 and deltaY < 5 and duration < 0.20 then
            if self.unit then
                UnitPopup_ShowMenu(self, "PARTY", self.unit)
            end
        end

        startTime = nil
    end
end


-- ==========================================
-- 3. 绑定到团队框架
-- ==========================================
local function HookRaidFrame(frame)
    if not frame or hookedFrames[frame] then return end
    hookedFrames[frame] = true

    SecureHandler:WrapScript(frame, "OnClick")
    frame:HookScript("OnMouseDown", OnCustomMouseDown)
    frame:HookScript("OnMouseUp", OnCustomMouseUp)
end

local function ApplyToAllFrames()
    if InCombatLockdown() then return end
    for i = 1, 40 do
        local f = _G["CompactRaidFrame"..i]
        if f then HookRaidFrame(f) end
    end
end

-- 覆盖动态新增的框架
hooksecurefunc("CompactRaidFrameManager_UpdateLayout", ApplyToAllFrames)


-- ==========================================
-- 4. 事件监听
-- ==========================================
local hooker = CreateFrame("Frame")
hooker:RegisterEvent("PLAYER_ENTERING_WORLD")
hooker:RegisterEvent("PLAYER_REGEN_ENABLED")

hooker:SetScript("OnEvent", function(self, event)
    ApplyToAllFrames()
    if event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end)
