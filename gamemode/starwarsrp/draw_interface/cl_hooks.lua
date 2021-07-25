netstreamSWRP.Hook("GM:Notification", function(data)
	GAMEMODE:AddNote( data.text, data.type, data.length )
end)