-------------------------------------------------------
-- 
-- 
-- 
-------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "Blizzard_RaidUI" then
        C_Timer.After(1, function()
            for i = 1, 40 do
                local button = "RaidGroupButton"..i
                if button then
                    _G[button]:SetAttribute("type", "target")
                    _G[button]:SetAttribute("unit", button.unit)
                    _G[button.."Class"].text:SetFont(STANDARD_TEXT_FONT, 8)
                    _G[button.."Name"]:SetFont(STANDARD_TEXT_FONT, 10)
                    _G[button.."Name"]:SetWidth(70)
                    _G[button.."Name"]:SetHeight(10)
                    _G[button.."Level"]:SetFont("Fonts\\ledfont.ttf", 8)
                    _G[button.."Level"]:SetWidth(12)
                    _G[button.."Rank"]:SetWidth(8)
                    _G[button.."Role"]:SetWidth(8)
                    _G[button.."ReadyCheck"]:SetWidth(8)
                end
            end
        end)
        f:UnregisterEvent("ADDON_LOADED")
    end
end)
