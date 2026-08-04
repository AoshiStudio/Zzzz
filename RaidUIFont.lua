-------------------------------------------------------
-- 旧版团队界面字体与属性优化脚本 (WoW 1.15.9 优化版)
-------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "Blizzard_RaidUI" then
        
        -- 定义一个应用修改的本地函数
        local function ApplyRaidUIFontAndAttributes()
            -- 如果当前处于战斗中，直接跳过，等待脱战后再由事件触发
            if InCombatLockdown() then return end

            for i = 1, 40 do
                local name = "RaidGroupButton"..i
                local btn = _G[name]
                
                -- 只有当按钮实际存在时才进行修改，防止 nil 报错
                if btn then
                    -- 1. 安全设置点击属性
                    if btn.unit then
                        btn:SetAttribute("type", "target")
                        btn:SetAttribute("unit", btn.unit)
                    end
                    
                    -- 2. 优化职业文本字体
                    local classText = _G[name.."Class"]
                    if classText and classText.text then
                        classText.text:SetFont(STANDARD_TEXT_FONT, 8)
                    end
                    
                    -- 3. 优化名字文本字体及尺寸
                    local nameText = _G[name.."Name"]
                    if nameText then
                        nameText:SetFont(STANDARD_TEXT_FONT, 10)
                        nameText:SetWidth(70)
                        nameText:SetHeight(10)
                    end
                    
                    -- 4. 优化等级字体及尺寸
                    local levelText = _G[name.."Level"]
                    if levelText then
                        -- 注意：如果你的 Fonts 文件夹下没有 ledfont.ttf，建议换成 STANDARD_TEXT_FONT 以防报错
                        levelText:SetFont("Fonts\\ledfont.ttf", 8)
                        levelText:SetWidth(12)
                    end
                    
                    -- 5. 调整其他小图标宽度
                    local rank = _G[name.."Rank"]
                    if rank then rank:SetWidth(8) end
                    
                    local role = _G[name.."Role"]
                    if role then role:SetWidth(8) end
                    
                    local readyCheck = _G[name.."ReadyCheck"]
                    if readyCheck then readyCheck:SetWidth(8) end
                end
            end
        end

        -- 延迟 1 秒执行，确保暴雪界面完全加载
        C_Timer.After(1, function()
            ApplyRaidUIFontAndAttributes()
        end)

        -- 额外增加一个脱战自动刷新监听，防止战斗中加载导致属性修改被拦截
        local combatWatch = CreateFrame("Frame")
        combatWatch:RegisterEvent("PLAYER_REGEN_ENABLED")
        combatWatch:SetScript("OnEvent", function()
            ApplyRaidUIFontAndAttributes()
        end)

        f:UnregisterEvent("ADDON_LOADED")
    end
end)