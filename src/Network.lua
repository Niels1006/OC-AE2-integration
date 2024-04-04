component = require("component")
json = require("lib.json")
utility = require("src.Utility")

function send_to_server(table_)
    local req = internet.request("https://niels.space/api/json",
                                 json.encode(table_),
                                 {["Content-Type"] = "application/json"}, "POST")

    req.finishConnect()
    local res = req.read()

    if res ~= nil then print("Got response: " .. dump(res)) end
end
