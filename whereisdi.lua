_addon.name = 'WhereisDI'
_addon.author = 'Kosumi (Asura)'
_addon.commands = {'whereisdi','di'}
_addon.version = 0.7
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

show_unity_log = false

--Config
defaults = { }
defaults.send = true
settings = config.load(defaults)
config.save(settings)

windower.register_event('login',function ()
    api.login(windower.ffxi.get_player().name)
	--windower.send_command('lua r whereisdi')
end)

windower.register_event('chat message', function(message, player, mode, is_gm)
    -- Unity Message
    if mode == 33 then 
        if settings.send then
            if show_unity_log == true then
                local player_str = string.sub(player, 1, 15)
                log('[LOG] Unity Chat: Name: '..player_str..' Message: '..message..'')  
            end
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

function isempty(s)
    return s == nil or s == ''
end
