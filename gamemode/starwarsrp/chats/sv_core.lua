
netstreamSWRP.Hook("SWRP::Typing", function(ply, bool)
    netstreamSWRP.Start(_, "SWRP::TypingSync", ply, bool)
end)