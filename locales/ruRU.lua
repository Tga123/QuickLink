local L = LibStub("AceLocale-3.0"):NewLocale("QuickLink", "ruRU")
if L then
    L["ADDONNAME"] = "QuickLink"
    L["REGIONERROR"] = "Регион не найден!"
    L["REALMERROR"] = "Сервер не найден!"
    L["LANGUAGEHYPHENFULL"] = "ru-RU"
	L["LANGUAGEFULL"] = "ruRU"
	L["LANGUAGESHORT"] = "ru"
	
    
    L['YES'] = "да"
    L['NO'] = "нет"
    
    L['OPTION_LABEL_NAME'] = "Имя"
    L['OPTION_LABEL_URL'] = "Ссылка"
    L['OPTION_LABEL_ENABLED'] = "Активно"
    L['OPTION_LABEL_NEW'] = "+Новая ссылка+"
    L['OPTION_HELP_NAME'] = "Название ссылки"
    L['OPTION_HELP_URL'] = "Шаблон для создания ссылки"
    L['OPTION_HELP_ENABLED'] = "Показать/спрятать ссылку в меню"
    L['OPTION_HELP_ADD'] = "Добавить новую ссылку"
    L['OPTION_HELP_DELETE'] = "удалить эту ссылку"
    L['OPTION_BUTTON_ADD'] = "Добавить"
    L['OPTION_BUTTON_DELETE'] = "Удалить"
    L['OPTION_DEFAULT_NAME'] = "Название сайта"
    L['OPTION_DEFAULT_URL'] = ""
    L['OPTION_DESCRIPTION'] = [[Вы можете использовать эти шаблоны автозамены:

{LANGUAGEHYPHENFULL},{LANGUAGEFULL},{LANGUAGESHORT} - Код текущего языка в разных форматах. 
  Таких как: ru-RU, ruRU, ru. Основан на текущем языка аддона.
{NAME} - Имя персонажа.
{REALM} - Игровой мир персонажа.
{REGION} - Регион вашего игрового клиента (EU / US / ...).
]]
    
    L['POPUP_DELETECONFIRMATION_QUESTION'] = function(name)
        return "Вы действительно хотите удалить ссылку на\n\"" .. name .. "\"?"
    end
end
