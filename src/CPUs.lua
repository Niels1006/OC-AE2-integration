local component = require("component")
local ME = component.me_interface

local CPUs = {}

function CPUs.getCpuData()
    local cpus = ME.getCpus()
    local cpuDict = {}
    for k, v in pairs(cpus) do
        local finaloutput = v.cpu.finalOutput()
        if v.busy == true and finaloutput ~= nil then
            table.insert(cpuDict, {
                ["cpuName"] = v.name,
                ["finalOutputLabel"] = finaloutput.label,
                ["finalOutputSize"] = finaloutput.size,
                ["storage"] = v.storage,
                ["coprocessors"] = v.coprocessors
            })
            goto continue
        end

        table.insert(cpuDict, {
            ["cpuName"] = v.name,
            ["finalOutputLabel"] = nil,
            ["finalOutputSize"] = nil,
            ["storage"] = v.storage,
            ["coprocessors"] = v.coprocessors
        })

        ::continue::
    end

    return {
        ["cpus"] = cpuDict
    }
end

function sendDetailedCPUCraftsToServer()
    local cpus = ME.getCpus()
    local craftInformationDict = {}
    for k, v in pairs(cpus) do
        local craftInformation = {}

        local finaloutput = v.cpu.finalOutput()
        if v.busy == true and finaloutput ~= nil then
            for k2, v2 in pairs(v.cpu.pendingItems()) do
                if craftInformation[v2.label] == nil then
                    craftInformation[v2.label] = {
                        ["l"] = v2.label, -- label
                        ["aS"] = 0,
                        ["pS"] = 0
                    }
                end

                if v2.size ~= nil then
                    craftInformation[v2.label]["pS"] = v2.size
                else
                    craftInformation[v2.label]["pS"] = 0
                end
            end

            for k2, v2 in pairs(v.cpu.activeItems()) do
                if craftInformation[v2.label] == nil then
                    craftInformation[v2.label] = {
                        ["l"] = v2.label, -- label
                        ["aS"] = 0,
                        ["pS"] = 0
                    }
                end

                if v2.size ~= nil then
                    craftInformation[v2.label]["aS"] = v2.size
                else
                    craftInformation[v2.label]["aS"] = 0
                end

            end

            -- print(dump(craftInformation))
            -- print(#craftInformation)

            table.insert(craftInformationDict, {
                ["craftInformation"] = craftInformation,
                ["cpuName"] = v.name,
                ["finalOutput"] = finaloutput.label
            })

            goto continue
        end
        table.insert(craftInformationDict, {
            ["craftInformation"] = craftInformation,
            ["cpuName"] = v.name,
            ["finalOutput"] = "nothing"
        })

        ::continue::
    end

    sendToServer("crafting_complex", {
        ["api_key"] = "",
        ["server"] = "twist",
        ["crafts"] = craftInformationDict
    }, 10)
end


return CPUs

