require("src.Network")
require("src.Utility")
require("src.FetchAndEncodeAE2Contents")

while true do
    local AE2StoredItems = getStoredItems()
    sendToServer(AE2StoredItems)
    os.sleep(1)
end
