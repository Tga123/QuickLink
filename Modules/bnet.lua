local QuickLink = LibStub("AceAddon-3.0"):GetAddon("QuickLink")
local QuickLink_BNET = QuickLink:NewModule("QuickLink_BNET", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuickLink", true)

-- There must be a better way!
function QuickLink_BNET:FriendsFrame_ShowBNDropdown(name, connected, lineID, chatType, chatFrame, friendsList, bnetIDAccount)
	local index = nil

	local client = C_BattleNet.GetAccountInfoByID(bnetIDAccount).gameAccountInfo.clientProgram
	
	for i, value in pairs(UnitPopupMenus["BN_FRIEND"]) do
		if value == "QUICKLINK" then
			index = i
		end
	end
	if client == BNET_CLIENT_WOW then
		if index == nil then
			table.insert(UnitPopupMenus["BN_FRIEND"], #(UnitPopupMenus["BN_FRIEND"]), "QUICKLINK");
		end
	else
		if index ~= nil then
			table.remove(UnitPopupMenus["BN_FRIEND"], index)
		end
	end
	self.hooks["FriendsFrame_ShowBNDropdown"](name, connected, lineID, chatType, chatFrame, friendsList, bnetIDAccount);
end

function QuickLink_BNET:OnEnable()
	QuickLink_BNET:RawHook("FriendsFrame_ShowBNDropdown", true);
end
