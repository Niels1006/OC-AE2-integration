local LSC = {}

function LSC.getLSCProxy()
    for k, v in component.list("gt_machine") do
        if component.invoke(k, "getName") == "multimachine.supercapacitor" then
            return component.proxy(k)
        end
    end
end

function LSC.getTPSProxy()
    for k, v in component.list("tps") do
        return component.proxy(k)
    end
end

function LSC.getLSCContent(lscProxy, tpsProxy)
    local sensorInformation = lscProxy.getSensorInformation()
    local string_wirelessenergy = sensorInformation[19]
    local wirelessenergy = string_wirelessenergy.gsub(string_wirelessenergy, "([^0-9]+)", "")

    local string_lsc = sensorInformation[2]
    local lsc = string_lsc.gsub(string_lsc, "([^0-9]+)", "")

    if tonumber(wirelessenergy) < 10000000 then
        print("wireless useless")
        return
    end

    tpsProxy.getOverallTickTime()

    return {
        ["wireless"] = wirelessenergy,
        ["lsc"] = lsc,
        ["tick_time"] = tpsProxy.getOverallTickTime()
    }

end

return LSC
