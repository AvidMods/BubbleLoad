

-- Variables that are used on both client and server

AddCSLuaFile()

SWEP.Author			= "William";
SWEP.Instructions	= "Look at a vehicle";

SWEP.Spawnable			= true;
SWEP.AdminOnly			= true;
SWEP.UseHands			= true;
SWEP.Category = "Dartpace";

SWEP.ViewModel			= "models/weapons/c_pistol.mdl";
SWEP.WorldModel			= "models/weapons/w_Pistol.mdl";

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= -1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo			= "none";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none";

SWEP.AutoSwitchTo		= false;
SWEP.AutoSwitchFrom		= false;

SWEP.PrintName			= "Speed checker";
SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.DrawAmmo			= false

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	self:SetHoldType( "pistol" );

end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end


function SWEP:Think()

	if( !SERVER ) then
		return;
	end
	
	local trace = self.Owner:GetEyeTrace();

	if( trace.Hit and trace.Entity and trace.Entity:IsValid() and trace.Entity:IsVehicle() ) then
		local speed = math.floor( trace.Entity:GetVelocity():Length()/17.3 );
		if( speed >= 60 && trace.Entity:GetDriver() && IsValid( trace.Entity:GetDriver() ) && !trace.Entity:GetDriver():isWanted() && speed ) then
			trace.Entity:GetDriver():wanted( self.Owner, "Speeding" );
		end
	end
	
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:DrawHUD()

	local trace = self.Owner:GetEyeTrace();

	if( trace.Hit and trace.Entity and trace.Entity:IsValid() and trace.Entity:IsVehicle() ) then
		
		if( !CLIENT ) then return end;
		local _text = ( math.floor( trace.Entity:GetVelocity():Length()/17.3 ) ) .. " MPH";
		local _width, _height = surface.GetTextSize( _text );
		draw.RoundedBox( 5, ( ScrW() / 2 ) - 200, ( ScrH() / 2 ) + 200, 400, 40, Color( 130, 130, 130, 50 ) );
		local _widthb = math.floor( trace.Entity:GetVelocity():Length()/17.3 );
		
		if( _widthb > 194 ) then
			_widthb = 194;
		end
		
		draw.RoundedBox( 0, ( ScrW() / 2 ) - 196, ( ScrH() / 2 ) + 203, _widthb * 2, 34, CarDealer.Derma.Colors.FuelBox );
		surface.SetFont( CarDealer.Derma.Fonts.InfoFont );
		draw.SimpleText( _text, CarDealer.Derma.Fonts.InfoFont, ( ScrW() / 2 ) - ( _width / 3 ), ( ScrH() / 2 ) + 200 + 11, CarDealer.Derma.Colors.FuelText );
			
	end

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	-- Right click does nothing..
	
end

function SWEP:PrimaryAttack()

	-- Right click does nothing..
	
end