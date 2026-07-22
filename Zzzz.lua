-- Register some SharedMedia goodies.

local ShareFonts = LibStub:GetLibrary("LibSharedMedia-3.0")

local zhCN = ShareFonts.LOCALE_BIT_zhCN
        ShareFonts:Register("font", "方正细黑一",				[[Fonts\FZXHLJW.ttf]], zhCN)
        ShareFonts:Register("font", "方正细黑",				        [[Fonts\FZXHJW.TTF]], zhCN)
        ShareFonts:Register("font", "方正隶变",				        [[Fonts\FZLBJW.TTF]], zhCN)
        ShareFonts:Register("font", "方正剪纸",				        [[Fonts\FZJZJW.TTF]], zhCN)
        ShareFonts:Register("font", "方正北魏楷书",				[[Fonts\FZBWJW.TTF]], zhCN)
        ShareFonts:Register("font", "液晶数字2",				[[Fonts\LCD.TTF]], zhCN)
        ShareFonts:Register("font", "液晶数字",				        [[Fonts\ledfont.ttf]], zhCN)
        ShareFonts:Register("font", "汉仪特细等线简",				[[Fonts\hyg6gj.TTF]], zhCN)
        ShareFonts:Register("font", "方正兰亭黑长",				[[Fonts\FZLTLC.TTF]], zhCN)

        
        
--编辑框字框

--ChatFrame1EditBox:SetScale(1.2)
--ChatFrame1EditBox:SetFont(STANDARD_TEXT_FONT,12)

--RaidGroupButton2Name:SetFont(STANDARD_TEXT_FONT, 9)


hooksecurefunc("GuildStatus_Update", function()
    for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
            _G["GuildFrameButton"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 9)  --公会姓名
	    _G["GuildFrameButton"..i.."Name"]:SetWidth(90)
            _G["GuildFrameButton"..i.."Zone"]:SetFont(STANDARD_TEXT_FONT, 9)   --公会地区
            _G["GuildFrameButton"..i.."Zone"]:SetWidth(110)
            _G["GuildFrameButton"..i.."Level"]:SetFont("Fonts\\ledfont.ttf", 9) --公会等级
            _G["GuildFrameButton"..i.."Level"]:SetWidth(20)
            _G["GuildFrameButton"..i.."Class"]:SetFont(STANDARD_TEXT_FONT, 9)   --公会职业
            _G["GuildFrameButton"..i.."Class"]:SetWidth(40)
            _G["GuildFrameGuildStatusButton"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 9)
            _G["GuildFrameGuildStatusButton"..i.."Rank"]:SetFont(STANDARD_TEXT_FONT, 9)
    end
end)

hooksecurefunc("WhoList_Update", function()
    for i = 1, WHOS_TO_DISPLAY, 1 do
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


--[[
local numRaidMembers = GetNumGroupMembers();
       for i = 1, 40 do
            _G["RaidGroupButton"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 10)
            _G["RaidGroupButton"..i.."Name"]:SetWidth(80)
            _G["RaidGroupButton"..i.."Name"]:SetHeight(10)
 --           _G["RaidGroupButton"..i.."Class"].text:SetFont(STANDARD_TEXT_FONT, 10)
 --           _G["RaidGroupButton"..i.."Class"].text:SetWidth(80)
            _G["RaidGroupButton"..i.."Level"]:SetFont(STANDARD_TEXT_FONT, 10)
            _G["RaidGroupButton"..i.."Level"]:SetWidth(10)
            _G["RaidGroupButton"..i.."Rank"]:SetWidth(80)
            _G["RaidGroupButton"..i.."Role"]:SetWidth(10)
            _G["RaidGroupButton"..i.."ReadyCheck"]:SetWidth(10)
       end
]]--
	   


hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
        if frame:IsForbidden() or not frame:IsVisible() or not frame.buffFrames or not DefaultCompactUnitFrameSetupOptions.displayPowerBar then return end
        
        local barHeight = UnitGroupRolesAssigned(frame.displayedUnit) == "HEALER" and 4 or 2.5 --蓝条高度
        
		frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1 + barHeight)
		frame.buffFrames[1]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, CUF_AURA_BOTTOM_OFFSET + barHeight)
		frame.debuffFrames[1]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, CUF_AURA_BOTTOM_OFFSET + barHeight)

--修改自带团队框架上名字的大小和位置
        if frame.name then
		frame.name:ClearAllPoints()
		frame.name:SetFont("Fonts\\FZLTLC.ttf", 12 , "THICK") --字体和文字大小
		frame.name:SetPoint("TOP",0,0) --位置定位
--	 	frame.name:SetTextColor(1, 0, 1)
-- 添加阴影
		frame.name:SetShadowOffset(-1, -1)  -- 轻微偏移，制造立体感
		frame.name:SetShadowColor(0, 0, 0, 1)  -- 黑色阴影，80% 透明度
	end
	if frame.statusText then
		frame.statusText:ClearAllPoints()
		frame.statusText:SetFont("Fonts\\ledfont.TTF", 16 , "THICK") -- 修改状态文本字体
		frame.statusText:SetPoint("TOP",0,-18) --位置定位
		frame.statusText:SetTextColor(0, 1, 0)
		frame.statusText:SetShadowOffset(0, -1)  -- 轻微偏移，制造立体感
		frame.statusText:SetShadowColor(0, 0, 0, 1)  -- 黑色阴影，80% 透明度
	end
end)


--调整暴雪原生团队框架BUFF图标大小，两个0为隐藏
--[[
hooksecurefunc("CompactUnitFrame_UpdateAll",function(f)
        if f.buffFrames then
            for _,d in ipairs(f.buffFrames) do
                d:SetSize(0,0)  --两个0为隐藏
            end
            
        end
end)

--隐藏暴雪原生团队框架BUFF图标
hooksecurefunc("CompactUnitFrame_HideAllBuffs",function(f)
        if f.buffFrames then        
            for i=1, #f.buffFrames do
                f.buffFrames[i]:Hide();
            end
        end
end)


]]--

local xframe = CreateFrame("Frame")
xframe:RegisterEvent("PLAYER_LOGIN")
xframe:RegisterEvent("PLAYER_ENTERING_WORLD")
xframe:SetScript("OnEvent", function(self, event)

	if event == "PLAYER_LOGIN" then
		C_CVar.RegisterCVar("addonProfilerEnabled", "1")
		C_CVar.SetCVar("addonProfilerEnabled", "0")
    
		print("|cffFFC0CBAutoProfiler|r: CVar已启用")
	end

	if event == "PLAYER_ENTERING_WORLD" then
		ChatTypeInfo["SAY"].sticky  	= 1;
		ChatTypeInfo["PARTY"].sticky 	= 1;
		ChatTypeInfo["GUILD"].sticky 	= 1;
		ChatTypeInfo["RAID"].sticky 	= 1;
		ChatTypeInfo["OFFICER"].sticky 	= 0;
		ChatTypeInfo["CHANNEL"].sticky 	= 0;
		ChatTypeInfo["WHISPER"].sticky 	= 0;
		ChatTypeInfo.BN_WHISPER.sticky 	= 0;

		RAID_CLASS_COLORS['SHAMAN']['colorStr']="ff0048de"
		RAID_CLASS_COLORS['SHAMAN']['r']="0"
		RAID_CLASS_COLORS['SHAMAN']['g']="0.44"
		RAID_CLASS_COLORS['SHAMAN']['b']="0.87"

		C_CVar.SetCVar("CursorFreeLookStartDelta", "0" )
		xframe:UnregisterEvent("PLAYER_LOGIN")

	end
end)
