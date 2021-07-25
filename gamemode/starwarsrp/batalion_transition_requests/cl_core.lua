SWRP.TransitionRequests = SWRP.TransitionRequests or {}
netstreamSWRP.Hook("SWRP.TA:Update", function(tab)
	SWRP.TransitionRequests = tab
    PrintTable(SWRP.TransitionRequests)
	print("Updating local tab context menu")
end)

SWRP.AddTranslationRequest = function(charid, sid, nbat)
    //sql.Query( "INSERT INTO transition_requests( charid, sid, new_bat ) VALUES( " ..  charid .. ", '" .. sid .. "', '" .. nbat .. "')" )
    netstreamSWRP.Start("AddTranslationRequestSv", charid, sid, nbat)
    //SWRP.TransitionRequests = sql.Query("SELECT * FROM transition_requests")
end
    /*

	netstreamSWRP.Hook("DeleteFromClient", function(charid)
		charid = tonumber(charid)
		sql.Query("DELETE FROM transition_requests WHERE charid = " .. charid .. "")
		SWRP.TransitionRequests = sql.Query("SELECT * FROM transition_requests")
	end)
	netstreamSWRP.Hook("AddToClient", function(charid, new_bat, sid)
		charid = tonumber(charid)
		//print("GOVNO KAKOETO " .. charid)
		//PrintTable(sql.Query("SELECT * FROM transition_requests WHERE charid = " .. charid .. ""))
		if table.Count(sql.Query("SELECT * FROM transition_requests WHERE charid = " .. charid .. "") or {})>0 then 
			print("UPDATE " .. charid)
			sql.Query("UPDATE transition_requests SET new_bat = '".. new_bat .. "' WHERE charid = " .. charid .. "")
		else
			print("INSERT " .. charid)
			sql.Query( "INSERT INTO transition_requests( charid, sid, new_bat ) VALUES( " ..  charid .. ", '" .. sid .. "', '" .. new_bat .. "')" )
		end
		SWRP.TransitionRequests = sql.Query("SELECT * FROM transition_requests") or {}
	end)*/
