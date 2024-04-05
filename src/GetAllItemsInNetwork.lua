local component = require("component")
local ME = component.me_interface

require("src.Network")
require("src.Utility")

items = component.me_interface.allItems()
item = items()
while(item ~= nil) do
  print(item.label .. " x " .. item.size)
  item = items()
end