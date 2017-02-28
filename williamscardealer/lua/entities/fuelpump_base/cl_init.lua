include( "shared.lua" );

function ENT:Initialize()
end

function ENT:Draw()
	
	self:DrawModel();
	
	if( LocalPlayer():GetPos():Distance( self:GetPos() ) > 1000 ) then
		return false;
	end
	
	local _fuel = self:GetNWInt( "fuel", 0 );
	local _price = self:GetNWInt( "price", 0 );
	local _pos = self:GetPos();
	local _ang = self:GetAngles();
	_ang:RotateAroundAxis( _ang:Up(), 90 );
	_ang:RotateAroundAxis( _ang:Forward(), 90 );
	_ang:RotateAroundAxis( _ang:Right(), 0 );

	// Button trace
	local _t = {};
	_t.start = LocalPlayer():GetShootPos();
	_t.endpos = LocalPlayer():GetAimVector() * 90 + _t.start;
	_t.filter = LocalPlayer();
	local _tr = util.TraceLine( _t );
	local _tp = self:WorldToLocal( _tr.HitPos );
	
	// Stuff
	local _boxw = 304;
	surface.SetFont( CarDealer.Derma.Fonts.BigFont );
	local _pricew, _priceh = surface.GetTextSize( CarDealer.Settings.FuelPriceText .. _price );
	
	_pos = _pos + ( _ang:Up() * 9.2 ) + ( _ang:Right() * -55 ) + ( _ang:Forward() * -15 ); 
	cam.Start3D2D( _pos, _ang, 0.1 );
		draw.RoundedBox( 0, 0, 0, _boxw, 200, CarDealer.Derma.Colors.FuelBG );
		draw.RoundedBox( 0, 54, 46, 194, 20, Color( 0, 0, 0, 255 ) );
		draw.DrawText( CarDealer.Settings.FuelPriceText,
		"RobotoInfoLarge",
		74,
		44,
		CarDealer.Derma.Colors.FuelBigText );
		
		draw.DrawText( "$" .. _price,
		"RobotoInfoLarge",
		205,
		44,
		CarDealer.Derma.Colors.FuelBigText );	

		draw.RoundedBox( 0, 54, 66, 194, 20, Color( 0, 0, 0, 255 ) );
		draw.DrawText( CarDealer.Settings.FuelAmountText,
		"RobotoInfoLarge",
		74,
		64,
		CarDealer.Derma.Colors.FuelBigText );
		
		draw.DrawText( _fuel .. "L",
		"RobotoInfoLarge",
		205,
		64,
		CarDealer.Derma.Colors.FuelBigText );
		
		if( _tr.Entity && _tr.Entity:EntIndex() == self:EntIndex() 
			&& _tp.y > -8.4 && _tp.y < 8.6
			&& _tp.z > 41.8 && _tp.z < 46 ) then
			draw.RoundedBox( 6, 54, 100, 191, 40, Color( 0, 255, 0, 145 ) );
		else
			draw.RoundedBox( 6, 54, 100, 191, 40, Color( 0, 255, 0, 25 ) );
		end
		draw.DrawText( CarDealer.Settings.PurchaseText,
			"RobotoInfoLarge",
			83,
			108,
			CarDealer.Derma.Colors.FuelBigText );
	cam.End3D2D();
	
end