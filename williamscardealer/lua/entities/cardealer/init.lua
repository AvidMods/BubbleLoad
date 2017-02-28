AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

 	self.dealerid = 0;
	self.platforms = {};
	self:SetModel( CarDealer.Settings.Model );
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetNPCState( NPC_STATE_SCRIPT );
	self:SetSolid(  SOLID_BBOX );
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD );
	self:SetUseType( SIMPLE_USE );
	self:DropToFloor();
	self.name = "Unnamed";
	self.nextClick = CurTime() + 1;
	self:SetMaxYawSpeed( 90 );

end

function ENT:GetDealerID()
	
	return self.dealerid;
	
end

function ENT:AcceptInput( _event, _a, _p )
	if( _event == "Use" && _p:IsPlayer() && self.nextClick < CurTime() )  then
		local _returned = false;
		for i, v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
			if( IsValid( v ) and v.CarOwner and v.CarOwner == _p:SteamID64() ) then
				CarDealer:ReturnCar( _p, self );
				_returned = true;
				
			end
		end
		
		if( !_returned ) then
			for i, v in pairs( ents.FindByClass( "prop_vehicle_jeep_old" ) ) do
				if( IsValid( v ) and v.CarOwner and v.CarOwner == _p:SteamID64() ) then
					CarDealer:ReturnCar( _p, self );
					_returned = true;
				end
			end
		end
		
		if( !_returned ) then
			for i, v in pairs( ents.FindByClass( "prop_vehicle_airboat" ) ) do
				if( IsValid( v ) and v.CarOwner and v.CarOwner == _p:SteamID64() ) then
					CarDealer:ReturnCar( _p, self );
					_returned = true;
				end
			end
		end
		
		net.Start( "CarDealer::Derma" );
		net.WriteFloat( self:EntIndex() );
		net.WriteFloat( self:GetDealerID() );
		net.Send( _p );
	end
end

