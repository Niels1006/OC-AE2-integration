local cpus = require("src.CPUs")
local ae2content = require("src.AE2Content")
local lsc = require("src.LSC")
local crafts = require("src.Crafts")
local network = require("src.Network")

local function main()
    local lscProxy = lsc.getLSCProxy()
    local tpsProxy = lsc.getTPSProxy()

    local headers = network.setupCookies()

    local counter = 0
    while true do
        -- sendDetailedCPUCraftsToServer()

        if counter % 3600 == 0 then
            local data = ae2content.getCraftableItems()
            local result, code, message, headers_r = pcall(network.makeRequest, "craftableitems", data, headers, "POST")
        end

        if counter % 10 == 0 then
            local data = ae2content.getItems({}, 100)
            local result, code, message, headers_r = pcall(network.makeRequest, "items", data, headers, "POST")

            local data = lsc.getLSCContent(lscProxy, tpsProxy)
            local result, code, message, headers_r = pcall(network.makeRequest, "energy", data, headers, "POST")
        end

        if counter % 5 == 0 then
            local data = cpus.getCpuData()
            local result, code, message, headers_r = pcall(network.makeRequest, "cpus", data, headers, "POST")
        end

        if counter % 5 == 0 then
            local data = cpus.getComplexCraftData()
            local result, code, message, headers_r = pcall(network.makeRequest, "complex-craft-data", data, headers,
                "POST")
        end

        if counter % 1 == 0 then
            local result = pcall(crafts.handleCraftingQueue, headers)
            if result ~= true then
                print("ERROR in fetching item queue")
            end
        end
        counter = counter + 1
        os.sleep(1)
    end
end

while true do
    local result = pcall(main)
    if result ~= true then
        print("FATAL ERROR, TRYING AGAIN IN 30s")
    end

    os.sleep(30)
end
