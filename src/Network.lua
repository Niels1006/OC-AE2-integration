local component = require("component")
local json = require("lib.json")
local auth = require("auth")
local constants = require("constants")
local shell = require("shell")

local internet = component.internet
local fs = component.filesystem

local Network = {}

local function getCsrfToken(headers)
    print(constants.API_URL)
    local result, req = pcall(internet.request, constants.API_URL .. "api/csrf", {}, headers, "GET")

    req.finishConnect()
    local code, message, headers = req.response()

    local csrfToken
    if result then
        local responseHeaders = {}
        for key, headerlist in pairs(headers) do
            for k, header in pairs(headerlist) do
                if header:find("csrftoken=") then
                    csrfToken = header:match("csrftoken=([^;]+)")
                else
                end

            end

        end
        return csrfToken
    else
        error("Request failed")
    end
end

local function makeRequest(endpoint, data, headers, method)
    data["server"] = "twist"
    if method == "POST" or method == "PUT" then
        data = json.encode(data)
    end

    local result, req = pcall(internet.request, constants.API_URL .. "api/" .. endpoint, data, headers, method)

    local data
    if method == "GET" or method == "PUT" or method == "POST" then
        req.finishConnect()
        data = req.read()
    end

    local code, message, headers = req.response()

    print("[" .. os.date("%H:%M:%S") .. "] " .. code .. " | " .. message .. " | " .. endpoint)
    if result then
        if code == 200 or code == 201 or code == 202 then
            return code, message, headers, data
        else
            return code, message, headers, data
        end
    else
        error("HTTP request failed: " .. tostring(headers))
    end
end

local function setupCookies()
    local headers = {
        ["Content-Type"] = "application/json",
        ["Cookie"] = ""
    }

    local result, code, message, headers_r = pcall(makeRequest, "login", {
        username = auth.username,
        password = auth.password
    }, headers, "POST")

    local x = headers_r["Set-Cookie"]
    for k, v in pairs(x) do
        local __csrfToken = v:match("csrftoken=([^;]+)")
        local __sessionId = v:match("sessionid=([^;]+)")

        if __csrfToken ~= nil then
            headers["Cookie"] = "csrftoken=" .. __csrfToken
            headers["X-CSRFToken"] = __csrfToken
        elseif __sessionId ~= nil then
            headers["Cookie"] = headers["Cookie"] .. ";" .. "sessionid=" .. __sessionId
        end
    end

    local result, code, message, headers_r = pcall(makeRequest, "is_authenticated", {}, headers, "GET")

    if code == 403 then
        print("FORBIDDEN")
    end

    return headers

end

Network.makeRequest = makeRequest
Network.setupCookies = setupCookies

return Network

-- function saveSessionIdToFile(sessionID)
--     local file, reason = fs.open(shell.getWorkingDirectory() .. "/session.env", "w")
--     local success, reason = fs.write(file, sessionID)
--     if not success then
--         error("Failed to write to file: " .. tostring(reason))
--     end
--     fs.close(file)
-- end

-- function readSessionId()
--     local file, reason = fs.open(shell.getWorkingDirectory() .. "/session.env", "r")
--     if not file then
--         error("Failed to open file: " .. tostring(reason))
--     end
--     local content = ""

--     local chunk = fs.read(file, math.huge) -- Read a large chunk at a time
--     if not chunk then

--     end
--     content = content .. chunk

--     fs.close(file)

--     return content
-- end
