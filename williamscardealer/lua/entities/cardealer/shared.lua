ENT.Type = "ai";
ENT.Base = "base_ai";
ENT.AutomaticFrameAdvance = true;
ENT.PrintName = "Car Dealer";
ENT.Author = "William";
ENT.Category = "William's items";
ENT.Spawnable = true;

function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim;
end
