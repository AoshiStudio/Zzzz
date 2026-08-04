-- ==========================================
-- 1. 创建核心的安全状态句柄（用于在战斗中安全抹除属性）
-- ==========================================
local SecureHandler = CreateFrame("Frame", "WoWClassicRightClickFixer", UIParent, "SecureHandlerClickTemplate")

-- 当玩家【按下】右键时触发的安全片段（字符串形式，战斗中可用）
SecureHandler:SetAttribute("_preclick", [[
    local button = ...
    if button == "RightButton" then
        -- 备份原始的右键属性（通常是 "togglemenu"）
        self:SetAttribute("saved_type2", self:GetAttribute("type2"))
        -- 瞬间抹除右键属性，让这次点击变成“废键”，从而阻止暴雪默认的菜单弹出
        self:SetAttribute("type2", nil)
    end
]])

-- 当玩家【松开】右键时触发的安全片段
SecureHandler:SetAttribute("_postclick", [[
    local button = ...
    if button == "RightButton" then
        -- 无论刚才发生了什么，松开时把原始属性还给框架，保证框架功能不坏
        if self:GetAttribute("saved_type2") then
            self:SetAttribute("type2", self:GetAttribute("saved_type2"))
        end
    end
]])


-- ==========================================
-- 2. 常规环境下的时间与位移判定逻辑（处理长按/短按）
-- ==========================================
local startX, startY, startTime

local function OnCustomMouseDown(self, button)
    if button == "RightButton" then
        -- 记录按下的初始位置和绝对时间
        startX, startY = GetCursorPosition()
        startTime = GetTime()
        
        -- 核心爽点：立刻启动暴雪底层的视角转动（指针会自动隐藏）
        MouselookStart()
    end
end

local function OnCustomMouseUp(self, button)
    if button == "RightButton" then
        -- 无论如何，松开时停止转视角（指针恢复显示）
        MouselookStop()
        
        -- 如果没按下过，或者数据断层，直接返回
        if not startTime then return end
        
        -- 计算松开时的位移和持续时间
        local endX, endY = GetCursorPosition()
        local endTime = GetTime()
        local deltaX = math.abs(endX - startX)
        local deltaY = math.abs(endY - startY)
        local duration = endTime - startTime
        
        -- 【黄金判定线】：位移小于 5 像素，且按住时间短于 0.2 秒
        if deltaX < 5 and deltaY < 5 and duration < 0.20 then
            -- 判定为：纯粹的短按！我们需要手动把右键菜单调出来
            if self.unit then
                -- 适用于 1.14 / 1.15+ (Classic Era) 版本的官方通用菜单弹出函数
                ToggleDropDownMenu(1, nil, _G[self:GetName().."DropDown"], "cursor", 0, 0)
            end
        end
        
        -- 清空临时变量
        startTime = nil
    end
end


-- ==========================================
-- 3. 怎么把它绑定到具体的团队框架上？
-- ==========================================
-- 定义一个绑定函数
local function HookMyRaidFrame(frame)
    if not frame then return end
    
    -- 绑定安全句柄（让 _preclick 和 _postclick 生效）
    SecureHandler:WrapScript(frame, "OnClick")
    
    -- 绑定常规鼠标监听（让时间、位移计算生效）
    frame:HookScript("OnMouseDown", OnCustomMouseDown)
    frame:HookScript("OnMouseUp", OnCustomMouseUp)
end

-- 【示例演示】：把它应用到暴雪系统自带的“团队框架 1”上
-- 在实际插件中，你可以在框架初始化（如 CompactRaidFrameContainer_OnLoad）时去循环 Hook 所有的框架
if CompactRaidFrame1 then
    HookMyRaidFrame(CompactRaidFrame1)
end