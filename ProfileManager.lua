local ProfileService = require(script.ProfileService)

local ProfileStores = {
	Player = ProfileService.GetProfileStore(
		"Player",
		{
			money = 0;
		}
	),
	Custom = ProfileService.GetProfileStore(
		"Custom",
		{
			bans = {}
		}
	)
}

local cachedProfiles = {}

game.Players.PlayerRemoving:Connect(function(plr)
	local key = "Player_"..plr.UserId
	local profile = cachedProfiles[key]
	
	if profile then
		profile:Release()
	end
end)

local PickleStore = {}

function PickleStore:ReleaseProfile(profile)
	profile:Release()
end

function PickleStore:ReleaseAllProfiles(profile)
	for _, profile in pairs(cachedProfiles) do
		profile:Release()
	end
end

function PickleStore:GetProfile(key)
	local profile = cachedProfiles[key]
	
	if profile then
		return profile
	end
end

function PickleStore:GetDataFromProfile(profile)
	if profile then
		return profile.Data
	end
end

function PickleStore:SetupProfile(profile, key)
	if profile then
		profile:Reconcile()
		profile:ListenToRelease(function()
			cachedProfiles[key] = nil
		end)
		
		cachedProfiles[key] = profile
		return true
	end
end

function PickleStore:LoadPlayerProfile(plr)
	local key = "Player_"..plr.UserId
	
	local profile = ProfileStores["Player"]:LoadProfileAsync(
		key,
		"ForceLoad"
	)
	
	local setupSuccess = PickleStore:SetupProfile(profile, key)

	if setupSuccess then
		return profile
	else
		warn("Error finding/setting up profile.")
	end
end

function PickleStore:LoadCustomProfile(profileName, key)
	local profile = ProfileStores["Custom"]:LoadProfileAsync(
		key,
		"ForceLoad"
	)
	
	local setupSuccess = PickleStore:SetupProfile(profile, key)
	
	if setupSuccess then
		return profile
	else
		warn("Error finding/setting up profile.")
	end
end

return PickleStore
