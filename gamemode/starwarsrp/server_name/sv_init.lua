// hostname                                     "[Shaft.CC] |Русский сервер|CS:GO knife|" // Server Name for Server List

local dataTable = {
    'Русский сервер',
    'Уникальный геймплей',
    'Постоянные обновления',
    'Быстрая загрузка',
    'Новый опыт в StarWarsRP',
    'Отзывчивая администрация',
}
local symbol = ""
symbol = symbol .. "["
if SWRP.Config.SymbolVersion ~= "" then
    symbol = symbol .. SWRP.Config.SymbolVersion.." "
end
symbol = symbol .. SWRP.Config.BuildVersion
symbol = symbol .. "]"
timer.Create( "ServerName.Changer", 10, 0, function() 
    local some = dataTable[ math.random( #dataTable ) ]
    RunConsoleCommand("hostname", "[Shaft.CC]"..symbol.." "..some)
end )