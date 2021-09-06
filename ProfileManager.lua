-- NOTE: The way I use these functions is not necessarily ideal, 
-- they are just examples of how you could use them
local ProfileManager = require(game.ServerScriptService.ProfileManager)

game.Players.PlayerAdded:Connect(function(plr)
	local plrProfile = ProfileManager:LoadPlayerProfile(plr)
	local plrData = ProfileManager:GetDataFromProfile(plrProfile)
	
	print("This should print a table with atleast the default player values:")
	print(plrData)
	
	local bansProfile = ProfileManager:LoadCustomProfile("Custom", "Custom_"..game.PlaceId)
	local bansData = ProfileManager:GetDataFromProfile(bansProfile)
	
	print("This should print a table with the banned people:")
	print(bansData)
	
	bansData.bans[plr.Name] = true
	ProfileManager:ReleaseProfile(bansProfile)
	
	plr.Chatted:Connect(function(msg)
		local requestedPlrId = game.Players:GetUserIdFromNameAsync(msg)
		local requestedPlr = game.Players:GetPlayerByUserId(requestedPlrId)
		
		if requestedPlr and requestedPlr:IsDescendantOf(game.Players) then
			local key = "Player_"..requestedPlr.UserId
			local requestedPlrProfile = ProfileManager:GetProfile(key)
			local requestedPlrData = ProfileManager:GetDataFromProfile(requestedPlrProfile)
			
			print(requestedPlrData)
			
			ProfileManager:ReleaseProfile(requestedPlrProfile)
		end
	end)
end)

game:BindToClose(function()
	ProfileManager:ReleaseAllProfiles()
end)
