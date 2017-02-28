AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()

	self:SetModel( "models/hunter/plates/plate3x7.mdl" );
	self:SetMaterial( "phoenix_storms/cube" );
	self:DrawShadow( false );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	local phys = self:GetPhysicsObject();
	phys:Sleep();		
	phys:EnableMotion( false );
	self.free = true;
	//self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	self.touching = {};
end

function ENT:StartTouch( _e )

	self.free = false;
	table.insert( self.touching, _e:EntIndex() );
	//self:SetColor( Color( 255, 255, 255, 255 ) );

end

function ENT:EndTouch( _e )

	table.RemoveByValue( self.touching, _e:EntIndex() );
	if( #self.touching == 0 ) then
		self.free = true;
		//self:SetColor( Color( 0, 0, 0, 0 ) );
	end
end