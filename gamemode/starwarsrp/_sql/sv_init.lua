//hook.Add("Initialize", "SQL.Load", function()
	//sql.Query("DROP TABLE characters")
	sql.Query( [[ 
	CREATE TABLE IF NOT EXISTS `characters` (
		`id` INTEGER PRIMARY KEY AUTOINCREMENT,
		`steamid` varchar(32) NOT NULL,
		`name_id` VARCHAR(255) NOT NULL DEFAULT '0000',
		`name_clas` VARCHAR(255) NOT NULL DEFAULT 'Koko',
		`special_name` varchar(64) DEFAULT NULL,
		`clsf` VARCHAR(32) NOT NULL DEFAULT 'C',
		`rank` INT(10) NOT NULL DEFAULT 1,
		`role` INT(10) NOT NULL DEFAULT 1,
		`role_selected` INT(10) NOT NULL DEFAULT 0,
		`batalion` varchar(10) NOT NULL DEFAULT 0,
		`sex` DEFAULT 'male',
		`model` VARCHAR(255) NOT NULL,
		`skin` SMALLINT NOT NULL DEFAULT 0,
		`bodygroup` VARCHAR(32) NOT NULL DEFAULT 0,
		`money_held` INT(10) NOT NULL DEFAULT '0',
		`money_bank` INT(10) NOT NULL DEFAULT '0',
		`vehicles` LONGTEXT NULL,
		`skills` LONGTEXT NULL,
		`special_name` varchar(64) DEFAULT NULL,
		`special_id_role` varchar(64) DEFAULT NULL,
		`created` VARCHAR(32) NOT NULL DEFAULT 0
	)]] )
//end) 
//end) 
	//sql.Query("DROP TABLE char_rank_up")
	sql.Query( [[ 
	CREATE TABLE IF NOT EXISTS `batalion_list` (
		`id` INTEGER PRIMARY KEY AUTOINCREMENT,
		`owner_steamid` varchar(32) NOT NULL,
		`named`  VARCHAR(255) NOT NULL DEFAULT '0000',
		`named_beauty`  VARCHAR(255) NOT NULL DEFAULT '0000',
		`allow_class` LONGTEXT NULL,
		`created` VARCHAR(32) NOT NULL DEFAULT 0
	)]] )

	sql.Query( [[ 
	CREATE TABLE IF NOT EXISTS `batalion_request` (
		`id` INTEGER PRIMARY KEY AUTOINCREMENT,
		`steamid` varchar(32) NOT NULL,
		`batalion_new` VARCHAR(255) NOT NULL DEFAULT '0000',
		`created` VARCHAR(32) NOT NULL DEFAULT 0
	)]] )

	sql.Query( [[  
	CREATE TABLE IF NOT EXISTS `char_rank_up` (
		`id` INTEGER PRIMARY KEY AUTOINCREMENT,
		`character_id` varchar(32) NOT NULL,
		`rank`  VARCHAR(6) NOT NULL DEFAULT '0',
		`time` varchar(32) NOT NULL DEFAULT '0'
	)]] )

    sql.Query("CREATE TABLE IF NOT EXISTS transition_ability( charid INTEGER )")
	sql.Query("CREATE TABLE IF NOT EXISTS transition_requests( charid INTEGER, sid STRING, new_bat STRING )")

/*

	sql.Query( [[
		ALTER TABLE `characters` ADD `special_name` varchar(64) DEFAULT NULL;
	)]] )
	sql.Query( [[
		ALTER TABLE `characters` ADD `special_id_role` varchar(64) DEFAULT NULL;
	)]] )
*/

	//sql.Query("INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`,`named_beauty`) values ('STEAM_0:0:331925970', '[]', '432st', '432-й')")
	//PrintTable(sql.Query("SELECT * FROM `batalion_list`"))

	concommand.Add("transition_data", function(ply)
		if IsValid(ply) then return end
		
		local old = "modern_rishi_moon"
		local new = "modern_rishi_moon_v1"
		
		if file.Exists("swrp/"..old.."/spawn.txt","DATA") then
			local data = util.JSONToTable(file.Read("swrp/"..old.."/spawn.txt","DATA"))
			file.Write("swrp/"..new.."/spawn.txt", util.TableToJSON(data))
		end

		if file.Exists("batalions/doors.txt","DATA") then
			local data = util.JSONToTable(file.Read("batalions/doors.txt","DATA"))

			data[new] = data[old]
			file.Write("batalions/doors.txt", util.TableToJSON(data))
		end

		PermaProps.SQL.Query("UPDATE permaprops SET map = "..sql.SQLStr(new).." WHERE map = "..sql.SQLStr(old))

		textscreens = file.Read("sammyservers_textscreens.txt", "DATA")
		if textscreens and textscreens != "" then
			textscreens = util.JSONToTable(textscreens)
			for i,v in pairs(textscreens) do
				if v.MapName == old then
					v.MapName = new 
				end
			end
		end
	end)