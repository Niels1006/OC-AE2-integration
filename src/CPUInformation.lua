local component = require("component")
local ME = component.me_interface
local CpuTable = ME.getCpus()

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

-- PAST HERE DOESNT WORK

local WorkingCpus = getBusyCpus(CpuTable)

for i=1,#CpuTable do
    local CpuIndexed = CpuTable[i].name
    local CpuFinalCraft = CpuTable[i].cpu.pendingItems()
    --pprint(CpuTable[i].cpu.pendingItems())
    if CpuTable[i].busy == false then
        print(tostring(CpuIndexed) .. " Currently idle")
    print(tostring(WorkingCpus[i]))
end
end
