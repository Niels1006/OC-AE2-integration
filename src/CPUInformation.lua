local component = require("component")
local ME = component.me_interface
local CpuTable = ME.getCpus()
local CpuDataToServer = {}

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
    
    CpuDataToServer[i] = {
      name = CpuTable[i].name,
      storage = CpuTable[i].storage,
      busy = CpuTable[i].busy,
      activeItems = {},
      storedItems = {},
      pendingItems = {}
    }
    if CpuTable[i].busy == true then
        local cpu = CpuTable[i].cpu
        for _, v in ipairs({
            {items = cpu.activeItems(), name = "activeItems"},
            {items = cpu.storedItems(), name = "storedItems"},
            {item = cpu.pendingItems(), name = "pendingItems"}
        }) do
            if v.items ~= nil then
                for __, v2 in ipairs(v.items) do
                    CpuDataToServer[i][v.name][__] = {[v2.label] = v2.size}
                end
            end
        end
    end
    
end

print(dump(CpuDataToServer))
send_to_server(CpuDataToServer)