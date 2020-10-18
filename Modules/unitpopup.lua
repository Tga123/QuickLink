local QuickLink = LibStub("AceAddon-3.0"):GetAddon("QuickLink")
local QuickLink_UNIT_POPUP = QuickLink:NewModule("QuickLink_UNIT_POPUP", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuickLink", true)

------------------------------------------------------------------------
-- Target/Player Frame context menu
------------------------------------------------------------------------
function QuickLink_UNIT_POPUP:updateContextMenu()
	UnitPopupButtons["QUICKLINK"] = {text = L["ADDONNAME"], nested = 1 };
	UnitPopupMenus["QUICKLINK"] = {}
	for i, page in pairs(QuickLinkPages) do
        if table:get(page, "enabled", true) then
            UnitPopupButtons["QUICKLINK_PAGE"..i] = {text = page.name};
            table.insert(UnitPopupMenus["QUICKLINK"], "QUICKLINK_PAGE"..i);
        end
	end
end

function addContextMenu()
	table.insert(UnitPopupMenus["SELF"], #(UnitPopupMenus["SELF"]), "QUICKLINK");
	table.insert(UnitPopupMenus["PARTY"], #(UnitPopupMenus["PARTY"]), "QUICKLINK");
	table.insert(UnitPopupMenus["PLAYER"], #(UnitPopupMenus["PLAYER"]), "QUICKLINK");
	table.insert(UnitPopupMenus["RAID_PLAYER"], #(UnitPopupMenus["RAID_PLAYER"]), "QUICKLINK");
	table.insert(UnitPopupMenus["GUILD"], #(UnitPopupMenus["GUILD"]), "QUICKLINK");
	table.insert(UnitPopupMenus["GUILD_OFFLINE"], #(UnitPopupMenus["GUILD_OFFLINE"]), "QUICKLINK");
	table.insert(UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"], #(UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"]), "QUICKLINK");
	table.insert(UnitPopupMenus["FRIEND"], #(UnitPopupMenus["FRIEND"]), "QUICKLINK");
	table.insert(UnitPopupMenus["FRIEND_OFFLINE"], #(UnitPopupMenus["FRIEND_OFFLINE"]), "QUICKLINK");
	table.insert(UnitPopupMenus["CHAT_ROSTER"], #(UnitPopupMenus["CHAT_ROSTER"]), "QUICKLINK");
end

function QuickLink_UNIT_POPUP:UnitPopup_OnClick(self)
	local menu = UIDROPDOWNMENU_INIT_MENU
	local index, matches = string.gsub(self.value, "QUICKLINK_PAGE", "")
	local name,server
	if matches == 1 then
		if menu['bnetIDAccount'] then  -- a bit hackish detection if we are in the BNet friendlist
			local client = C_BattleNet.GetAccountInfoByID(menu['bnetIDAccount']).gameAccountInfo.clientProgram
			if client == BNET_CLIENT_WOW then
				name = C_BattleNet.GetAccountInfoByID(menu['bnetIDAccount']).gameAccountInfo.characterName
				server = C_BattleNet.GetAccountInfoByID(menu['bnetIDAccount']).gameAccountInfo.realmName
			end
		else
			name, server = menu['name'], menu['server']
		end
		if name then
			if not server then server = GetRealmName() end
			QuickLink:ShowUrlFrame(QuickLinkPages[tonumber(index)].name, QuickLinkPages[tonumber(index)].url, name, server);
		end
	end
end

function QuickLink_UNIT_POPUP:OnEnable()
	QuickLink_UNIT_POPUP:updateContextMenu()
	addContextMenu()
	QuickLink_UNIT_POPUP:SecureHook("UnitPopup_OnClick");
end
