local component = require("component")
local ME = component.me_interface

require("src.Network")
require("src.Utility")

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end
function getStoredItems()
    items = ME.allItems()
    local item_table = {}
    for item in items do
        if item.isCraftable == false and (type(item) == "table") then
            local label = item.label:gsub("%§.", "")
            local size = item.size
            item_table[label] = size
        end
    end
    return item_table
end