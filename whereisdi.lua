_addon.name = 'WhereisDI'
_addon.author = 'Kosumi (Asura)'
_addon.commands = {'whereisdi','di'}
_addon.version = 1.1
_addon.language = 'English'

require('luau')
require('strings')
defaults = require('defaults')
texts = require('texts')
config = require('config')
api = require('api')

local status = { "0000002e,00000120,00000000,0000000a", "0000002d,00000120,00000000,00000000", "0000002f,00000120,00000000,00000000", "00000031,00000120,00000000,00000000",
    "0000002f,00000120,00000000,00000003","00000031,00000120,00000000,00000003", "0000002e,00000121,00000001,0000000a", "0000002d,00000121,00000001,00000001",
    "0000002f,00000121,00000001,00000001", "00000031,00000121,00000001,00000001", "0000002f,00000121,00000001,00000003", "00000031,00000121,00000001,00000003",
    "0000002e,00000123,00000002,0000000a", "0000002d,00000123,00000002,00000002", "0000002f,00000123,00000002,00000002", "00000031,00000123,00000002,00000002",
    "0000002f,00000123,00000002,00000003", "00000031,00000123,00000002,00000003" }


local settings = config.load(defaults)
local di_box = texts.new('${di_location} ${di_timer}', defaults.domain_invasion, settings)

local location
local location_timestamp = os.time()

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
                api.post_di_location(windower.ffxi.get_player().name, windower.ffxi.get_info().server, index)
            end
        end
    end
end)

windower.register_event('time change', function(new, old)
    if settings.show == true then
        if new % 5 == 0 then
            local api_loc, timestamp = api.get_di_location(windower.ffxi.get_info().server)

            if api_loc ~= location then
                --location_timestamp = os.time() 
                location_timestamp = timestamp
                location = api_loc
                di_box.di_location = location
            end
        end 
    end
end)

windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
    if settings.show == true then
        local timer = os.time() - location_timestamp
        di_box.di_timer = box_time(timer)
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
    elseif command == 'show' then
        settings.show = true
        local loc, timestamp = api.get_di_location(windower.ffxi.get_info().server)
        location = loc
        di_box.di_location = location
        location_timestamp = timestamp
        di_box:show()
    elseif command == 'hide' then
        settings.show = false
        di_box:hide()
    elseif command == 'help' then
        log("Whereisdi by Kosumi (Asura)")
        log("Usage: //whereisdi or //di (send, mireu, show, hide)")
        log("  (none): //di by itself will show lastest known DI information")
        log("  send: toggle sending unity data to help other users")
        log("  mireu: get last known mireu pop time")
        log("  show: show the location data in a box")
        log("  hide: hide the location data box")
    else
        location = api.get_di_location(windower.ffxi.get_info().server)
        log(location)
    end
end)

function locate(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

function box_time(time)
    local minutes = math.floor(math.mod(time,3600)/60)
    local seconds = math.floor(math.mod(time,60))
    local result

    if minutes == 0 then
        result = string.format("(%ds)", seconds)
    else
        result = string.format("(%dm%ds)", minutes, seconds)
    end

    return result
end  

function login()
    local server_id = windower.ffxi.get_info().server
    if type(res.servers[server_id]) ~= 'table' or not res.servers[server_id].name then
        print('WhereisDI: private servers are not supported. Unloading.')
        windower.send_command('lua unload whereisdi')
        return
    end
    api.login(windower.ffxi.get_player().name, server_id, res.servers[server_id].name)
end

function set_timestamp()
    location_timestamp = os.time()
end

function isempty(s)
    return s == nil or s == ''
end
