-- ============================================================
-- Zzzz.lua
-- 重构说明：
--   1. WhoList_Update / GuildStatus_Update 循环增加空值保护，
--      避免结果数量超过实际按钮数量时报错（原始报错的根因）。
--   2. 抽取公共的"安全设置按钮字体/宽度"函数，减少重复代码。
--   3. 字体常量提取为局部变量，避免魔法字符串散落各处，
--      也便于以后统一更换字体。
--   4. 各功能模块添加注释分区，便于维护。
-- ============================================================

-- ------------------------------------------------------------
-- 1. 注册 SharedMedia 字体
-- ------------------------------------------------------------
local ShareFonts = LibStub:GetLibrary("LibSharedMedia-3.0")
local zhCN = ShareFonts.LOCALE_BIT_zhCN

local FONTS_TO_REGISTER = {
    { "方正细黑一",     [[Fonts\FZXHLJW.ttf]] },
    { "方正细黑",       [[Fonts\FZXHJW.TTF]] },
    { "方正隶变",       [[Fonts\FZLBJW.TTF]] },
    { "方正剪纸",       [[Fonts\FZJZJW.TTF]] },
    { "方正北魏楷书",   [[Fonts\FZBWJW.TTF]] },
    { "液晶数字2",      [[Fonts\LCD.TTF]] },
    { "液晶数字",       [[Fonts\ledfont.ttf]] },
    { "汉仪特细等线简", [[Fonts\hyg6gj.TTF]] },
    { "方正兰亭黑长",   [[Fonts\FZLTLC.TTF]] },
}

for _, font in ipairs(FONTS_TO_REGISTER) do
    ShareFonts:Register("font", font[1], font[2], zhCN)
end

-- ------------------------------------------------------------
-- 2. 公共工具函数
-- ------------------------------------------------------------
local LCD_FONT = [[Fonts\ledfont.ttf]]

-- 安全地为一个全局命名的 FontString/Frame 设置字体与宽度。
-- 找不到该控件时直接跳过，避免 "attempt to index a nil value"。
local function SafeSetFontWidth(name, font, size, width)
    local widget = _G[name]
    if not widget then
        return false
    end
    if font then
        widget:SetFont(font, size)
    end
    if width then
        widget:SetWidth(width)
    end
    return true
end

-- ------------------------------------------------------------
-- 3. 公会面板：调整成员列表字体/宽度
-- ------------------------------------------------------------
hooksecurefunc("GuildStatus_Update", function()
    local numMembers = GetNumGuildMembers()
    for i = 1, numMembers do
        local prefix = "GuildFrameButton" .. i

        -- 只要该行按钮不存在（比如超出可见范围），就整行跳过
        if not _G[prefix .. "Name"] then
            break -- 按钮是连续创建的，一旦缺失后面也不会有，直接结束循环
        end

        SafeSetFontWidth(prefix .. "Name",  STANDARD_TEXT_FONT, 9, 90)
        SafeSetFontWidth(prefix .. "Zone",  STANDARD_TEXT_FONT, 9, 110)
        SafeSetFontWidth(prefix .. "Level", LCD_FONT,           9, 20)
        SafeSetFontWidth(prefix .. "Class", STANDARD_TEXT_FONT, 9, 40)

        SafeSetFontWidth("GuildFrameGuildStatusButton" .. i .. "Name", STANDARD_TEXT_FONT, 9)
        SafeSetFontWidth("GuildFrameGuildStatusButton" .. i .. "Rank", STANDARD_TEXT_FONT, 9)
    end
end)

-- ------------------------------------------------------------
-- 4. 查找面板（Who List）：调整结果列表字体/宽度
-- ------------------------------------------------------------
hooksecurefunc("WhoList_Update", function()
    local numResults = C_FriendList.GetNumWhoResults()
    for i = 1, numResults do
        local prefix = "WhoFrameButton" .. i

        -- 结果数量可能超过实际可见按钮数量（界面可滚动），
        -- 一旦某个按钮不存在，后面的索引也不会存在，直接结束循环。
        if not _G[prefix .. "Name"] then
            break
        end

        SafeSetFontWidth(prefix .. "Name",     STANDARD_TEXT_FONT, 10, 90)
        SafeSetFontWidth(prefix .. "Level",    LCD_FONT,           7,  20)
        SafeSetFontWidth(prefix .. "Variable", STANDARD_TEXT_FONT, 9,  110)
        SafeSetFontWidth(prefix .. "Class",    STANDARD_TEXT_FONT, 9,  40)
    end
end)

-- ------------------------------------------------------------
-- 5. 登录 / 进入世界初始化
-- ------------------------------------------------------------
local STICKY_CHAT_TYPES = {
    SAY     = 1,
    PARTY   = 1,
    GUILD   = 1,
    RAID    = 1,
    OFFICER = 0,
    CHANNEL = 0,
    WHISPER = 0,
}

local function ApplyChatStickySettings()
    for chatType, sticky in pairs(STICKY_CHAT_TYPES) do
        if ChatTypeInfo[chatType] then
            ChatTypeInfo[chatType].sticky = sticky
        end
    end
    if ChatTypeInfo.BN_WHISPER then
        ChatTypeInfo.BN_WHISPER.sticky = 0
    end
end

local function ApplyShamanClassColor()
    local shaman = RAID_CLASS_COLORS['SHAMAN']
    if shaman then
        shaman.colorStr = "ff0048de"
        shaman.r = 0
        shaman.g = 0.44
        shaman.b = 0.87
    end
end

local xframe = CreateFrame("Frame")
xframe:RegisterEvent("PLAYER_LOGIN")
xframe:RegisterEvent("PLAYER_ENTERING_WORLD")
xframe:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        -- addonProfilerEnabled 是隐藏CVar，未注册过时直接 SetCVar 可能不生效，
        -- 所以先 RegisterCVar 再 SetCVar，确保真正关闭插件性能分析器。
        C_CVar.RegisterCVar("addonProfilerEnabled", "1")
        C_CVar.SetCVar("addonProfilerEnabled", "0")
        print("|cffFFC0CBAutoProfiler|r: CVar已启用")
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "PLAYER_ENTERING_WORLD" then
        ApplyChatStickySettings()
        ApplyShamanClassColor()
        C_CVar.SetCVar("CursorFreeLookStartDelta", "0")
    end
end)
