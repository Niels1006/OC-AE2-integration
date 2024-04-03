local component = require("component")
local ME = component.me_interface
local Cpus = ME.getCpus()

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

for i=1,#Cpus do
    pprint(type(Cpus[i]))
end

