if( !vguiframe ) then
	local vguiframe = nil;
else
	if( IsValid( vguiframe ) ) then
		vguiframe:Close();
		CarDealer:OpenCarAdminMenu();
	end
end

function CarDealer:OpenCarAdminMenu()

	 // Main Frame \\
	local _main = vgui.Create( "DFrame" );
	_main.w = 356;
	_main.h = 250;
	_main:SetSize( _main.w, _main.h );
	_main:Center();
	_main:SetTitle( "Car Dealer Admin" );
	_main:SetVisible( true );
	_main:SetDraggable( true );
	_main:ShowCloseButton( true );
	_main:MakePopup();
	_main.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CarDealer.Derma.Colors.BGElement );
	end;
	vguiframe = _main;
	
	local _sheet = vgui.Create( "DPropertySheet",  _main );
	_sheet:Dock( FILL );
	
	local _other = vgui.Create( "DPanel", _sheet );
	_sheet:AddSheet( "Management", _other, "icon16/world.png" );
	local user = vgui.Create( "DPanel", _sheet );
	_sheet:AddSheet( "User", user, "icon16/user.png" );
	local groups = vgui.Create( "DPanel", _sheet );
	_sheet:AddSheet( "Groups", groups, "icon16/application_view_detail.png" );
	
	local _y = 15;
	local _x = 15;
	
	local _panels = {};
	_panels[ "save" ] = vgui.Create( "DButton", _other );
	_panels[ "save" ]:SetText( "Save all car dealers" );
	_panels[ "save" ]:SetPos( _x, _y );
	_panels[ "save" ]:SetSize( 300, 30 );
	_panels[ "save" ].DoClick = function()
		net.Start( "CarDealerAdmin::Save" );
		net.SendToServer();
	end;
	
	_y = _y + 40;
	
	_panels[ "savefuel" ] = vgui.Create( "DButton", _other );
	_panels[ "savefuel" ]:SetText( "Save all fuel pumps" );
	_panels[ "savefuel" ]:SetPos( _x, _y );
	_panels[ "savefuel" ]:SetSize( 300, 30 );
	_panels[ "savefuel" ].DoClick = function()
		net.Start( "CarDealerAdmin::SaveFuel" );
		net.SendToServer();	
	end;
	
	_y = _y + 40;
	
	_panels[ "remove" ] = vgui.Create( "DButton", _other );
	_panels[ "remove" ]:SetText( "Unsave all car dealers" );
	_panels[ "remove" ]:SetPos( _x, _y );
	_panels[ "remove" ]:SetSize( 300, 30 );
	_panels[ "remove" ].DoClick = function()
		net.Start( "CarDealerAdmin::Remove" );
		net.SendToServer();
	end;
	
	_y = _y + 40;
	
	_panels[ "removefuel" ] = vgui.Create( "DButton", _other );
	_panels[ "removefuel" ]:SetText( "Unsave all fuel pumps" );
	_panels[ "removefuel" ]:SetPos( _x, _y );
	_panels[ "removefuel" ]:SetSize( 300, 30 );
	_panels[ "removefuel" ].DoClick = function()
		net.Start( "CarDealerAdmin::RemoveFuel" );
		net.SendToServer();	
	end;

	local y = 15;
	local x = 15;	
	// user
	local userbox = vgui.Create( "DComboBox", user );
	userbox:SetValue( "Select player" );
	userbox:SetSize( 300, 30 );
	for i, v in pairs( player.GetAll() ) do
		userbox:AddChoice( v:Nick() );
	end
	userbox:SetPos( x, y );
	
	userbox.OnSelect = function( panel, index, value )
	
		net.Start( "CarDealerAdmin::GetCars" );
		net.WriteString( value );
		net.SendToServer();
	
	end;
	
	y = y + 40;
	
	local cars = {};
	local carbox = vgui.Create( "DComboBox", user );
	carbox:SetValue( "Remove car" );
	carbox:SetSize( 150, 30 );
	carbox:SetPos( x, y );
	carbox.Rebuild = function()
		carbox:Clear();
		carbox:SetValue( "List updated" );
		for i, v in pairs( cars ) do
			carbox:AddChoice( v );
		end
	end;
	
	local carremove = vgui.Create( "DButton", user );
	carremove:SetText( "Remove" );
	carremove:SetSize( 140, 30 );
	carremove:SetPos( x + 160, y );
	carremove.DoClick = function()
	
		net.Start( "CarDealerAdmin::RemoveCar" );
		net.WriteString( userbox:GetValue() );
		net.WriteString( carbox:GetValue() );
		net.SendToServer();
		
	end;
	
	y = y + 40;
	
	local caradd = vgui.Create( "DComboBox", user );
	caradd:SetSize( 150, 30 );
	caradd:SetPos( x, y );
	caradd.Rebuild = function()
	
		caradd:Clear();
		caradd:SetValue( "Add car" );
		for i, v in pairs( CarDealer.Cars ) do
			if( !table.HasValue( cars, i ) && v.requiresBuy ) then
				caradd:AddChoice( i );
			end
		end
	
	end;
	
	caradd:Rebuild();

	net.Receive( "CarDealerAdmin::GetCars", function( len )
		cars = net.ReadTable();
		carbox:Rebuild();
		caradd:Rebuild();
	end );		
	
	
	local addbutton = vgui.Create( "DButton", user );
	addbutton:SetText( "Give car" );
	addbutton:SetPos( x + 160, y );
	addbutton:SetSize( 140, 30 );
	addbutton.DoClick = function()
	
		net.Start( "CarDealerAdmin::GiveCar" );
		net.WriteString( userbox:GetValue() );		
		net.WriteString( caradd:GetValue() );
		net.SendToServer();
	
	end;
	y = y + 40;
	
	local deleteall = vgui.Create( "DButton", user );
	deleteall:SetText( "Delete All Cars From User" );
	deleteall:SetPos( x, y );
	deleteall:SetSize( 300, 30 );
	deleteall.clicks = 0;
	deleteall.DoClick = function()
		deleteall.clicks = deleteall.clicks + 1;
		
		if( deleteall.clicks == 1 ) then
			deleteall:SetText( "Click again to confirm." );
		else		
			net.Start( "CarDealerAdmin::DeleteAll" );
			net.WriteString( userbox:GetValue() );
			net.SendToServer();			
		end
	
	end;
	
	y = 15;
	x = 15;
	
	local userboxgrp = vgui.Create( "DComboBox", groups );
	userboxgrp:SetValue( "Select player" );
	userboxgrp:SetSize( 300, 30 );
	for i, v in pairs( player.GetAll() ) do
		userboxgrp:AddChoice( v:Nick() );
	end
	userboxgrp:SetPos( x, y );
	
	userboxgrp.OnSelect = function( panel, index, value )
	
		net.Start( "CarDealerAdmin::GetGroups" );
		net.WriteString( value );
		net.SendToServer();
	
	end;
	y = y + 40;
	
	local usergroups = {};
	local groupbox = vgui.Create( "DComboBox", groups );
	groupbox:SetValue( "Remove group" );
	groupbox:SetSize( 150, 30 );
	groupbox:SetPos( x, y );
	groupbox.Rebuild = function()
		
		groupbox:Clear();
		groupbox:SetValue( "Group to remove" );
		for i, v in pairs( usergroups ) do
			groupbox:AddChoice( v );
		end
	
	end;
	

	
	local groupremove = vgui.Create( "DButton", groups );
	groupremove:SetText( "Remove" );
	groupremove:SetSize( 140, 30 );
	groupremove:SetPos( x + 160, y );
	groupremove.DoClick = function()
	
		net.Start( "CarDealerAdmin::RemoveGroup" );
		net.WriteString( userboxgrp:GetValue() );
		net.WriteString( groupbox:GetValue() );
		net.SendToServer();
		
	
	end;
	y = y + 40;
	
	local addgroupbox = vgui.Create( "DComboBox", groups );
	addgroupbox:SetSize( 150, 30 );
	addgroupbox:SetPos( x, y );
	addgroupbox.Rebuild = function()
	
		addgroupbox:Clear();
		addgroupbox:SetText( "Add group" );
	
		for i, v in pairs( CarDealer.Settings.Groups ) do
			
			if( table.HasValue( usergroups, v ) ) then
				continue;
			end
			addgroupbox:AddChoice( v );
		end
	
	end;
	addgroupbox:Rebuild();
	
	net.Receive( "CarDealerAdmin::GetGroups", function( len )
		usergroups = net.ReadTable();
		groupbox:Rebuild();
		addgroupbox:Rebuild();
	end );
	
	local addbutton = vgui.Create( "DButton", groups );
	addbutton:SetText( "Add group" );
	addbutton:SetSize( 140, 30 );
	addbutton:SetPos( x + 160, y );
	addbutton.DoClick = function()
	
		net.Start( "CarDealerAdmin::AddGroup" );
		net.WriteString( userboxgrp:GetValue() );
		net.WriteString( addgroupbox:GetValue() );
		net.SendToServer();
	
	end;
	y = y + 40;
	
	local deleteallgrp = vgui.Create( "DButton", groups );
	deleteallgrp:SetText( "Delete All Groups From User" );
	deleteallgrp:SetPos( x, y );
	deleteallgrp:SetSize( 300, 30 );
	deleteallgrp.clicks = 0;
	deleteallgrp.DoClick = function()
		deleteallgrp.clicks = deleteallgrp.clicks + 1;
		
		if( deleteallgrp.clicks == 1 ) then
			deleteallgrp:SetText( "Click again to confirm." );
		else		
			net.Start( "CarDealerAdmin::DeleteAllGroups" );
			net.WriteString( userboxgrp:GetValue() );
			net.SendToServer();			
		end
	end
	
end;

net.Receive( "CarDealerAdmin::Derma", function( len )

	CarDealer:OpenCarAdminMenu();
	print( "Opening the car dealer administration menu." );

end );