require("src.Network")
require("src.Utility")
require("src.FetchAndEncodeAE2Contents")


local AE2StoredItems = getStoredItems()
sendToServer(AE2StoredItems)
print(dump(AE2StoredItems))