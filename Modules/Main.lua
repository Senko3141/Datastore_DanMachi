-- Datastore2.0.lua

local functions = require(script:WaitForChild("Functions"))
local config = require(script:WaitForChild("Config"))

local runService = game:GetService("RunService")

local http = game:GetService("HttpService")
local webHook = ''

local module = {};
local defaultData = { -- all number values for now.
	['Strength'] = 1,
	['Endurance'] = 1,
	['Dexterity'] = 1,
	['Agility'] = 1,
	['Magic'] = 1,	
};

--[[
	Saving is a table.
	
	module.config = {
		Saving = false,
		
		StudioSave = false,
		
		AutoSave = false,
		Auto_Time = 60,	
};

	SaveName: PlayerData
]]


function module:SetUp(plr)
	local success, Data = functions:loadData(plr, 'PlayerData')
	
	if not success and not Data then
		--// Setting up data for player who first joined.
		
		warn(plr.Name.. ' is a new player. Setting up NEW player data!')
		
		local Folder = Instance.new("Folder", plr)
		Folder.Name = 'PlayerStats'
		
		for name,value in pairs(defaultData) do
			local NumValue = Instance.new("IntConstrainedValue", Folder)
			NumValue.Name = name
			
			NumValue.MinValue = 1
			NumValue.MaxValue = 999
			
			NumValue.Value = value
			
			local Prog = Instance.new("IntConstrainedValue", NumValue)
			Prog.Name = 'Progress'
			
			Prog.MinValue = 1
			Prog.Value = 1
			
			Prog.MaxValue = 100
			
			Prog.Changed:Connect(function()
				--// Checking when to add another level.
				
				if Prog.Value == Prog.MaxValue then
					Prog.Value = 1
					
					warn(plr.Name.. " has gained a level for start: ".. Prog.Parent.Name)
					
					Prog.Parent.Value = Prog.Parent.Value + 1
					
				end
			end)
			
		end
		
		local now = os.time()
		local Hours = os.date("*t",now)["hour"]
        local Mins = os.date("*t",now)["min"]
		
		local payload = http:JSONEncode({
			content = "Data successfully created for new player: ".. plr.Name.. ' | Time: '.. Hours..":".. Mins,
			username = 'DataStore Logger: '..plr.Name
		});
		
		http:PostAsync(webHook, payload)
		
		warn("Successfully set up starting data for: ".. plr.Name)
	end
	
	if success and Data then
		--// Setting up data for previous player.
		
		warn(plr.Name.. ' is a returning player.')
		
		local Folder = Instance.new("Folder", plr)
		Folder.Name = 'PlayerStats'
		
		for name,value in next, Data do
			warn(name.. ' Value: '.. value['Stat'].. ' | Progress: '.. value['Progress'])
				
			local NumValue = Instance.new("IntConstrainedValue", Folder)
			NumValue.Name = name
			
			NumValue.MaxValue = 999
			NumValue.MinValue = 1
			
			NumValue.Value = value['Stat']
			
			local Prog = Instance.new("IntConstrainedValue", NumValue)
			Prog.Name = 'Progress'
			
			Prog.MinValue = 1
			Prog.Value = value['Progress']
			Prog.MaxValue = 100
			
			
			Prog.Changed:Connect(function()
				--// Checking when to add another level.
				
				if Prog.Value == Prog.MaxValue then
					Prog.Value = 1
					
					warn(plr.Name.. " has gained a level for start: ".. Prog.Parent.Name)
					
					Prog.Parent.Value = Prog.Parent.Value + 1
					
				end
			end)
			
			local now = os.time()
			local Hours = os.date("*t",now)["hour"]
	        local Mins = os.date("*t",now)["min"]
			
			local payload = http:JSONEncode({
				content = "Data successfully loaded for returning player: ".. plr.Name.. " INFO: Stat Name - "..name.. ' | Stat Value - '..value['Stat'].. ' | Progress - '.. value['Progress'].. ' | TIME: '.. Hours..":".. Mins,
				username = "DataStore Logger: "..plr.Name
			});
		
			http:PostAsync(webHook, payload)
			
		end
		
		
	end
	
end

function module:getSaveTime()
	if not config.AutoSave then
		warn("Could not get auto save time! | ERROR: Auto save is disabled in the config.")
		return
	end
	
	return config.Auto_Time
end


function module:saveData(plr, toSave, saveName)
	if not config.Saving then
		warn("Could not save data! | ERROR: Make sure to turn on Saving in the configurations.")
		return
	end
	
	if runService:IsStudio() then
		if not config.StudioSave then
			warn("Could not save data! | ERROR: Make sure to turn on studio save due to the fact that you are in ROBLOX STUDIO.")
		end
	end
	
	local success = functions:saveData(plr, toSave, saveName)
	
	if success then
		warn("Successfully saved ".. plr.Name.. "'s Data!")
		
		local now = os.time()
		local Hours = os.date("*t",now)["hour"]
        local Mins = os.date("*t",now)["min"]
		
		local payload = http:JSONEncode({
			content = "Data successfully saved for: ".. plr.Name.. " | TIME: ".. Hours..":".. Mins,
			username = 'DataStore Logger: '..plr.Name
		});
		http:PostAsync(webHook, payload)
		
	elseif not success then
		warn("Could not save ".. plr.Name.. "'s Data!")
		
		local now = os.time()
		local Hours = os.date("*t",now)["hour"]
        local Mins = os.date("*t",now)["min"]
		
		local payload = http:JSONEncode({
			content = "Data COULD NOT SAVE for: ".. plr.Name.. " | TIME: ".. Hours..":".. Mins,
			username = 'DataStore Logger: '..plr.Name
		});
		http:PostAsync(webHook, payload)
	end
	
end

function module:Get(action)
	if action == 'Stats' then
		
		return defaultData
	end
end






return module