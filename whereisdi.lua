_addon.name = 'WhereisDI'
_addon.author = 'Kosumi (Asura)'
_addon.commands = {'whereisdi','di'}
_addon.version = 1.0
_addon.language = 'English'

require('luau')
require('strings')
config = require('config')
api = require('api')

local status = { "0000002e,00000120,00000000,0000000a", "0000002d,00000120,00000000,00000000", "0000002f,00000120,00000000,00000000", "00000031,00000120,00000000,00000000",
    "0000002f,00000120,00000000,00000003","00000031,00000120,00000000,00000003", "0000002e,00000121,00000001,0000000a", "0000002d,00000121,00000001,00000001",
    "0000002f,00000121,00000001,00000001", "00000031,00000121,00000001,00000001", "0000002f,00000121,00000001,00000003", "00000031,00000121,00000001,00000003",
    "0000002e,00000123,00000002,0000000a", "0000002d,00000123,00000002,00000002", "0000002f,00000123,00000002,00000002", "00000031,00000123,00000002,00000002",
    "0000002f,00000123,00000002,00000003", "00000031,00000123,00000002,00000003" }

--Config
defaults = { }
defaults.send = true
settings = config.load(defaults)
config.save(settings)

windower.register_event('load','login',function ()
    if windower.ffxi.get_info().logged_in then
        log('Thank you for using Whereisdi! Use command //di to get the latest location information.')
        coroutine.schedule(login, 5)
    end
end)

windower.register_event('chat message', function(message, player, mode, is_gm)
    -- Unity Message
    if mode == 33 then 
        if settings.send then
            local index = string.sub(message, 18, 52)
            if locate(status, index) then
                api.post(windower.ffxi.get_player().name, windower.ffxi.get_info().server, index)
            end
        end
    end
end)

windower.register_event('addon command', function(command, ...)
    command = command and command:lower() or 'status'
    local args = L{...}
    if command == 'send' then
        settings.send = not settings.send
        if settings.send then
            log("Sending unity data: enabled. Thank you for contributing!")
        else
            log("Disabled sending unity data.")
        end
        config.save(settings)
    elseif command == 'mireu' then
        log(api.get_mireu(windower.ffxi.get_info().server))
    else
        log(api.get(windower.ffxi.get_info().server))
    end
end)

function locate(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

function login()
    local server_id = windower.ffxi.get_info().server
    api.login(windower.ffxi.get_player().name, server_id, res.servers[server_id].name)
end

function isempty(s)
    return s == nil or s == ''
end
