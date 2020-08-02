-- Datastore/Stats

-- Variables

local DataStore = require(game:GetService("ReplicatedStorage").Modules.Datastore)
local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

-- Functions

Players.PlayerAdded:Connect(function(plr)
	local AutoSaveTime = DataStore:getSaveTime()
	
	local Time = tick()
	local CurrenTime = Time - tick()
	
	DataStore:SetUp(plr)
	
	
--	warn(tostring(plr.UserId)..'PlayerData')
	
	
	
	
end)

Players.PlayerRemoving:Connect(function(plr)
	DataStore:saveData(plr, plr.PlayerStats, 'PlayerData')
end)

game:BindToClose(function()
	
	for i,v in next, game.Players:GetPlayers() do
		
		DataStore:saveData(v, v.PlayerStats, 'PlayerData')
		
	end
	
end)
