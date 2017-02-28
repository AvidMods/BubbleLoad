AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Initialize()


	// General stuff
	self:SetModel( "models/props_c17/TrapPropeller_Lever.mdl" );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:PhysWake();
	
	if( !IsValid( self:GetPhysicsObject() ) ) then
		self:Remove();
	else
		self:GetPhysicsObject():EnableMotion( true );
	end

	// Positions
	self.hitchPos = Vector( 0, -18, 45.388535 );
	self.ropePos = Vector( -0.048193, 6.150391, 0.257211 );
	self.pumpRopePos = Vector( 0, -18, 60 );
	self.initialAngles = Angle( 0,  275,  90 );
	
	// Rope length
	self.ropeLength = 190;
	
	
	// Stuff
	self.Sound = CreateSound( self, "ambient/water/water_run1.wav", self:EntIndex() );
	self.weldCar = nil;
	self.weldPos = nil;
	self.noCollide = nil;
	self.pump = nil;
	self.lastThink = CurTime();
	self.fueling = false;
	self.lastFuel = CurTime();
end

function ENT:Rope()

	constraint.Rope( self,
	self.pump,
	0,
	0,
	self.ropePos,
	self.pumpRopePos,
	self.ropeLength,
	0,
	0,
	1,
	"cable/cable2",
	false );
	
end

function ENT:Free()

	if( IsValid( self.weld ) ) then
		self.weld:Remove();
	end

end

function ENT:SetPump( _e )

	self.pump = _e;
	timer.Simple( 1, function()
		self:Hitch();
		self.rope = self:Rope();
	end );
	
end

function ENT:Hitch()

	if( !IsValid( self.pump ) ) then
		self:Remove();
	end
	
	//to prevent it from falling off
	self:SetVelocity( Vector( 0, 0, 0 ) );
	self:GetPhysicsObject():EnableMotion( false );
	timer.Simple( 1, function()
		self:GetPhysicsObject():EnableMotion( true );
	end );
	
	self.fueling = false;
	
	// Position

	self:SetPos( self.pump:LocalToWorld( self.hitchPos ) );
	
	// Rotate
	local _ang = self.initialAngles;
	self:SetAngles( _ang );
	self:GetPhysicsObject():Sleep();

end

function ENT:OnRemove()

	if( IsValid( self.pump ) ) then
		self.pump:Remove();
	end
	
	if( self.Sound:IsPlaying() ) then
		self.Sound:Stop();
	end
	
end

function ENT:Fuel( _e )

	self.fueling = true;
	if( IsValid( _e ) && _e.fuel < _e.maxFuel && _e.fuel + 1 < _e.maxFuel
	&& self:GetPos():Distance( self.weldPos ) < 50 &&
	self.pump:GetNWInt( "fuel", 0 ) > 0 ) then
		_e.fuel = _e.fuel + 1;
		self.pump:SetNWInt( "fuel", self.pump:GetNWInt( "fuel", 0 ) - 1 );
		timer.Simple( CarDealer.Settings.PumpTime, function()
			self:Fuel( _e );
		end );
		
		if( _e:GetDriver() && IsValid( _e:GetDriver() ) && _e:GetDriver():IsPlayer()
		&& ( math.Round( _e.oldFuel ) != math.Round( _e.fuel )  ) ) then
			net.Start( "CarDealer::DriverFuel" );
				net.WriteFloat( math.Round( _e.fuel ) );
			net.Send( _e:GetDriver() );
		end		
	else
		self.fueling = false;
		self.lastFuel = CurTime();
		if( IsValid( self.weldCar ) ) then	
			self.weldCar:Remove();
		end
		if( IsValid( self.noCollide ) ) then
			self.noCollide:Remove();
		end
		self.weldPos = nil;
		self:Hitch();
		self.Sound:Stop();
	net.Start( "CarDealer::StopSound" );
	net.WriteFloat( self:EntIndex() );
	net.Broadcast();		
	end

end

function ENT:Think()
	
	if( self.pump && IsValid( self.pump ) ) then
		if( ( self.lastThink || CurTime() ) + 10 < CurTime() && !self.fueling ) then
			self:Hitch();
			self.lastThink = CurTime();
		end
	end

end

function ENT:Touch( _e )

	if( !IsValid( _e ) || !self.pump ) then
		return;
	end
	
	if( _e:EntIndex() == self.pump:EntIndex() ) then
		return false;
	end

	if( !self.fueling && _e:IsVehicle() && _e.fuel && _e.maxFuel && _e.fuel < _e.maxFuel && self.pump:GetNWInt( "fuel", 0 ) > 0 ) then

		if( !self.Sound:IsPlaying() ) then
			self.Sound:Play();
			net.Start( "CarDealer::StartSound" );
			net.WriteFloat( self:EntIndex() );
			net.Broadcast();
		end
		
		if( _e.fuel < _e.maxFuel ) then
			self.weldCar = constraint.Weld( self, _e, 0, 0, false, false );
			self.weldPos = self:GetPos();
			self:GetPhysicsObject():Sleep();
			self:Fuel( _e );
		end
	end
	
end