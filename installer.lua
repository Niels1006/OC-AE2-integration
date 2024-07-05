local shell = require("shell")
local filesystem = require("filesystem")
local scripts = {"src/CPUs.lua", "src/AE2Content.lua", "src/LSC.lua", "src/Crafts.lua", "src/Network.lua",
                 "src/Utility.lua", "lib/json.lua", "constants.lua", "Run.lua"}

local paths = {"src", "lib"}

local function exists(filename)
    return filesystem.exists(shell.getWorkingDirectory() .. "/" .. filename)
end

local repo = "https://raw.githubusercontent.com/Niels1006/OC-AE2-integration/";
local branch = "main"

for i = 1, #paths do
    if not filesystem.exists(shell.getWorkingDirectory() .. "/" .. paths[i]) then
        filesystem.makeDirectory(shell.getWorkingDirectory() .. "/" .. paths[i]);
    end
end

for i = 1, #scripts do
    shell.execute(string.format("wget %s%s/%s %s", repo, branch, scripts[i], scripts[i]));
end

if not exists("auth.lua") then
    shell.execute(string.format("wget %s%s/auth.lua", repo, branch));
end

-- shell.execute("reboot");
