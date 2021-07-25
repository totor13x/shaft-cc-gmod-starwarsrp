
local meta = FindMetaTable("Player")

local _GetAimVector = _GetAimVector or meta.GetAimVector

function meta:GetAimVector()         
	return self.GetEyeTraceNoCursor and self:GetEyeTraceNoCursor().Normal or _GetAimVector(self)
end

function meta:GetAimVectorOLD()
	return _GetAimVector(self)//meta:GetEyeTraceNoCursor().Normal
end
