--[[----------------------------------------------------------------------------
	Researcher
	Shows which recipes you can learn from research.
	Copyright (c) 2015 Phanx. All rights reserved.
	See the accompanying LICENSE.txt file for more information.
	https://github.com/Phanx/ResearchWhat
	
	TODO:
	- Use fallbacks[researchID] if data[researchID] is empty
	- Sort displayed list of possible discoveries
	  - Partly done - sorted by name. Maybe supersort by class?
	- Hide or inset scrollbar on the tradeskill detail frame
	- Icon on tradeskill list
------------------------------------------------------------------------------]]
local ADDON, private = ...
local data, fallbacks = private.GetData()
local known = {}

local function RemoveKnown(t)
	for research, skills in pairs(t) do
		for skill in pairs(skills) do
			if known[skill] then
				skills[skill] = nil
			end
		end
		if not next(skills) then
			research[skills] = nil
		end
	end
end

local addon = CreateFrame("Frame", ADDON)
addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... ~= ADDON then return end

		local text = TradeSkillDetailScrollChildFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		text:SetJustifyH("LEFT")
		text:SetWidth(290)
		self.discoveryText = text

		local scrollBarMiddle = TradeSkillDetailScrollFrame.ScrollBar:CreateTexture(nil, "BACKGROUND")
		scrollBarMiddle:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-ScrollBar")
		scrollBarMiddle:SetPoint("TOPLEFT", TradeSkillDetailScrollFrameTop, "BOTTOMLEFT")
		scrollBarMiddle:SetPoint("BOTTOMRIGHT", TradeSkillDetailScrollFrameBottom, "TOPRIGHT")
		scrollBarMiddle:SetTexCoord(0, 0.46875, 0.2, 0.9609375)
		
		TradeSkillDetailScrollFrameTop:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame, "TOPRIGHT", -3, 5)
		TradeSkillDetailScrollFrameBottom:SetPoint("BOTTOMLEFT", TradeSkillDetailScrollFrame, "BOTTOMRIGHT", -3, -2)

		self:UnregisterEvent("ADDON_LOADED")
		self:RegisterEvent("TRADE_SKILL_UPDATE")
	else
		data, fallbacks = private.GetData()
		for i = 1, GetNumTradeSkills() do
			known[GetTradeSkillInfo(i)] = true
		end
		RemoveKnown(data)
		RemoveKnown(fallbacks)
		if TradeSkillFrame.selectedSkill then
			TradeSkillFrame_SetSelection(TradeSkillFrame.selectedSkill)
		end
	end
end)

--------------------------------------------------------------------------------

local sortedNames = {}
hooksecurefunc("TradeSkillFrame_SetSelection", function(i)
	local name = GetTradeSkillInfo(i)
	local unlearned = data[name]
	local empty = unlearned and not next(unlearned) and not IsTradeSkillLinked()
	if unlearned and not empty then
		wipe(sortedNames)
		for skillName, coloredName in pairs(unlearned) do
			if type(skillName) == "string" then
				sortedNames[#sortedNames+1] = skillName
			end
		end
		sort(sortedNames)
		local text = "Remaining Discoveries:"
		for i = 1, #sortedNames do
			text = text .. "\n" .. unlearned[sortedNames[i]]
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
	TradeSkillDetailScrollFrameScrollBar:SetValue(0)
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