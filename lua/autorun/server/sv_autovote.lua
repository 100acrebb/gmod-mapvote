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
			if #self.MapList > 0 then
				if MapVote then
					local prefix = nil
					if MapVote.Config.Murder.MapList then
						-- only match maps that we have specified
						prefix = {}
						for k, map in pairs(self.MapList) do
							table.insert(prefix, map .. "%.bsp$")
						end
					end
					MapVote.Start(nil, nil, nil, prefix)
					return
				end
				self:RotateMap()
			end
		end
	end

	if GAMEMODE_NAME == "prop_hunt" then
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