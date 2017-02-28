--[[ #NoSimplerr# ]]
__activeCarFuel = CarDealer.Settings.DefaultFuel;

net.Receive( "CarDealer::DriverFuel", function( len )
	__activeCarFuel = net.ReadFloat();
end );

hook.Add( "HUDPaint", "DrawNPCName", function()

	for i, v in pairs( ents.FindByClass( "cardealer" ) ) do
		if( v:GetPos():Distance( LocalPlayer():GetPos() ) < 200 ) then
			local _pos = v:GetPos() + Vector( 0, 0, 80 );
			_pos = _pos:ToScreen();
			if( LocalPlayer():IsLineOfSightClear( v:GetPos() + Vector( 0, 0, 80 ) ) ) then
				local _name = v:GetNWString( "name", "Unnamed" );
				
				surface.SetFont( "NPC1" );
				local _w, _h = surface.GetTextSize( _name );
				draw.DrawText( _name, "NPC1", _pos.x - ( _w / 2 ) - 3, _pos.y, Color( 0, 0, 0, 255 ), ALIGN_CENTER );
				draw.DrawText( _name, "NPC2", _pos.x - ( _w / 2 ), _pos.y, Color( 255, 255, 255, 255 ), ALIGN_CENTER );
			end
		end
	end
	
	for i, v in pairs( ents.FindByClass( "auctionguy" ) ) do
		if( v:GetPos():Distance( LocalPlayer():GetPos() ) < 200 ) then
			local _pos = v:GetPos() + Vector( 0, 0, 80 );
			_pos = _pos:ToScreen();
			if( LocalPlayer():IsLineOfSightClear( v:GetPos() + Vector( 0, 0, 80 ) ) ) then
				local _name = wcdas.Settings.AuctionGuyTitle;
				
				surface.SetFont( "NPC1" );
				local _w, _h = surface.GetTextSize( _name );
				draw.DrawText( _name, "NPC1", _pos.x - ( _w / 2 ) - 3, _pos.y, Color( 0, 0, 0, 255 ), ALIGN_CENTER );
				draw.DrawText( _name, "NPC2", _pos.x - ( _w / 2 ), _pos.y, Color( 255, 255, 255, 255 ), ALIGN_CENTER );
			end
		end	
	end

end );

hook.Add( "HUDPaint", "CarDealerHUD", function()

	_p = LocalPlayer();
	local _pos1 = false;
	local _pos1t = { ( ScrW() / 2 ) - 200, ScrH() - 60 };
	
	if( IsValid( _p ) and _p:InVehicle() and _p:GetVehicle() != nil and _p:GetVehicle():GetClass() == "prop_vehicle_jeep" ) then
	
		_e = _p:GetVehicle();

		if( !_e || !IsValid( _e ) ) then
			return;
		end
		
		if( CarDealer.Settings.DisplayFuel and CarDealer.Settings.Fuel ) then
			
			_pos1 = true;
			local _fuel = __activeCarFuel;
			_maxfuel = CarDealer.Settings.DefaultFuel;
			if( CarDealer.MaxFuelFromModel[ _p:GetVehicle():GetModel() ] ) then
				_maxfuel = CarDealer.MaxFuelFromModel[ _p:GetVehicle():GetModel() ];
			end
			
			draw.RoundedBox( 5, _pos1t[ 1 ], _pos1t[ 2 ], 400, 40, Color( 130, 130, 130, 50 ) );
			local _width = ( _fuel / _maxfuel ) * 388;
			draw.RoundedBox( 0, _pos1t[ 1 ] + 6, _pos1t[ 2 ] + 3, _width, 34, CarDealer.Derma.Colors.FuelBox );
			surface.SetFont( CarDealer.Derma.Fonts.InfoFont );

			local _text = _fuel .. "/" .. _maxfuel .. " L";
			local _width, _height = surface.GetTextSize( _text );
			draw.SimpleText( _text, CarDealer.Derma.Fonts.InfoFont, ( ScrW() / 2 ) - ( _width / 2 ), ScrH() - 57 + ( _height / 2 ), CarDealer.Derma.Colors.FuelText );
		
		end
		
		if( CarDealer.Settings.DisplayMPH ) then
		
			local _texts = ( math.floor( _p:GetVehicle():GetVelocity():Length()/17.3 ) ) .. " MPH";
			local _widths, _height = surface.GetTextSize( _texts );
			
			local _tp = 0;
			
			if( _pos1 ) then
				_pos1t = { ( ScrW() / 2 ) - 200, ScrH() - 120 };
				_tp = ScrH() + ( _height / 2 ) - 117;
			else
				_tp = ScrH() - 57 + ( _height / 2 );
			end
			
			draw.RoundedBox( 5, _pos1t[ 1 ], _pos1t[ 2 ], 400, 40, Color( 130, 130, 130, 50 ) );
			local _width = math.floor( _p:GetVehicle():GetVelocity():Length()/17.3 );
			
			if( _width > 194 ) then
				_width = 194;
			end
			
			draw.RoundedBox( 0, _pos1t[ 1 ] + 6, _pos1t[ 2 ] + 3, _width * 2, 34, CarDealer.Derma.Colors.FuelBox );
			surface.SetFont( CarDealer.Derma.Fonts.InfoFont );

			draw.SimpleText( _texts, CarDealer.Derma.Fonts.InfoFont, ( ScrW() / 2 ) - ( _widths / 2 ), _tp, CarDealer.Derma.Colors.FuelText );
					
		end
		
	end

end );