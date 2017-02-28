function CarDealer:OpenCarDealerMenu( _e,_id, _platforms )

	 // Main Frame \\
	local _main = vgui.Create( "DFrame" );
	_main.w = 400;
	_main.h = 220;
	_main:SetSize( _main.w, _main.h );
	_main:Center();
	_main:SetTitle( "Car Dealer Setup" );
	_main:SetVisible( true );
	_main:SetDraggable( true );
	_main:ShowCloseButton( true );
	_main:MakePopup();
	_main.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CarDealer.Derma.Colors.BGElement );
	end;
	// End Main Frame \\
	
	local _data = {};
	_data[ "model" ] = "Model path";
	_data[ "cid" ] = "Deal cars with ID";
	
	local _boxes = {};
	
	local _c = 1;
	local _pos = 25;
	for i, v in pairs( _data ) do
		_boxes[ i ] = vgui.Create( "DLabel", _main );
		_boxes[ i ]:SetText( v );
		_boxes[ i ]:SizeToContents();
		_boxes[ i ]:SetPos( 30, _pos );
		
		_boxes[ i ].value = vgui.Create( "DTextEntry", _main );
		_boxes[ i ].value:SetPos( 30, _pos + 15 );
		_boxes[ i ].value:SetSize( 150, 30 );
		_pos = 75 * _c;
		_c = _c + 1;
		
	end
	local _pl = {};
	_pl[ "label" ] = vgui.Create( "DLabel", _main );
	if( #_platforms == 0 ) then
		_pl[ "label" ]:SetText( "No platforms set up" );
	else
		_pl[ "label" ]:SetText( #_platforms .. " platforms" );
	end
	_pl[ "label" ]:SizeToContents();
	_pl[ "label" ]:SetPos( 210, 25 );
	
	_pl[ "add" ] = vgui.Create( "DButton", _main );
	_pl[ "add" ]:SetText( "Add platform" );
	_pl[ "add" ]:SizeToContents();
	_pl[ "add" ]:SetSize( 150, 30 );
	_pl[ "add" ]:SetPos( 210, 40 );
	_pl[ "add" ].DoClick = function()
	
		net.Start( "CarDealer::AddPlatform" );
		net.WriteFloat( _e:EntIndex() );
		net.SendToServer();
		_main:Close();
	
	end;
	
	_pl[ "remove" ] = vgui.Create( "DButton", _main );
	_pl[ "remove" ]:SetText( "Remove platforms" );
	_pl[ "remove" ]:SizeToContents();
	_pl[ "remove" ]:SetSize( 150, 30 );
	_pl[ "remove" ]:SetPos( 210, 90 );	
	_pl[ "remove" ].DoClick = function()
		net.Start( "CarDealer::RemovePlatforms" );
		net.WriteFloat( _e:EntIndex() );
		net.SendToServer();
		_main:Close();
	end;
	
	
	_boxes[ "cid" ].value:SetValue( _id );
	_boxes[ "model" ].value:SetValue( _e:GetModel() );

	_boxes[ "name" ] = vgui.Create( "DTextEntry", _main );
	_boxes[ "name" ]:SetPos( 30, _pos - 15 );
	_boxes[ "name" ]:SetSize( 330, 30 );
	_boxes[ "name" ]:SetValue( _e:GetNWString( "name", "Unnamed" ) );
	
	_boxes[ "name" ].text = vgui.Create( "DLabel", _main );
	_boxes[ "name" ].text:SetText( "Dealer name" );
	_boxes[ "name" ].text:SizeToContents();
	_boxes[ "name" ].text :SetPos( 30, _pos - 28 );
			
		
	local _submit = vgui.Create( "DButton", _main );
	_submit:SetText( "Save settings" );
	_submit:SetSize( 150, 30 );
	_submit:SetPos( 30, _pos + 20 );
	_submit.DoClick = function()
		
		if( _boxes[ "cid" ] == nil ) then
			_p:ChatPrint( "Invalid dealer ID!" );
			return;
		end
		
		if( _boxes[ "model" ] == nil ) then
			_p:ChatPrint( "Invalid model!" );
			return;
		end
		

		_pos = 75 * _c;
		
		net.Start( "CarDealer::Modify" );
		net.WriteFloat( tonumber( _boxes[  "cid" ].value:GetValue() ) );
		net.WriteString( _boxes[ "model" ].value:GetValue() );
		net.WriteFloat( _e:EntIndex() );
		net.WriteString( _boxes[  "name" ]:GetValue() );
		net.SendToServer();
		_main:Close();
		
	end;
	
	local delete = vgui.Create( "DButton", _main );
	delete:SetText( "Delete dealer" );
	delete:SetSize( 150, 30 );
	delete:SetPos( 210, _pos + 20 );
	delete.DoClick = function()
		net.Start( "CarDealer::Remove" );
		net.WriteFloat( _e:EntIndex() );
		net.SendToServer();
		_main:Close();
	end;
end;



net.Receive( "CarDealer::Modify", function( _p, len )

	local _e = Entity( net.ReadFloat() );
	
	local _id = net.ReadFloat();
	local _platforms = net.ReadTable();
	if( !IsValid( _e ) || !_id || !isnumber( _id ) ) then
		return false;
	end

	CarDealer:OpenCarDealerMenu( _e, _id, _platforms );
	print( "Opening the car dealer configuration menu." );

end );