local component = require("component")
local ME = component.me_interface
local JSON = require("json")

require("src.Network")
require("src.Utility")

function getStoredItems()
    local item_table = {}
=    for item in items do
        if item.isCraftable == false and (type(item) == "table") then
            local label = item.label:gsub("%§.", "")
            local size = item.size
            item_table[label] = size
        end
    end
    return item_table
end

local AE2StoredItems = getStoredItems()
send_to_server(AE2StoredItems)
print(dump(AE2StoredItems))