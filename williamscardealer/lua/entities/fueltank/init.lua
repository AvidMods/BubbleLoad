AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Initialize()

	self:SetModel( "models/props_junk/metalgascan.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:PhysWake();

	self.Litres = CarDealer.Settings.FuelTankSize;

end


function ENT:Touch( _e )
	if( _e && IsValid( _e ) && _e:IsVehicle() && _e:GetClass() == "prop_vehicle_jeep" && _e.fuel ) then
	
		local _maxFuel = CarDealer.Settings.DefaultFuel;
		
		if( CarDealer.MaxFuelFromModel[ _e:GetModel() ] ) then
			_maxFuel = CarDealer.MaxFuelFromModel[ _e:GetModel() ];
		end
		
		if( _e.fuel && _e.fuel < _maxFuel && _e.fuel + self.Litres < _maxFuel ) then
			_e.fuel = _e.fuel + self.Litres;
		else
			_e.fuel = _maxFuel;
		end

		
		self.Litres = 0;
		self:Remove();
	end
end

function ENT:Use( _p, caller )
	if( inventory:HolsterEnt( _p, self:GetClass() ) ) then
		self:Remove();
	end
end
