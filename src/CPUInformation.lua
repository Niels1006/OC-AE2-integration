local component = require("component")
local ME = component.me_interface
local CpuTable = ME.getCpus()

require("src.Network")
require("src.Utility")

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

function getBusyCpus() --: table[cpu]
    cpus = ME.getCpus()
    local busy = {}
    for k, v in pairs(cpus) do
        if v.busy == true then
            busy[#busy+1] = v
        end
    end 
    return busy
end

function matchCpu(name) --: cpu
    local busyCpus = getBusyCpus()
    for k, v in pairs(busyCpus) do
        local label = v.cpu.finalOutput().label
        if label == name then
            return k
        end
    end
    return nil
end

for i=1,#CpuTable do
    local CpuIndexedName = CpuTable[i].name
    local CpuIndexedIsWorking = CpuTable[i].busy
    local CpuIndexedCraftingStorage = CpuTable[i].storage
    local CpuIndexedCraftingCoprocessor = CpuTable[i].coprocessors
    if CpuTable[i].busy == false then
        print(tostring(CpuIndexedName) .. " Currently idle")
    else 
        print(tostring(CpuIndexedName) .. " Currently working")
        print("Crafing Storage: " .. tostring(CpuIndexedCraftingStorage))
        print("Coprocessors: " .. tostring(CpuIndexedCraftingCoprocessor))
end
end

pprint(CpuTable[1])