local component = require("component")
local ME = component.me_interface
local JSON = require("json")

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

function getStoredItems()
    local itemsString = "{\n"
    items = ME.allItems()
    for item in items do
        if item.isCraftable == false and (type(item) == "table") then
            local label = item.label:gsub("%§.", "")
            local size = item.size
            itemsString = itemsString .. "    \"".. label .. "\": " .. size .. ",\n"
        end
    end
    itemsString = itemsString .. "}"
    return itemsString
end

local AE2StoredItems = getStoredItems()
send_to_server(AE2StoredItems)

print(AE2StoredItems)
