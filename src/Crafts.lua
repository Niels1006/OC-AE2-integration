local component = require("component")
local json = require("lib.json")
local network = require("src.Network")

local ME = component.me_interface

local Crafts = {}

local function requestItem(name, count)
    local craftables = ME.getCraftables({
        ["label"] = name
    })

    if #craftables >= 1 then
        local item = craftables[1].getItemStack()
        if item.label == name then
            local craft = craftables[1].request(count)

            while craft.isComputing() == true do
                os.sleep(0.5)
            end

            if craft.hasFailed() == true then
                return 0
            else
                return 1
            end

        end
    end

    return -1
end

function Crafts.handleCraftingQueue(headers_)

    local code, message, headers, data = network.makeRequest("itemscraft?last=true", {}, headers_, "GET")

    if code == 202 then

        local res = json.decode(data)

        if res.uuid ~= nil then
            local craftUUID = res.uuid
            if res.succes_code == nil then
                local successCode = requestItem(res.item_name, res.item_size)

                local finished = false
                while finished == false do

                    local code2, message2, headers2, data2 = network.makeRequest("itemscraft", {
                        uuid = craftUUID,
                        response_code = successCode
                    }, headers_, "PUT")
                    if code2 == 202 then
                        local res2 = json.decode(data2)
                        print(
                            "[" .. os.date("%H:%M:%S") .. "] Code: " .. successCode .. " | Queued " .. res.item_size ..
                                "x " .. res.item_name)
                        return
                    end
                    os.sleep(1)
                end
            end
        end
    else
    end
end

return Crafts
