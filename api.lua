require("socket")
require("strings")
local https = require("ssl.https")
local json = require("parse")
local sha = require("sha2")

local search_endpoint = "https://api.whereisdi.com/items/di_location?fields=*.*&sort=-date_created&limit=1&filter[server][_eq]="
local location_endpoint = "https://api.whereisdi.com/items/di_location"
debug = false

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end


local M = { }

function M.login(player, server_id, server_name)
    local user = player.."@"..server_name
    local token = sha.sha256(user)
    local body = '{"first_name":"'..player..'", "server":"'..server_id..'", "email":"'..user..'", "token":"'..token..'", "role":"8a1a1e19-4eb4-4779-8c1a-4024f40ed4b4"}'
    local response_body = {}
    local res, code, response_headers = https.request{
        url = "https://api.whereisdi.com/users";
        method = "POST";
        headers = {
            ["user-agent"] = "whereisdi/0.0.1",
            ["content-type"] = "application/json",
            ["content-length"] = tostring(body:len()),
        };
        source = ltn12.source.string(body);
        sink = ltn12.sink.table(response_body);
    }

    if debug then
        log("Code: "..code)
        log("Response: "..dump(response_body))
    end
end

function M.get(server)
    local message = ". "
    local resp = { }
    local endpoint = search_endpoint..server

    local body, code, headers, status = https.request(endpoint)

    if code == 200 then
        local result = json.parse(body)
        result = result.data
        if next(result) ~= nil then
            -- Not Nil
            result = result[1]
            local age = request_age(result["date_created"])
            local max_age = result["location"]["max_age"]

            if age > max_age then
                message = "Location unknown (no recent data received)"
            else
                message = result["location"]["en_us"]
            end
        else -- Nil
            message = "No location results available."
        end
    else -- not 200
        message = "Unable to contact location server."
    end

    return message;
end

function M.post(player, server, location)
    local user = player.."@"..res.servers[server].name
    local token = sha.sha256(user)
    location = location:gsub("%W","")
    local body = '{"player":"'..player..'", "server":"'..server..'", "location":"'..location..'"}'
    local response_body = {}

    if debug then
        log("Body: "..body)
    end

    local res, code, response_headers = https.request{
        url = location_endpoint;
        method = "POST";
        headers = {
            ["user-agent"] = "whereisdi/0.0.1",
            ["content-type"] = "application/json",
            ["authorization"] = "Bearer "..token,
            ["content-length"] = tostring(body:len()),
        };
        source = ltn12.source.string(body);
        sink = ltn12.sink.table(response_body);
    }

    if debug then
        log("Code: "..code)
        log("Response: "..dump(response_body))
    end
end

function request_age(r_date)
    local request = r_date
    local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%.(%d+)"
    local xyear, xmonth, xday, xhour, xminute, xseconds, xmillies, xoffset = request:match(pattern)
    local convertedTimestamp = os.time({year = xyear, month = xmonth, day = xday, hour = xhour, min = xminute, sec = xseconds})
    local timezone = os.date('%z')
    local signum, hours, minutes = timezone:match '([+-])(%d%d)(%d%d)'

    if signum == '+' then
        convertedTimestamp = convertedTimestamp + (hours * 60 * 60) + (minutes * 60)
    else
        convertedTimestamp = convertedTimestamp - (hours * 60 * 60) - (minutes * 60)
    end

    local now = os.time()

    return os.difftime(now, convertedTimestamp)
end

return M
