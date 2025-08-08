local component = require("component")
local event = require("event")
local internet = require("internet")

local function httpGet(ip, port, timeout)
    local url = "http://" .. ip .. ":" .. port
    local startTime = os.clock()
    
    while true do
        local response, err = internet.request(url)
        if response then
            print("Response received from " .. url)
            response:close()
        else
            print("Error: " .. err)
        end
        
        if timeout > 0 and (os.clock() - startTime) >= timeout then
            break
        end
        
        os.sleep(1) -- Wait for 1 second before the next request
    end
end

local function parseArgs(args)
    local ip, port, timeout = nil, nil, 0
    
    for i = 1, #args do
        if args[i] == "--IPandPort" then
            ip, port = args[i + 1]:match("([^:]+):?(%d*)")
            port = port ~= "" and tonumber(port) or 80
        elseif args[i] == "--TimeoutInterval" then
            timeout = tonumber(args[i + 1]) or 0
        end
    end
    
    return ip, port, timeout
end

local args = {...}
local ip, port, timeout = parseArgs(args)

if ip then
    httpGet(ip, port, timeout)
else
    print("Please provide an IP and port using --IPandPort")
end
