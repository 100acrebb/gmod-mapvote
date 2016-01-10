hook.Add( "Initialize", "AutoMapVote", function()
	if GAMEMODE_NAME == "terrortown" then
		function CheckForMapSwitch()
			-- Check for mapswitch
			local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
			SetGlobalInt("ttt_rounds_left", rounds_left)
 
			local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
			
			if rounds_left <= 0 or time_left <= 0 then
				timer.Stop("end2prep")
				MapVote.Start(nil, nil, nil, nil)
			end
		end
	end
	
	if GAMEMODE_NAME == "murder" then
		function GAMEMODE.ChangeMap( self )
			print ("Mapvote is starting a map vote!")
			MapVote.Start()
		end
	end

	if GAMEMODE_NAME == "prop_huntXXX" then
		RunConsoleCommand( "fretta_voting", "0" )
		function GAMEMODE.StartMapVote( self )
			-- If there's only one map, let the 'random map' thing choose it
			if ( GetNumberOfGamemodeMaps( self.WinningGamemode ) == 1 ) then
				return self:FinishMapVote( true )
			end	
			
			MapVote.Start(nil, nil, nil, nil)
		end
	end
	
	if GAMEMODE_NAME == "deathrun" then
		function RTV.Start()
			MapVote.Start(nil, nil, nil, nil)
		end
	end
	
	if GAMEMODE_NAME == "zombiesurvival" then
		hook.Add("LoadNextMap", "MAPVOTEZS_LOADMAP", function()
			MapVote.Start(nil, nil, nil, nil)
			return true 
		end )
	end

end )

hook.Add( "MapVoteChange", "ExtendMap", function(votedMap)
	if GAMEMODE_NAME == "terrortown" then
		local currentMap = game.GetMap()
		if (votedMap == currentMap) then
			local etime = MapVote.Config.ExtendTime or 10
			local erounds = MapVote.Config.ExtendRounds or 5
		
			SetGlobalInt("ttt_rounds_left", GetGlobalInt("ttt_rounds_left", 6) + erounds)
			SetGlobalInt("ttt_time_limit_minutes", GetGlobalInt("ttt_time_limit_minutes") + etime)
			
			RunConsoleCommand("ttt_roundrestart")
			
			return false
		end
	end
	
	return true
end )