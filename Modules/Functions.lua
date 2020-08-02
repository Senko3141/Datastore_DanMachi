-- DataStoreFunctions.lua

local module = {};

local dataStore = game:GetService("DataStoreService")
local save = dataStore:GetDataStore('PlayerDataStudioTesting10')

function module:loadData(plr, saveName)
	local data;
	
	data = save:GetAsync(tostring(plr.UserId)..saveName) -- PlayerData is a table.
	
	if data then
		
		return true, data
	end
	
	if not data then 
		return false, data
	end
end

function module:saveData(plr, toSave, saveName)
	local Data = {};
	
	for _,v in next, toSave:GetChildren() do
		print(v.Name)
		Data[v.Name] = {
			['Stat'] = v.Value,
			['Progress'] = v.Progress.Value,
		};
		
	end
	
	save:SetAsync(tostring(plr.UserId)..saveName, Data)
	
	
	if not Data then
		
		return false
	end
	
	if Data then
		
		return true
	end
	
end



return module