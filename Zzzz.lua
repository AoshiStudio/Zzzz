-- Register some SharedMedia goodies.

local ShareFonts = LibStub:GetLibrary("LibSharedMedia-3.0")

local zhCN = ShareFonts.LOCALE_BIT_zhCN
        ShareFonts:Register("font", "方正细黑一",          [[Fonts\FZXHLJW.ttf]], zhCN)
        ShareFonts:Register("font", "方正细黑",            [[Fonts\FZXHJW.TTF]], zhCN)
        ShareFonts:Register("font", "方正隶变",            [[Fonts\FZLBJW.TTF]], zhCN)
        ShareFonts:Register("font", "方正剪纸",            [[Fonts\FZJZJW.TTF]], zhCN)
        ShareFonts:Register("font", "方正北魏楷书",        [[Fonts\FZBWJW.TTF]], zhCN)
        ShareFonts:Register("font", "液晶数字2",           [[Fonts\LCD.TTF]], zhCN)
        ShareFonts:Register("font", "液晶数字",            [[Fonts\ledfont.ttf]], zhCN)
        ShareFonts:Register("font", "汉仪特细等线简",      [[Fonts\hyg6gj.TTF]], zhCN)
        ShareFonts:Register("font", "方正兰亭黑长",        [[Fonts\FZLTLC.TTF]], zhCN)


hooksecurefunc("GuildStatus_Update", function()
    local numMembers = GetNumGuildMembers()
    for i = 1, numMembers do
            _G["GuildFrameButton"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 9)
            _G["GuildFrameButton"..i.."Name"]:SetWidth(90)
            _G["GuildFrameButton"..i.."Zone"]:SetFont(STANDARD_TEXT_FONT, 9)
            _G["GuildFrameButton"..i.."Zone"]:SetWidth(110)
            _G["GuildFrameButton"..i.."Level"]:SetFont("Fonts\\ledfont.ttf", 9)
            _G["GuildFrameButton"..i.."Level"]:SetWidth(20)
            _G["GuildFrameButton"..i.."Class"]:SetFont(STANDARD_TEXT_FONT, 9)
            _G["GuildFrameButton"..i.."Class"]:SetWidth(40)
            _G["GuildFrameGuildStatusButton"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 9)
            _G["GuildFrameGuildStatusButton"..i.."Rank"]:SetFont(STANDARD_TEXT_FONT, 9)
    end
end)

hooksecurefunc("WhoList_Update", function()
    local numResults = C_FriendList.GetNumWhoResults()
    for i = 1, numResults do
        _G["WhoFrameButton"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 10)
        _G["WhoFrameButton"..i.."Name"]:SetWidth(90)
        _G["WhoFrameButton"..i.."Level"]:SetFont("Fonts\\ledfont.ttf", 7)
        _G["WhoFrameButton"..i.."Level"]:SetWidth(20)
        _G["WhoFrameButton"..i.."Variable"]:SetFont(STANDARD_TEXT_FONT, 9)
        _G["WhoFrameButton"..i.."Variable"]:SetWidth(110)
        _G["WhoFrameButton"..i.."Class"]:SetFont(STANDARD_TEXT_FONT, 9)
        _G["WhoFrameButton"..i.."Class"]:SetWidth(40)
    end
end)


hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
        if frame:IsForbidden() or not frame:IsVisible() or not frame.buffFrames or not DefaultCompactUnitFrameSetupOptions.displayPowerBar then return end

        local barHeight = UnitGroupRolesAssigned(frame.displayedUnit) == "HEALER" and 4 or 2.5

        frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1 + barHeight)
        frame.buffFrames[1]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, CUF_AURA_BOTTOM_OFFSET + barHeight)
        frame.debuffFrames[1]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, CUF_AURA_BOTTOM_OFFSET + barHeight)

        if frame.name then
            frame.name:ClearAllPoints()
            frame.name:SetFont("Fonts\\FZLTLC.ttf", 12, "THICK")
            frame.name:SetPoint("TOP", 0, 0)
            frame.name:SetShadowOffset(-1, -1)
            frame.name:SetShadowColor(0, 0, 0, 1)
        end
        if frame.statusText then
            frame.statusText:ClearAllPoints()
            frame.statusText:SetFont("Fonts\\ledfont.TTF", 16, "THICK")
            frame.statusText:SetPoint("TOP", 0, -18)
            frame.statusText:SetTextColor(0, 1, 0)
            frame.statusText:SetShadowOffset(0, -1)
            frame.statusText:SetShadowColor(0, 0, 0, 1)
        end
end)


local xframe = CreateFrame("Frame")
xframe:RegisterEvent("PLAYER_LOGIN")
xframe:RegisterEvent("PLAYER_ENTERING_WORLD")
xframe:SetScript("OnEvent", function(self, event)

    if event == "PLAYER_LOGIN" then
        C_CVar.SetCVar("addonProfilerEnabled", "0")
        print("|cffFFC0CBAutoProfiler|r: CVar已启用")
        self:UnregisterEvent("PLAYER_LOGIN")
    end

    if event == "PLAYER_ENTERING_WORLD" then
        ChatTypeInfo["SAY"].sticky      = 1
        ChatTypeInfo["PARTY"].sticky    = 1
        ChatTypeInfo["GUILD"].sticky    = 1
        ChatTypeInfo["RAID"].sticky     = 1
        ChatTypeInfo["OFFICER"].sticky  = 0
        ChatTypeInfo["CHANNEL"].sticky  = 0
        ChatTypeInfo["WHISPER"].sticky  = 0
        ChatTypeInfo.BN_WHISPER.sticky  = 0

        RAID_CLASS_COLORS['SHAMAN']['colorStr'] = "ff0048de"
        RAID_CLASS_COLORS['SHAMAN']['r'] = 0
        RAID_CLASS_COLORS['SHAMAN']['g'] = 0.44
        RAID_CLASS_COLORS['SHAMAN']['b'] = 0.87

        C_CVar.SetCVar("CursorFreeLookStartDelta", "0")
    end
end)
