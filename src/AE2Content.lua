local component = require("component")
local me = component.me_interface
require("src.Utility")

local AE2Content = {}

function AE2Content.getItems(filter, threshold)
    local output = {}
    local result = {}
    result[1] = me.getItemsInNetwork(filter)

    for i, v in ipairs(result[1]) do

        if v.size > threshold then
            output[v.label] = v.size
        end
    end

    return {
        items = output
    }
end

function AE2Content.getCraftableItems()
    local output = {}
    local result = {}
    result[1] = me.getItemsInNetwork({
        ["isCraftable"] = true
    })

    for i, v in ipairs(result[1]) do
        output[v.label] = 1
    end

    return {
        items = output
    }
end

return AE2Content
