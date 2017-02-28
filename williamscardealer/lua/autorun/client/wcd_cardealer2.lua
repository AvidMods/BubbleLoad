if( !vguidesign ) then
	vguidesign = nil;
else

end
		
if( !vguimain ) then
	vguimain = nil;
else

end

local vehicles = list.Get( "Vehicles" );

LocalPlayer().__GROUPS = {};

local vehCount = 0;
local function addCar( car, list, dealerid, dealer )
	
	if( !vehicles[ car ] || !CarDealer.Cars[ car ] ) then
		return;
	end

	
	if( CarDealer.Cars[ car ].dealerid ) then
		if( type( CarDealer.Cars[ car ].dealerid ) == "table" && !table.HasValue( CarDealer.Cars[ car ].dealerid ) ) then
			return;
		elseif( CarDealer.Cars[ car ].dealerid != dealerid ) then
			return;
		end
	elseif( dealerid != 0 ) then
		return;
	end
	
	vehCount = vehCount + 1;
	
	local model = "models/buggy.mdl";
	if( vehicles[ car ].Model ) then
		model = vehicles[ car ].Model;
	end
	
	local panel = vgui.Create( "DPanel" );
	panel:SetSize( list:GetWide(), 150 );
	if( vehCount % 2 == 0 ) then
		panel.Paint = function( self, w, h )	
			draw.RoundedBox( 0, 0, 0, w, h, CarDealer.Derma.vgui.EvenRow );
		end
	else
		panel.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CarDealer.Derma.vgui.UnevenRow );
		end
	end
	
	local carmdl = vgui.Create( "DModelPanel", panel );
	carmdl:SetModel( model );
	carmdl:SetCamPos( Vector(  200, 130, 120 ) );
	carmdl:SetLookAt( Vector( 0, 0, 30 ) );
	carmdl:SetSize( 300, 150 );
	carmdl:SetPos( -50, -10 );
	function carmdl:LayoutEntity( _ ) return end;
	
	local carname = vgui.Create( "DLabel", panel );
	carname:SetFont( "WalkWayLarge" );
	local name = "Needs manual name";
	if( CarDealer.Cars[ car ].name ) then
		name = CarDealer.Cars[ car ].name;
	elseif( vehicles[ car ].Name ) then
		name = vehicles[ car ].Name;
	end
	carname:SetPos( carmdl:GetWide() - 50, 10 );
	carname:SetText( name );
	carname:SetColor( CarDealer.Derma.vgui.InfoColorBig );
	carname:SizeToContents();
	
	local carinfo = vgui.Create( "DLabel", panel );
	carinfo:SetFont( "RobotoInfo" );
	carinfo:SetColor( CarDealer.Derma.vgui.InfoColor );
	carinfo:SetPos( carmdl:GetWide() - 50, 10 + carname:GetTall() );
	local info = "";
	local str = CarDealer.Derma.vgui.Price;
	if( CarDealer.Cars[ car ].requiresBuy ) then
		if( string.find( str, "!A" ) != nil ) then
			str = string.Replace( str, "!A", tostring( CarDealer.Cars[ car ].price ) );
		end
	else
		str = CarDealer.Derma.vgui.Free;
	end
	
	info = str .. "\n";
	
	if( CarDealer.Settings.Fuel ) then
		local str = CarDealer.Derma.vgui.TankSize;
		if( string.find( str, "!A" ) != nil ) then
			if( CarDealer.Cars[ car ].fuel ) then
				str = string.Replace( str, "!A", tostring( CarDealer.Cars[ car ].fuel ) );
			else
				str = string.Replace( str, "!A", tostring( CarDealer.Settings.DefaultFuel ) );
			end
		end
		info = info .. str .. "\n";
	end
	
	if( !CarDealer.Cars[ car ].disallowBodygroup ) then
		info = info .. CarDealer.Derma.vgui.Bodygroups .. #carmdl:GetEntity():GetBodyGroups() - 2 .. "\n";
	end
	
	if( !CarDealer.Cars[ car ].disallowPaint ) then
		info = info .. CarDealer.Derma.vgui.Paint[ 1 ] .. "\n";
		if( CarDealer.Config[ car ] && CarDealer.Config[ car ][ 1 ] ) then
			carmdl:SetColor( Color( CarDealer.Config[ car ][ 1 ].r, CarDealer.Config[ car ][ 1 ].g, CarDealer.Config[ car ][ 1 ].b ) );
		elseif( CarDealer.Derma.RandomColor ) then
			carmdl:SetColor( Color( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ), 255 ) );
		end
	else
		info = info .. CarDealer.Derma.vgui.Paint[ 2 ] .. "\n";
	end
	
	if( !CarDealer.Cars[ car ].disallowSkin ) then
		info = info .. CarDealer.Derma.vgui.SkinChange[ 1 ].."\n";
		if( CarDealer.Config[ car ] && CarDealer.Config[ car ][ 2 ] ) then
			carmdl:GetEntity():SetSkin(  CarDealer.Config[ car ][ 2 ] );
		end		
	else
		info = info .. CarDealer.Derma.vgui.SkinChange[ 2 ].."\n";
		if( CarDealer.Cars[ car ].defaultSkin ) then
			carmdl:GetEntity():SetSkin( CarDealer.Cars[ car ].defaultSkin );
		end

	end
	
	if( CarDealer.Cars[ car ].defaultSkin ) then
		carmdl:SetSkin( CarDealer.Cars[ car ].defaultSkin );
	end
	
	if( CarDealer.Cars[ car ].restricted ) then
		local str = CarDealer.Derma.RestrictedTextInfo;
		if( string.find( "!A", str ) != nil ) then
			str = string.Replace( str, "!A", CarDealer.Cars[ car ].restricted.name );
		end
		info = info .. str .. "\n";
	end
	
	carinfo:SetText( info );
	carinfo:SizeToContents();
	
	local buttons = {};
	
	local carconfig = CarDealer.Config[ car ];
	local customization = {};
	if( carconfig ) then
		customization.skin = carconfig[ 2 ];
		customization.color = carconfig[ 1 ];
		customization.bgs = carconfig[ 3 ];
	else
		customization.skin = carmdl:GetEntity():GetSkin();
		customization.color = Color( 255, 255, 255, 255 );
		customization.bgs = {};
	end
	
	if( LocalPlayer():HasAccessToCar( car ) ) then
		buttons.spawnbutton = vgui.Create( "WCD::SpawnButton", panel );
		buttons.spawnbutton:SetSize( 150, 60 );
		buttons.spawnbutton:SetPos( panel:GetWide() - 180, panel:GetTall() - buttons.spawnbutton:GetTall() );
		
		local customize = false;
		if( !CarDealer.Cars[ car ].disallowCustomize && !CarDealer.Settings.DisallowAllCustomization ) then
			buttons.customizebutton = vgui.Create( "WCD::SpawnButton", panel );
			buttons.customizebutton:SetSize( 150, 60 );
			buttons.customizebutton:SetPos( panel:GetWide() - buttons.customizebutton:GetWide() - buttons.spawnbutton:GetWide() - 40, panel:GetTall() - buttons.spawnbutton:GetTall() );
			buttons.customizebutton:SetText( CarDealer.Derma.vgui.Customize );
			buttons.customizebutton.DoClick = function()
			
					CarDealer:OpenDesign( car );
				if( CarDealer.Settings.MenuSounds ) then
					surface.PlaySound( "wcdbtn2.mp3" );
				end	
			end;
			customize = true;
		end
		
		if( LocalPlayer():OwnsCar( car ) ) then
			buttons.spawnbutton:SetText( CarDealer.Derma.vgui.Spawn );
			buttons.spawnbutton.DoClick = function()
			
				net.Start( "CarDealer::Spawn" );
				net.WriteString( car );
				net.WriteTable( customization );
				net.WriteFloat( dealer:EntIndex() );
				net.SendToServer();
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn1.mp3" );
		end		
			end;
			
			if( CarDealer.Cars[ car ].requiresBuy ) then
				buttons.sellbutton = vgui.Create( "WCD::SpawnButton", panel );
				buttons.sellbutton:SetSize( 150, 60 );
				if( !customize ) then
					buttons.sellbutton:SetPos( panel:GetWide() - buttons.sellbutton:GetWide() - buttons.spawnbutton:GetWide() - 50, panel:GetTall() - buttons.sellbutton:GetTall() );
				else
					buttons.sellbutton:SetPos( panel:GetWide() - buttons.sellbutton:GetWide() - buttons.customizebutton:GetWide() - buttons.spawnbutton:GetWide() - 50, panel:GetTall() - buttons.sellbutton:GetTall() );
				end
				local selltext = CarDealer.Derma.vgui.Sell;
				if( string.find( selltext, "!A" ) != nil ) then
					selltext = string.Replace( selltext, "!A", tostring( CarDealer.Settings.Percentage * 100 ) );
				end
				
				buttons.sellbutton:SetText( selltext );
				local clickssb = 0;
				buttons.sellbutton.DoClick = function()
					if( CarDealer.Settings.MenuSounds ) then
						surface.PlaySound( "wcdbtn2.mp3" );
					end
					clickssb = clickssb + 1;
					if( clickssb == 1 ) then
						buttons.sellbutton:SetText( "Click again" );
						return;
					end
					
					net.Start( "CarDealer::Sell" );
					net.WriteString( car );
					net.SendToServer();
					buttons.sellbutton:SetText( CarDealer.Derma.vgui.Sell );
					if( IsValid( vguimain ) ) then
						vguimain.list:Rebuild();
					end									
				end;
			end
		else
			if( !CarDealer.Cars[ car ].disallowTest && !CarDealer.Settings.DisallowAllTest ) then
				buttons.testbutton = vgui.Create( "WCD::SpawnButton", panel );
				buttons.testbutton:SetSize( 150, 60 );
				if( customize ) then
					buttons.testbutton:SetPos( panel:GetWide() - buttons.testbutton:GetWide() - buttons.customizebutton:GetWide() - buttons.spawnbutton:GetWide() - 50, panel:GetTall() - buttons.testbutton:GetTall() );
				else
					buttons.testbutton:SetPos( panel:GetWide() - buttons.testbutton:GetWide() - buttons.spawnbutton:GetWide() - 50, panel:GetTall() - buttons.testbutton:GetTall() );
				end
				buttons.testbutton:SetText( CarDealer.Derma.vgui.Test );
				
				buttons.testbutton.DoClick = function()
					net.Start( "CarDealer::TestDrive" );
					net.WriteString( car );
					net.WriteFloat( dealer:EntIndex() );
					net.SendToServer();
					
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn2.mp3" );
		end							
				end;
				
				
			end
			buttons.spawnbutton:SetText( CarDealer.Derma.vgui.Buy );
			local clicksbuy = 0;
			buttons.spawnbutton.DoClick = function()
				if( CarDealer.Settings.MenuSounds ) then
					surface.PlaySound( "wcdbtn2.mp3" );
				end			
				clicksbuy = clicksbuy + 1;
			
				if( clicksbuy == 1 ) then
					buttons.spawnbutton:SetText( "Click again" );
					return;
				end
				
				net.Start( "CarDealer::Buy" );
				net.WriteString( car );
				net.SendToServer();
				
				buttons.spawnbutton:SetText( CarDealer.Derma.vgui.Buy );
				
				if( IsValid( vguimain ) ) then
					vguimain.list:Rebuild();
				end
							
			end;			
		end
	end
	
	list:Add( panel );
	
	return buttons;

end

function CarDealer:OpenDesign( car )

	local cardata = CarDealer.Cars[ car ];
	local carinfo = vehicles[ car ];
	local carconfig = CarDealer.Config[ car ];
	if( !carconfig ) then
		carconfig = false;
	end
	local customization = {};
	customization.skin = 0;
	customization.bgs = {};
	customization.color = Color( 255, 255, 255, 255 );
	
	
	if( !cardata || !carinfo ) then
		return;
	end
	
	if( IsValid( vguimain ) ) then
		vguimain:Hide();
	end
	
	local main = vgui.Create( "WCD::DFrame" );
	main:SetSize( ScrW() - ScrW() / 5, ScrH() - ScrH() / 6 );
	main:Center();
	main:SetVisible( true );
	main:MakePopup( true );
	main:ShowCloseButton( false );
	main:SetDraggable( false );
	main:SetTitle( "" );
	vguidesign = main;
	
	local buttons = {};
	buttons.close = vgui.Create( "WCD::ButtonClose", main );
	buttons.close:SetText( CarDealer.Derma.vgui.BackButton );
	buttons.close:SetSize( 150, 50 );
	buttons.close:SetPos( main:GetWide() - ( buttons.close:GetWide() + 30 ), 10 );
	buttons.close.DoClick = function()
		
		if( IsValid( vguimain ) ) then
			vguimain:Show();
			vguimain.list:Rebuild();
		end

		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn1.mp3" );
		end		
		
		main:Close();
	
	end;
	
	buttons.save = vgui.Create( "WCD::SaveButton", main );
	buttons.save:SetText( CarDealer.Derma.vgui.SaveButton );
	buttons.save:SetSize( 150, 50 );
	buttons.save:SetPos( main:GetWide() - ( buttons.close:GetWide() * 2 + 40 ), 10 );
	buttons.save.DoClick = function( self )
		
		CarDealer:SetConfig( car, customization.color, customization.bgs, customization.skin );
		self:SetClicked( 255 );
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn2.mp3" );
		end
	
	end;
	
	local container = vgui.Create( "DPanel", main );
	container:SetSize( main:GetWide() - 60, main:GetTall() - 120 );
	container:SetPos( 30, 60 );
	container.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CarDealer.Derma.vgui.DesignContainer );
	end;
	
	local modelholder = vgui.Create( "DAdjustableModelPanel", container );
	modelholder:SetSize( main:GetWide() * 0.7, container:GetTall() );
	modelholder:SetPos( 0, 0 );
	modelholder:SetModel( carinfo.Model );
	modelholder.aLookAngle = Angle( 40, 0, 0 );
	modelholder.vCamPos = Vector( 160, 160, 160 );
	modelholder.vCamPos = modelholder.Entity:OBBCenter() - modelholder.aLookAngle:Forward() * modelholder.vCamPos:Length()
	
	function modelholder:LayoutEntity( _ ) return end;

	local configholder = vgui.Create( "DScrollPanel", container );
	configholder:SetSize( main:GetWide() * 0.3, container:GetTall() );
	configholder:SetPos( modelholder:GetWide(), 0 );
	configholder.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) );
		draw.RoundedBoxEx( 4, 0, 10, 5, h - 20, CarDealer.Derma.vgui.Line, true, true, true, true );
	end;
	
	local carname = vgui.Create( "DLabel", main );
	carname:SetFont( "WalkWayLarge" );
	carname:SetColor( CarDealer.Derma.vgui.InfoColorBig );
	carname:SetPos( 33, 34 );
	local name = "Needs manual name";
	if( CarDealer.Cars[ car ].name ) then
		name = CarDealer.Cars[ car ].name;
	elseif( vehicles[ car ].Name ) then
		name = vehicles[ car ].Name;
	end
	carname:SetText( name );
	carname:SizeToContents();


	local y = 50 + carname:GetTall();
	if( !cardata.disallowPaint ) then
		local colorholder = vgui.Create( "DPanel", configholder );
		colorholder:SetSize( configholder:GetWide() - 120, 200 );
		colorholder:SetPos( 30, 30 );
		
		local mixer = vgui.Create( "DColorMixer", colorholder );
		mixer:SetAlphaBar( false );
		mixer:SetWangs( false );
		mixer:SetPalette( false );
		mixer:Dock( FILL );
		mixer.ValueChanged = function( color )
		
			modelholder:SetColor( mixer:GetColor() );
			customization.color = Color( mixer:GetColor().r, mixer:GetColor().g, mixer:GetColor().b );
		
		end;

		if( carconfig && carconfig[ 1 ] ) then
			modelholder:SetColor( Color( carconfig[ 1 ].r, carconfig[ 1 ].g, carconfig[ 1 ].b, 255 ) );
			customization.color = Color( carconfig[ 1 ].r, carconfig[ 1 ].g, carconfig[ 1 ].b, 255 );
		end
		
		y = y + colorholder:GetTall();
	end
	

	
	if( !cardata.disallowSkin && modelholder:GetEntity():SkinCount() > 0 ) then

		local skintext = vgui.Create( "DLabel", configholder );
		skintext:SetPos( 30, y );
		skintext:SetText( CarDealer.Derma.vgui.SkinText );
		skintext:SetFont( "RobotoInfoLarge" );
		skintext:SetColor( CarDealer.Derma.vgui.InfoColor );
		skintext:SizeToContents();
		
		local skinbar = vgui.Create( "WCD::ComboBox", configholder );
		skinbar:SetValue( modelholder:GetEntity():GetSkin() );
		skinbar:SetPos( 35 + skintext:GetWide(), y );
		function skinbar.OnSelect( p, i, v )
		
			modelholder:GetEntity():SetSkin( v );
			customization.skin = v;
		
		end;

		
		if( carconfig && carconfig[ 2 ] ) then
			modelholder:GetEntity():SetSkin( carconfig[ 2 ] );
			skinbar:SetValue( carconfig[ 2 ] );
			customization.skin = carconfig[ 2 ];
		end
			
		local count = 0;
		while( count < modelholder:GetEntity():SkinCount() ) do
			if( count != tostring( skinbar:GetValue() ) ) then
				skinbar:AddChoice( count );
			end
			count = count + 1;
		end
		
		y = y + skinbar:GetTall();

		
	end
	
	if( !cardata.DisallowBodygroups && #modelholder:GetEntity():GetBodyGroups() - 2 > 0 ) then
	
		count = 0;
		local bodygroups = {};
		
		for i, v in pairs( modelholder:GetEntity():GetBodyGroups() ) do
		
			if( v.num < 2 ) then
				continue;
			end
			
			if( carinfo.disallowBodygroups && table.HasValue( carinfo.disallowBodygroups, v.name ) ) then
				continue;
			end
			
			count = count + 1;
			
			local x = 30;
			if( count % 2 == 0 ) then
				x = 160;
			end

			local name = v.name;
			if( CarDealer.Bodygroups[ v.name ] ) then
			
				name = CarDealer.Bodygroups[ v.name ];
			
			end
			
			bodygroups[ i ] = vgui.Create( "DLabel", configholder );
			bodygroups[ i ]:SetFont( "RobotoInfoLarge" );
			bodygroups[ i ]:SetColor( CarDealer.Derma.vgui.InfoColor );
			bodygroups[ i ]:SetText( name );
			bodygroups[ i ]:SetPos( x, y );
			bodygroups[ i ]:SizeToContents();
		
			
			if( v.num == 2 ) then
				bodygroups[ i ].change = vgui.Create( "WCD::CheckBox", configholder );
				bodygroups[ i ].change:SetPos( x, y + bodygroups[ i ]:GetTall() );
				bodygroups[ i ].change:SetChecked( false );
				customization.bgs[ v.id ] = 0;
				
				if( carconfig && carconfig[ 3 ] && carconfig[ 3 ][ v.id ] ) then
					bodygroups[ i ].change:SetValue( carconfig[ 3 ][ v.id ] );
					modelholder:GetEntity():SetBodygroup( v.id, carconfig[ 3 ][ v.id ] );
				
					if( carconfig[ 3 ][ v.id ] == 1 ) then
						bodygroups[ i ].change:SetChecked( true );
						customization.bgs[ v.id ] = 1;
					else
						customization.bgs[ v.id ] = 0;
					end
				end
				
				bodygroups[ i ].change.OnChange = function( val )

					if( bodygroups[ i ].change:GetChecked() ) then
						modelholder:GetEntity():SetBodygroup( v.id, 1 );
						customization.bgs[ v.id ] = 1;
					else
						modelholder:GetEntity():SetBodygroup( v.id, 0 );
						customization.bgs[ v.id ] = 0;
					end
				
				end;
			else
				bodygroups[ i ].change = vgui.Create( "WCD::ComboBox", configholder );
				bodygroups[ i ].change:SetPos( x, y + bodygroups[ i ]:GetTall() );
				bodygroups[ i ].change:SetValue( "Select" );
				customization.bgs[ v.id ] = 0;
				if( carconfig && carconfig[ 3 ] && carconfig[ 3 ][ v.id ] ) then
				
					bodygroups[ i ].change:SetValue( carconfig[ 3 ][ v.id ] );
					modelholder:GetEntity():SetBodygroup( v.id, carconfig[ 3 ][ v.id ] );
					
				end
				
				local icount = 0;
				while( icount < v.num ) do
					if( icount == bodygroups[ i ].change:GetValue() ) then
						continue;
					end
					bodygroups[ i ].change:AddChoice( icount );
					icount = icount + 1;
				end
				
				bodygroups[ i ].change.OnSelect = function( p, i2, v2 )
				
					modelholder:GetEntity():SetBodygroup( v.id, v2 );
					customization.bgs[ v.id ] = v2;
				
				end;
				

			end
			
			if( count % 2 == 0 ) then
				y = y + bodygroups[ i ]:GetTall() + bodygroups[ i ].change:GetTall() + 3;
			end			

		end
	
	end
	
end

function CarDealer:OpenDerma( dealer, dealerid )
	
	if( !IsValid( dealer ) ) then
		return;
	end
	
	local main = vgui.Create( "WCD::DFrame" );
	main:SetSize( ScrW() - ScrW() / 5, ScrH() - ScrH() / 6 );
	main:Center();
	main:SetVisible( true );
	main:MakePopup( true );
	main:ShowCloseButton( false );
	main:SetDraggable( false );
	main:SetTitle( "" );
	vguimain = main;
	
	local view = 1;

		
	local buttons = {};
	buttons.close = vgui.Create( "WCD::ButtonClose", main );
	buttons.close:SetText( CarDealer.Derma.vgui.CloseButton );
	buttons.close:SetSize( 150, 50 );
	buttons.close:SetPos( main:GetWide() - ( buttons.close:GetWide() + 30 ), 10 );
	buttons.close.DoClick = function()
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn2.mp3" );
		end	
		main:Close();
	
	end;
	
	local bottom = vgui.Create( "DScrollPanel", main );
	bottom:SetSize( 0.6 * main:GetWide() + 0.4 * main:GetWide() - 60, 200 );	
	bottom:SetPos( 30, main:GetTall() - bottom:GetTall() - 30 );
	bottom.Paint = function( self, w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 0 ) );
	end

	local carselect = vgui.Create( "DScrollPanel", main );
	carselect:SetSize( main:GetWide() - 60, main:GetTall() - 120 );	
	carselect:SetPos( 30, 60 );
	carselect.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CarDealer.Derma.vgui.Container );
	end;
	local sbar = carselect:GetVBar();
	
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 118, 118, 118, 150 ) );
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 118, 118, 118, 118 ) );
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 118, 118, 118, 118 ) );
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 0, 0, 0, 180 ) );
	end

	
	local list = vgui.Create( "DIconLayout", carselect );
	list:SetSize( carselect:GetWide(), carselect:GetTall() );
	list:SetPos( 0, 0 );
	list:SetSpaceY( 0 );
	main.list = list;
	local carbuttons = {};
	list.Rebuild = function()	
		list:Clear();
		vehCount = 0;
		
		for i, v in pairs( carbuttons ) do
			carbuttons[ i ] = nil;
		end
		
		
	
		
		if( view == 1 ) then
			for i, v in pairs( LocalPlayer():GetAccessCars() ) do
				carbuttons = addCar( v, list, dealerid, dealer );
			end
		elseif( view == 2 ) then
			for i, v in pairs( LocalPlayer():GetUnownedCars() ) do
				carbuttons = addCar( v, list, dealerid, dealer );
			end
		else
			for i, v in pairs( LocalPlayer():GetNoAccessCars() ) do
				carbuttons = addCar( v, list, dealerid, dealer );
			end
		end
		
		if( type( carbuttons ) != "table" ) then
			carbuttons = {};
		end
	end;
	
	list:Rebuild();	
	
	buttons[ 1 ] = vgui.Create( "WCD::ButtonMenu", main );
	buttons[ 1 ]:SetText( CarDealer.Derma.vgui.AccessButton );
	buttons[ 1 ]:SetState( true );
	buttons[ 1 ].DoClick = function()
		view = 1;
		buttons[ 1 ]:SetState( true );
		buttons[ 2 ]:SetState( false );
		buttons[ 3 ]:SetState( false );
		list:Rebuild();
		
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn1.mp3" );
		end			
	end;
	
	buttons[ 2 ]= vgui.Create( "WCD::ButtonMenu", main );
	buttons[ 2 ]:SetText( CarDealer.Derma.vgui.Unowned );
	buttons[ 2 ].DoClick = function()
		view = 2;
		buttons[ 2 ]:SetState( true );
		buttons[ 3 ]:SetState( false );
		buttons[ 1 ]:SetState( false );
		list:Rebuild();
		
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn1.mp3" );
		end				
	end;	
	buttons[ 3 ] = vgui.Create( "WCD::ButtonMenu", main );
	buttons[ 3 ]:SetText( CarDealer.Derma.vgui.NoAccess );
	buttons[ 3 ].DoClick = function()
		view = 3;
		buttons[ 3 ]:SetState( true );
		buttons[ 2 ]:SetState( false );
		buttons[ 1 ]:SetState( false );
		list:Rebuild();
		
		if( CarDealer.Settings.MenuSounds ) then
			surface.PlaySound( "wcdbtn1.mp3" );
		end				
	end;
	
	
	local count = 0;
	local dealershippos = 0;
	for i, v in pairs( buttons ) do
		if( i != "close" ) then
			
			buttons[ i ]:SetSize( 150, 50 );
			local x = ( 30 + buttons[ i ]:GetWide() * count + count * 15 );
			buttons[ i ]:SetPos( x, 10 );
			count = count + 1;
		end
	end
	
end
net.Receive( "CarDealer::Derma", function( len )

	CarDealer:OpenDerma( Entity( net.ReadFloat() ) , net.ReadFloat() );

end );

net.Receive( "CarDealer::Update", function( len )
	CarDealer.Owned = net.ReadTable();
	if( CarDealer.Owned == nil ) then
		CarDealer.Owned = {};
	end
	if( CarDealer.Settings.Order == 1 ) then
//		SortCars();
	end
	
	if( IsValid( vguimain ) ) then
		vguimain.list:Rebuild();
	end	

end );

net.Receive( "CarDealer::Groups", function( len )

	LocalPlayer().__GROUPS = net.ReadTable();

end );

concommand.Add( "cardealer", function() CarDealer:OpenDerma() end );