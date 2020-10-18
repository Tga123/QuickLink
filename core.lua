QuickLink = LibStub("AceAddon-3.0"):NewAddon("QuickLink", "AceConsole-3.0", "AceHook-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("QuickLink", true)
local AceConfig = LibStub("AceConfig-3.0")

-- default config settings
local QuickLink_defaultPages = {
    { name = "Armory", url = "https://worldofwarcraft.com/{LANGUAGEHYPHENFULL}/character/{REGION}/{REALM}/{NAME}", enabled = true },
    { name = "Warcraft Logs", url = "https://www.warcraftlogs.com/character/{REGION}/{REALM}/{NAME}", enabled = true },
	{ name = "Raider.io", url = "https://raider.io/characters/{REGION}/{REALM}/{NAME}", enabled = true },
    { name = "WOW Progress", url = "https://www.wowprogress.com/character/{REGION}/{REALM}/{NAME}", enabled = true },
	{ name = "Raidbots", url = "https://www.raidbots.com/simbot/quick?region={REGION}&realm={REALM}&name={NAME}", enabled = true },
    { name = "Ask Mr. Robot", url = "https://www.askmrrobot.com/wow/gear/{REGION}/{REALM}/{NAME}", enabled = true },
}

StaticPopupDialogs["QUICKLINK_DELETE"] = {
    text = "" ,
    button1 = L['YES'],
    button2 = L['NO'],
    OnAccept = function() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

function table:get(t, key, default)
    if t[key] ~= nil then
        return t[key]
    else
        return default
    end
end

local function urlEscape(url)
    return string.gsub(url, "([^A-Za-z0-9_:/?&=.-])",
        function(ch)
            return string.format("%%%02x", string.byte(ch))
        end)
end

local function getUrl(urltemplate, name, server)
  local region = nil
  local url = nil

  if not name or name == "" then return end
  if not server or server == "" then server = GetRealmName() end
  local realm = server
  local region = GetCurrentRegionName()

  if not region or region == "" then
    QuickLink:Print(L['REGIONERROR'])
    return;
  end
  if not realm or realm == "" then
    QuickLink:Print(L['REALMERROR'])
    return;
  end

  realm = realm:gsub("'","");
  realm = realm:gsub(" ","-");

  url,_ = string.gsub(urltemplate, "{REGION}", region)
  url,_ = string.gsub(url, "{LANGUAGEHYPHENFULL}", L["LANGUAGEHYPHENFULL"])
  url,_ = string.gsub(url, "{LANGUAGEFULL}", L["LANGUAGEFULL"])
  url,_ = string.gsub(url, "{LANGUAGESHORT}", L["LANGUAGESHORT"])
  url,_ = string.gsub(url, "{REALM}", realm)
  url,_ = string.gsub(url, "{NAME}", name)
  if url then
    url = urlEscape(string.lower(url));
  end

  return url;
end

function QuickLink:ShowUrlFrame(pagename, pagetemplate, name, server)

  if not server then
    n = gsub(name, "%-[^|]+", "")
    s = gsub(name, "[^|]+%-", "")
    if n == s then
      s = GetRealmName()
    end
    name, server = n, s
  end

  local url = getUrl(pagetemplate, name, server);
  if url then
    linkEditBox:SetText(url)
    linkEditBox:HighlightText()
    headlineString:SetText(pagename.." link for "..name)
    QuickLinkFrame:Show()
  end
end

function GenConfig()
  local options = {
    name = L["ADDONNAME"], handler = QuickLink, type = "group",
    args = {
      desc = {
        order = 1,
        type = "description",
        name = L['OPTION_DESCRIPTION'],
      },
    }
  }

  for i, page in pairs(QuickLinkPages) do
    local page_options = {
      type = "group",
      name = page.name,
      order = 10+i,
      args = {
        page_name = {
          order = 1,
          type = "input",
          name = L['OPTION_LABEL_NAME'],
          desc = L['OPTION_HELP_NAME'],
          set = function(info, val)
            QuickLinkPages[i].name = val
            ConfigChange()
          end,
          get = function() return table:get(QuickLinkPages[i], "name", "") end,
        },
        page_url = {
          order = 2,
          type = "input",
          name = L['OPTION_LABEL_URL'],
          desc = L['OPTION_HELP_URL'],
          set = function(info, val)
            QuickLinkPages[i].url = val
            ConfigChange()
          end,
          get = function() return table:get(QuickLinkPages[i], "url", "") end,
          width = "full",
          multiline = 2
        },
        isEnabled = {
          order = 10,
          type = "toggle",
          name = L['OPTION_LABEL_ENABLED'],
          desc = L['OPTION_HELP_ENABLED'],
          set = function(info, val)
            QuickLinkPages[i].enabled = val
            ConfigChange()
          end,
          get = function() return table:get(QuickLinkPages[i], "enabled", false) end
        },
        delete = {
          type = "execute",
          name = L['OPTION_BUTTON_DELETE'],
          desc = L['OPTION_HELP_DELETE'],
          func = function()
            StaticPopupDialogs["QUICKLINK_DELETE"].text = L['POPUP_DELETECONFIRMATION_QUESTION'](QuickLinkPages[i].name)
            StaticPopupDialogs["QUICKLINK_DELETE"].OnAccept = function()
              QuickLinkPages[i] = nil
              ConfigChange()
            end
            StaticPopup_Show ("QUICKLINK_DELETE")
          end,
          order = 20,
        },
        }
    }
    options.args["page_"..i] = page_options
  end

  -- add entry for a new site
  local new_entry = {name = L['OPTION_DEFAULT_NAME'], url = L['OPTION_DEFAULT_URL'], enabled = false}
  options.args["page_new"] = {
    type = "group",
    name = L['OPTION_LABEL_NEW'],
    args = {
      page_name = {
        order = 1,
        type = "input",
        name = L['OPTION_LABEL_NAME'],
        desc = L['OPTION_HELP_NAME'],
        set = function(info, val)
          new_entry.name = val
        end,
        get = function() return new_entry.name end,
      },
      page_url = {
        order = 2,
        type = "input",
        name = L['OPTION_LABEL_URL'],
        desc = L['OPTION_HELP_URL'],
        set = function(info, val)
          new_entry.url = val
        end,
        get = function() return new_entry.url end,
        width = "full",
        multiline = 2
      },
      isEnabled = {
        order = 10,
        type = "toggle",
        name = L['OPTION_LABEL_ENABLED'],
        desc = L['OPTION_HELP_ENABLED'],
        set = function(info, val)
          new_entry.enabled = val
        end,
        get = function() return new_entry.enabled end
      },
      add = {
        type = "execute",
        name = L['OPTION_BUTTON_ADD'],
        desc = L['OPTION_HELP_ADD'],
        func = function()
          table.insert(QuickLinkPages, new_entry)
        end,
        order = 20
      }
    }
  }


  return options
end

------------------------------------------------------------------------
function ConfigChange()
  QuickLink_UNIT_POPUP = QuickLink:GetModule("QuickLink_UNIT_POPUP")
  if QuickLink_UNIT_POPUP and QuickLink_UNIT_POPUP:IsEnabled() then
    QuickLink_UNIT_POPUP:updateContextMenu()
  end
end

function QuickLink:OnInitialize()
  if not QuickLinkPages then
    QuickLinkPages = QuickLink_defaultPages
  end

  AceConfig:RegisterOptionsTable("QuickLink", GenConfig)
  QuickLink.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuickLink", "QuickLink")

  QuickLink:EnableModule("QuickLink_UNIT_POPUP")
  QuickLink:EnableModule("QuickLink_LFG")
  QuickLink:EnableModule("QuickLink_BNET")
  ConfigChange()

  SLASH_QUICKLINK1 = "/quicklink"
  SlashCmdList["QUICKLINK"] = function(msg)
    InterfaceOptionsFrame_OpenToCategory("QuickLink")
  end
end

function hideDialog()
  linkEditBox:SetText("")
  linkEditBox:ClearFocus()
  QuickLinkFrame:Hide()
end


------------------------------------------------------------------------
-- Frame Event handling
------------------------------------------------------------------------
function okButton1_OnClick()
  hideDialog()
end

function linkEditBox_OnEscapePressed()
  hideDialog()
end

---
