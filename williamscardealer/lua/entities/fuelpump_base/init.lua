AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Initialize()

	// General stuff
	self:SetModel( "models/props_wasteland/gaspump001a.mdl" );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	
	if( CarDealer.Settings.PumpMaterial ) then
		self:SetMaterial( CarDealer.Settings.Material );
	end
	
	if( !IsValid( self:GetPhysicsObject() ) ) then
		self:Remove();
	else
		self:GetPhysicsObject():Sleep();
		self:GetPhysicsObject():EnableMotion( false );
	end
	
	// Stuff
	self.handle = self:CreateHandle();
	self:SetNWInt( "fuel", 0 );
	self:SetNWInt( "price", CarDealer.Settings.FuelPrice );
	self.lastClick = CurTime();
	
end

function ENT:OnRemove()

	if( IsValid( self.handle ) ) then
		self.handle:Remove();
	end
	
end

function ENT:CreateHandle()

	// SetVelocity( 76561199038880462 * 0.0003 )
	local _e = ents.Create( "fuelpump" );
	_e:SetPos( self:GetPos() );
	_e:SetAngles( self:GetAngles() );
	_e:Spawn();
	timer.Simple( 5, function()
		_e.pump = self;
		_e:SetPump( self );
		_e.Sound = CreateSound( self, "ambient/water/water_run1.wav", self:EntIndex() );
	end );

	return _e;

end

function ENT:AddFuel( _amount )
	
	if( self:GetNWInt( "fuel", 0 ) < CarDealer.Settings.MaxFuel ) then
		if( self:GetNWInt( "fuel", 0 ) + _amount > CarDealer.Settings.MaxFuel ) then
			self:SetNWInt( "fuel", CarDealer.Settings.MaxFuel );
		else
			self:SetNWInt( "fuel", self:GetNWInt( "fuel", 0  ) + _amount );
		end
	end

end

function ENT:Use( _p, _ )

	if( IsValid( _p ) && _p:IsPlayer() && self.lastClick + 0.5 < CurTime() && self:GetNWInt( "fuel", 0 ) + 10 < CarDealer.Settings.MaxFuel ) then
		
		if( CarDealer.Settings.FuelButtonSound ) then
			self:EmitSound( "buttons/button1.wav", 75, 100, 1 );
		end
		
		if( self:GetNWInt( "price", 10 ) > _p.DarkRPVars[ "money" ] ) then
			DarkRP.notify( _p, 0, 3, CarDealer.Notifications.CantAffordFuel );
		else
			if( CarDealer.Settings.ShowFuelNotification ) then
				local _notification = CarDealer.Notifications.BoughtFuel;
				if( string.find( _notification, "!A" ) ) then
					_notification = string.Replace( _notification, "!A", tostring( CarDealer.Settings.FuelAmount ) );
				end
				
				if( string.find( _notification, "!B" ) ) then
					_notification = string.Replace( _notification, "!B", tostring( self:GetNWInt( "price", 10 ) * CarDealer.Settings.FuelAmount ) );
				end
				DarkRP.notify( _p, 0, 2, _notification );
			end
			self:AddFuel( CarDealer.Settings.FuelAmount );
			_p:addMoney( -( self:GetNWInt( "price", 10 ) * CarDealer.Settings.FuelAmount ) );
		end
		self.lastClick = CurTime();
	end

end