local component = require("component")
local ME = component.me_interface

local items       = ME.allItems()
local craftables  = ME.getCraftables()
local cpus        = ME.getCpus()

function requestItem(name, count)
    craftables = ME.getCraftables()
    for k,v in pairs(craftables) do
        if type(v) == 'table' then
            item = v.getItemStack()
            if item.label == name then
                local craft = v.request(count)
                return craft
            end
        end
    end
    return nil
end

-- Crafting item and count
local name = "Iron Ingot"
local count = 32

local craft = requestItem(name, count)