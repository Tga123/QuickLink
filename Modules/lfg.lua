local QuickLink = LibStub("AceAddon-3.0"):GetAddon("QuickLink")
local QuickLink_LFG = QuickLink:NewModule("QuickLink_LFG", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuickLink", true)

------------------------------------------------------------------------
--- LFG context Menu hooking
------------------------------------------------------------------------
function getLFGQuickLinkMenu()
    local menu = {}
	for i, page in pairs(QuickLinkPages) do
        if table:get(page, "enabled", true) then
            table.insert(menu, {
                text = page.name,
                func = function(_, name) QuickLink:ShowUrlFrame(page.name, page.url, name); end,
                notCheckable = true,
                arg1 = nil,
                disabled = nil,
            });
        end
	end
	
	return menu;
end

function updateMenu(menu, qlMenu)
    local updated = false
    
	for key, menuEntry in pairs(menu) do
		if menuEntry.text == L["ADDONNAME"] then
			menuEntry.menuList = qlMenu;
			updated = true;
		end
	end
	if not updated then
        local entry = {
            text = L["ADDONNAME"],
            hasArrow = true,
            notCheckable = true,
            menuList = qlMenu,
        }
		table.insert(menu, #menu, entry);
	end
	
	return menu
end

function QuickLink_LFG:LFGListUtil_GetSearchEntryMenu(resultID)
	local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID);
	local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID);
    
	local menu = self.hooks["LFGListUtil_GetSearchEntryMenu"](resultID);
    
	local searchMenu = getLFGQuickLinkMenu();
	for k, e in pairs(searchMenu) do
		e.arg1 = searchResultInfo.leaderName;
		e.disabled = not searchResultInfo.leaderName;
	end

    return updateMenu(menu, searchMenu);
end
 
function QuickLink_LFG:LFGListUtil_GetApplicantMemberMenu(applicantID, memberIdx)
    local name, class, localizedClass, level, itemLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx);
    local getApplicantInfo = C_LFGList.GetApplicantInfo(applicantID);
	
	local menu = self.hooks["LFGListUtil_GetApplicantMemberMenu"](applicantID, memberIdx);
	
	local applicantMenu = getLFGQuickLinkMenu();
	for k, e in pairs(applicantMenu) do
		e.arg1 = name;
		e.disabled = not name or (getApplicantInfo.applicationStatus ~= "applied" and getApplicantInfo.applicationStatus ~= "invited");
	end
	
    return updateMenu(menu, applicantMenu);
end

function QuickLink_LFG:OnEnable()
	QuickLink_LFG:RawHook("LFGListUtil_GetSearchEntryMenu", true);
	QuickLink_LFG:RawHook("LFGListUtil_GetApplicantMemberMenu", true);
end
