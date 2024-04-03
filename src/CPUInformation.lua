local component = require("component")
local ME = component.me_interface
local CpuTable = ME.getCpus()

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

for i=1,#CpuTable do
    local CpuIndexed = CpuTable[i].name
    local CpuFinalCraft = CpuTable[i].cpu.pendingItems()
    --pprint(CpuTable[i].cpu.pendingItems())
    if CpuTable[i].busy == false then
        print(tostring(CpuIndexed) .. " Currently idle")
    else print(tostring(CpuIndexed) .. " Currently working on crafting " .. tostring(CpuFinalCraft))
end
end
