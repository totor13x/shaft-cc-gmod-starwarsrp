if SERVER then
	timer.Simple(0, function()
		PrintTable(sql.Query("SELECT * FROM batalion_list"))
		for i,v in pairs(sql.Query("SELECT * FROM batalion_list")) do
			zones.RegisterClass("Batalion "..v.named,Color(255,0,0))
		end
	end)
end