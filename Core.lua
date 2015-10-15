--[[----------------------------------------------------------------------------
	ResearchWhat
	Shows which glyphs you can learn from inscription research.
	Copyright (c) 2015 Phanx. All rights reserved.
	See the accompanying LICENSE.txt file for more information.
	https://github.com/Phanx/ResearchWhat
	
	TODO:
	- Use fallbacks[researchID] if data[researchID] is empty
	- Sort displayed list of possible discoveries
	- Hide or inset scrollbar on the tradeskill detail frame
	- Icon on tradeskill list
------------------------------------------------------------------------------]]
local ADDON, private = ...
local data, fallbacks = private.data, private.fallbacks
local known = {}

local addon = CreateFrame("Frame", ADDON)
addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... ~= ADDON then return end

		local text = TradeSkillDetailScrollChildFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		text:SetJustifyH("LEFT")
		text:SetWidth(290)
		self.discoveryText = text

		self:UnregisterEvent("ADDON_LOADED")
		self:RegisterEvent("TRADE_SKILL_UPDATE")
	else
		for i = 1, GetNumTradeSkills() do
			known[GetTradeSkillInfo(i)] = true
		end

		for researchID, teaches in pairs(data) do
			local researchName = type(researchID) == "number" and GetSpellInfo(researchID)
			if researchName then
				data[researchName] = teaches
				data[researchID] = nil
			end
			for skillID, class in pairs(teaches) do
				local skillName = type(skillID) == "number" and GetSpellInfo(skillID)
				if skillName and not known[skillName] then
					teaches[skillName] = class and "|cff"..(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr or "|cffffffff"
				end
				if skillName or known[skillID] then
					teaches[skillID] = nil
				end
			end
		end

		for masterID, others in pairs(fallbacks) do
			local masterName = GetSpellInfo(masterID)
			if masterName then
				fallbacks[masterName] = others
				fallbacks[masterID] = nil
			end
			for i = #others, 1, -1 do
				local researchID = others[i]
				local researchName = GetSpellInfo(researchID)
				if researchName then
					local done = true
					for spellID, class in pairs(data[researchName]) do
						if type(spellID) == "string" then
							others[spellID] = class
						else
							done = false
						end
					end
					if done then
						tremove(others, i)
					end
				end
			end
		end
	end
end)

--------------------------------------------------------------------------------

hooksecurefunc("TradeSkillFrame_SetSelection", function(i)
	local name = GetTradeSkillInfo(i)
	local unlearned = data[name]
	local empty = unlearned and not next(unlearned) and not IsTradeSkillLinked()
	if unlearned and not empty then
		local text = "Remaining Discoveries:"
		for skillName, color in pairs(unlearned) do
			text = text .. "\n" .. color .. skillName .. "|r"
		end
		local numReagents = GetTradeSkillNumReagents(i)
		addon.discoveryText:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(numReagents - (1 - (numReagents % 2)))], "BOTTOMLEFT", 5, -10)
		addon.discoveryText:SetText(text)
		addon.discoveryText:Show()
	else
		addon.discoveryText:Hide()
		addon.discoveryText:SetText("")
	end
	if unlearned and empty then
		TradeSkillSkillCooldown:SetText(USED) -- "Already Known"
		TradeSkillSkillCooldown:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	end
end)

--------------------------------------------------------------------------------

hooksecurefunc("TradeSkillFrame_Update", function()
	local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
	local filterOffset = TradeSkillFilterBar:IsShown() and 1 or 0
	for i = 1, TRADE_SKILLS_DISPLAYED - filterOffset do
		local name = GetTradeSkillInfo(i + skillOffset)
		if name and data[name] and not next(data[name]) then
			_G["TradeSkillSkill"..(i + filterOffset).."LockedIcon"]:Show()
		end
	end
end)