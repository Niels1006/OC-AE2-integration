component = require("component")
local fs = component.filesystem
local shell = require("shell")

function dump(o, depth)
    if depth == nil then
        depth = 0
    end

    if depth > 10 then
        return "..."
    end

    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v, depth + 1) .. ',\n'
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function parser(string)
    if type(string) == "string" then
        local numberString = string.gsub(string, "([^0-9]+)", "")
        if tonumber(numberString) then
            return math.floor(tonumber(numberString) + 0)
        end
        return 0
    else
        return 0
    end
end

-- function readCredentials()
--     local filepath = shell.getWorkingDirectory() .. "/auth.env"
--     print(filepath)
--     if not fs.exists(filepath) then
--         error("File does not exist: " .. filepath)
--       end

--     local file, reason = fs.open(filepath, "r")
--     if not file then
--         error("Failed to open file: " .. tostring(reason))
--     end

--     local username, password

--     while true do
--         local line = fs.read(file, math.huge)
--         if not line then
--             break
--         end

--         for key, value in line:gmatch("(%w+)=([^%s]+)") do
--             if key == "username" then
--                 username = value
--             elseif key == "password" then
--                 password = value
--             end
--         end
--     end

--     fs.close(file)

--     if not username or not password then
--         error("Failed to find username or password in the file")
--     end

--     return username, password
-- end
