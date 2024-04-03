local component = require("component")
local ME = component.me_interface
local CpuTable = ME.getCpus()

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

for i=1,#CpuTable do
    for j=1,#CpuTable[j] do
        print()
    pprint(CpuTable[i])
end

