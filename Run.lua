local cpus = require("src.CPUs")
local ae2content = require("src.AE2Content")
local lsc = require("src.LSC")
local crafts = require("src.Crafts")
local network = require("src.Network")

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

    if counter % 1 == 0 then
        -- pcall(crafts.handleCraftingQueue, headers)
        crafts.handleCraftingQueue(headers)
    end

    counter = counter + 1
    os.sleep(1)

end
