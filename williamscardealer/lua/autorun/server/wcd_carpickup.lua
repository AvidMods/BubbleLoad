local function PhysgunPickupCar( ply, ent )
	if ( ent:IsVehicle() ) then
		if( table.HasValue( CarDealer.Settings.PhysToolPermission, ply:GetUserGroup() ) )  then
			if( !CarDealer.Settings.VCMod ) then
				return true;
			end
		else
			return false;
		end
	end

end

local function ToolCar( ply, tr, tool )	
	if( tr && tr.Hit && tr.HitNonWorld && tr.Entity && tr.Entity:IsVehicle()  ) then
		if( table.HasValue( CarDealer.Settings.PhysToolPermission, ply:GetUserGroup() ) )  then
			if( !CarDealer.Settings.VCMod ) then
				return true;
			end
		else
			return false;
		end
	end
	
end


hook.Add("PhysgunPickup", "PhysgunPickupCar", PhysgunPickupCar );
hook.Add("CanTool", "ToolCar", ToolCar );