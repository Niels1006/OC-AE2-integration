local component = require("component")
local ME = component.me_interface
local AE2CPUTable = ME.getCpus()

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

for i=1,#AE2CPUTable do
    pprint(AE2CPUTable[i])
end

