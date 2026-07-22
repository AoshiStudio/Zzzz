local function OnEvent(self, event, ...)
    if event == "UNIT_SPELLCAST_SENT" then
        local caster, target, _,spellID = ...
    if caster == "player" then
--        if spellID == 10917 then DoEmote("charge",target)  end --快速治疗
        if spellID == 100 then DoEmote("charge",target)  end --冲锋
        if spellID == 11578 then DoEmote("charge",target)  end --快速治疗
        if spellID == 136080 then DoEmote("whistle",target)  end  --嘲讽
        if spellID == 1161 then DoEmote("taunt",target)  end  --群嘲
        if spellID == 10901 then DoEmote("openfire",target)  end  --盾
        if spellID == 14751 then DoEmote("taunt",target)  end  --心灵专注
        if spellID == 19243 then DoEmote("helpme",target)  end  --绝望祷言
        if spellID == 10942 then DoEmote("flee",target)  end  --渐隐术
        if spellID == 10230 then DoEmote("train",target)  end  --冰环
--        if spellID == 11567 then DoEmote("whistle",target)  end  --英勇打击
--        if spellID == 71 then DoEmote("moo",target)  end  --姿态
--        if spellID == 2457 then DoEmote("moo",target)  end  --姿态
--        if spellID == 2458 then DoEmote("moo",target)  end  --姿态
        if spellID == 20770 then DoEmote("train",target)  end  --冰环
    end
end
end


local addon = CreateFrame("Frame")
addon:RegisterEvent("UNIT_SPELLCAST_SENT")
--addon:RegisterEvent("SPELL_CAST_SUCCESS")
addon:SetScript("OnEvent", OnEvent)

--function DoEmote(emote)
--    SendChatMessage("/" .. emote, "SAY")
--end


-- 将 YOUR_SPELL_ID 替换为您想监听的法术 ID。

-- 将 YOUR_EMOTE 替换为您想触发的表情名称（如 bow、dance 等）。

