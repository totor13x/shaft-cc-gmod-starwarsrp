SC = {}

SC.Title = GetHostName() -- The title at the top of the chatbox
SC.FontText = "Lato" -- What font you would like to use for the chatbox text
SC.FontHeader = "Lato" -- What font you would like to use for the chatbox header

SC.FadeTime = 5 -- How long should the chat messages stay before going away?

SC.W = 400 -- The width of the chatbox (probably best to avoid changing)
SC.H = 200 -- The height of the chatbox
if CLIENT then
SC.X = ScrW()/2 - SC.W/2 -- How far away should the chatbox be from the left hand side of the screen
SC.Y = ScrH() - 40 - SC.H -- How far away should the chatbox be from the top of the screen
end
SC.Time = false -- Should we show timestamps? (set by the client)
SC.JoinLeave = false -- Should we show timestamps? (set by the client)

SC.Sound = true -- Should we play a chatsound? (set by the client)
SC.CustomSound = true -- If the above is true, should the sound be custom?
SC.SoundPath = "garrysmod/ui_return.wav" -- If the sound is to be custom, the filepath for the sound needs to go here

SC.Rank = true -- Should we show rank tags?
-- If the above is enabled these tags will show based on the user's usergroup
SC.Ranks = {}
SC.Ranks[1] = {"founder", 	"[Kurucu]", function(ply) return Color(184, 55, 255) end}
SC.Ranks[1] = {"superadmin", 	"[Kurucu]", function(ply) return Color(184, 55, 255) end}
SC.Ranks[2] = {"sunucuyardimcisi", 	"[Sunucu Yardimcisi]", function(ply) return Color(255, 55, 40) end}
SC.Ranks[3] = {"basadmin", 	"[Bas Admin]", function(ply) return Color(100, 255, 100) end}
SC.Ranks[4] = {"admin", 		"[Admin]", 		function(ply) return Color(229, 105, 37) end}
SC.Ranks[5] = {"moderator", 		"[Moderator]", 		function(ply) return Color(96, 143, 191) end}
SC.Ranks[6] = {"helper", 		"[Rehber]", 		function(ply) return Color(232, 144, 44) end}
SC.Ranks[7] = {"donator", 		"[Donator]", 		function(ply) return Color(232, 144, 44) end}