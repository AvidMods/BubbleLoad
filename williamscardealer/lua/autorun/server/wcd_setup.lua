util.AddNetworkString( "CarDealer::Modify" );
util.AddNetworkString( "CarDealer::RemovePlatforms" );
util.AddNetworkString( "CarDealer::AddPlatform" );

hook.Add( "PlayerSay", "CarDealer::Modify", function( _p, _t, _tc )
	if( _t == "!caradmin" ) then
		if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
			_p:ChatPrint( "You don't have access to this command." );
			return false;
		else
			net.Start( "CarDealerAdmin::Derma" );
			net.Send( _p );
		end
		return;
	end
	
	if( _t == "!cardealer" ) then
		if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
			_p:ChatPrint( "You don't have access to this command." );
			return false;
		else
			local _tr = _p:GetEyeTrace();
			if( !_tr.HitNonWorld || !IsValid( _tr.Entity ) || _tr.Entity:GetClass() != "cardealer" ) then
				_p:ChatPrint( "That's not a car dealer!" );
				return false;
			end
		
			net.Start( "CarDealer::Modify" );
				net.WriteFloat( _tr.Entity:EntIndex() );
				net.WriteFloat( _tr.Entity:GetDealerID() );
				net.WriteTable( _tr.Entity.platforms );
			net.Send( _p );
			
			PrintTable( _tr.Entity.platforms );
			
			_p:ChatPrint( "This car dealers platforms are visible until you Save Settings." );
			for i, v in pairs( _tr.Entity.platforms ) do
				v:SetColor( Color( 255, 255, 255, 255 ) );
			end
			return false;
		end
	end
end );


local function SpawnCarDealers()
	for i, v in pairs( ents.FindByClass( "cardealer" ) ) do
		v:Remove();
	end
	
	if( file.Exists( "williamscardealer/" .. game.GetMap() .. "_cardealers.txt", "DATA" ) ) then
		local _tbl = util.JSONToTable( file.Read( "williamscardealer/" ..game.GetMap() .. "_cardealers.txt", "DATA" ) );

		for i, v in pairs( _tbl ) do
			local _e = ents.Create( "cardealer" );
			_e:SetPos( v[ 1 ] );
			_e:SetAngles( v[ 2 ] );
			_e:SetNWString( "name", v[ 6 ] );
			_e:Spawn();
			_e:SetModel( v[ 3 ] );
			_e.dealerid = v[ 4 ];
			
			for i2, v2 in pairs( v[ 5 ]) do
				local _e2 = ents.Create( "spawnplatform" );
				_e2:SetPos( v2[ 1 ] );
				_e2:SetAngles( v2[ 2 ] );
				_e2:SetColor( Color( 255, 255, 255, 0 ) );
				_e2:Spawn();
				table.insert( _e.platforms, _e2 );
			end
		end
		
		print( "#Car Dealer: Spawned " .. #_tbl .. " car dealers!" );
	else
		print( "#Car Dealer: No car dealers saved!" );
	end
end

function GenerateAllMyCarsPlease()

	local write = "";
	
	for i, v in pairs( list.Get( "Vehicles" ) ) do
	
		if( string.find( i, "tdm" ) != nil ) then
		
			write = write .. '\n\nCarDealer.Cars[ "' .. i .. '"] = {\n\trequiresBuy = true,\n\tprice = 0,\n\tfuel=100\n}\n';
		
		end
	
	end
	
	file.Write( "TDMCARSGENERATED.txt", write );

end

local function SpawnFuelFloors()
	for i, v in pairs( ents.FindByClass( "fuelpump_base" ) ) do
		v:Remove();
	end
	
		if( file.Exists( "williamscardealer/" .. game.GetMap() .. "_fuelpumps.txt", "DATA" ) ) then
			local _tbl = util.JSONToTable( file.Read( "williamscardealer/" .. game.GetMap() .. "_fuelpumps.txt", "DATA" ) );

			for i, v in pairs( _tbl ) do
				local _e = ents.Create( "fuelpump_base" );
				_e:SetPos( v[ 1 ] );
				_e:SetAngles( v[ 2 ] );
				_e:Spawn();
			end
			
			print( "#Car Dealer: Spawned " .. #_tbl .. " fuel pumps!" );
		else
			print( "#Car Dealer: No fuel pumps saved!" );
		end

end

hook.Add( "InitPostEntity", "SpawnCarDealers", function()
	if( !file.Exists( "williamscardealer", "data" ) ) then
		file.CreateDir( "williamscardealer" );
	end
	
		
	timer.Simple( 60, function()	
		if( !CarDealer.__st ) then
			SpawnCarDealers();
			SpawnFuelFloors();
		else
			hook.Call( "CarDealerSetupContinuation" );
			for i, v in pairs( CarDealer ) do
				if( i != "__st" ) then
					CarDealer[ i ] = nil;
				end
			end
		end
	end );
	
end );

hook.Add( "PlayerInitialSpawn", "wcd::SpawnFailureCheck", function( _p )

	if( #player.GetAll() == 1 ) then
		SpawnCarDealers();
		SpawnFuelFloors();
	end

end );


hook.Add( "PlayerInitialSpawn", "SpawnCarDealersAgain", function( _p )

	for i, v in pairs( ents.FindByClass( "fuelpump" ) ) do
		if( IsValid( v ) && IsValid( v.Sound ) ) then
			v.Sound:Remove();
			v.Sound = nil;
			v.Sound = CreateSound( v, "ambient/water/water_run1.wav", v:EntIndex() );
		end
	end

end );

local function SaveCarDealers()
	local _tbl = {};

	for i, v in pairs( ents.FindByClass( "cardealer" ) ) do
		local _platforms = {};
		for i2, v2 in pairs( v.platforms ) do
			_platforms[ i2 ] = { v2:GetPos(), v2:GetAngles() };
			v2:Remove();
		end
		_tbl[ i ] = { v:GetPos(), v:GetAngles(), v:GetModel(), v:GetDealerID(), _platforms, v:GetNWString( "name", "Unnamed" ) };
		v:Remove();
	end
	
	file.Write( "williamscardealer/" .. game.GetMap() .. "_cardealers.txt", util.TableToJSON( _tbl ) );

	SpawnCarDealers();
end

local function SaveFuelFloors()
	local _tbl = {};
	
	for i, v in pairs( ents.FindByClass( "fuelpump_base" ) ) do
		_tbl[ i ] = { v:GetPos(), v:GetAngles() };
		v:Remove();
	end
	
	file.Write( "williamscardealer/" .. game.GetMap() .. "_fuelpumps.txt", util.TableToJSON( _tbl ) );
	
	DarkRP.notify( _p, 0, 5, "Fuel pumps saved!" );

	SpawnFuelFloors();
end

net.Receive( "CarDealerAdmin::Save", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	end
	SaveCarDealers();
	_p:ChatPrint( "All car dealers has been saved." );
	
end );

net.Receive( "CarDealerAdmin::SaveFuel", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	end
	SaveFuelFloors();
	_p:ChatPrint( "All fuel pumps has been saved." );
	
end );

net.Receive( "CarDealerAdmin::Remove", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	end
	for i, v in pairs( ents.FindByClass( "cardealer" ) ) do
		for i2, v2 in pairs( v.platforms ) do
			v2:Remove();
		end
		v:Remove();
	end
	
	timer.Simple( 1, function()
		SaveCarDealers();
	end );
	_p:ChatPrint( "All car dealers has been deleted." );
	
end );

net.Receive( "CarDealerAdmin::RemoveFuel", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	end
	for i, v in pairs( ents.FindByClass( "fuelpump_base" ) ) do
		v:Remove();
	end
	timer.Simple( 1, function()
		SaveFuelFloors();
	end );
	_p:ChatPrint( "All fuel pumps has been deleted." );
	
end );

hook.Add( "PlayerDisconnected", "CarDealer::RemoveDisconnected", function( _p )

	local _id = _p:SteamID64();
	for i, v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
		if( IsValid( v ) && v.CarOwner == _id ) then
			RemoveDisconnected( _id, v );
			return;
		end
	end
	for i, v in pairs( ents.FindByClass( "prop_vehicle_jeep_old" ) ) do
		if( IsValid( v ) && v.CarOwner == _id ) then
			RemoveDisconnected( _id, v );
		end
	end


end );


net.Receive( "CarDealer::AddPlatform", function( len, _p )

	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		_p:ChatPrint( "Platform created." );
		local _e = Entity( net.ReadFloat() );

		local _platform = ents.Create( "spawnplatform" );
		_platform:SetPos( _e:GetPos() + ( _e:GetForward() * ( CarDealer.Settings.AwayFromDealer + 50 ) ) );
		_platform:SetColor( Color( 255, 255, 255, 255 ) );
		_platform:Spawn();
		_e.platforms[ #_e.platforms + 1 ] = _platform;
	end
end );

net.Receive( "CarDealer::RemovePlatforms", function( len, _p )

	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local _e = Entity( net.ReadFloat() );
		if( !IsValid( _e ) ) then
			return false;
		end
		
		for i, v in pairs( _e.platforms ) do
			v:Remove();
		end

		_p:ChatPrint( "Removed " .. #_e.platforms .. " platforms." );
		_e.platforms = nil;
		_e.platforms = {};
		
	end
end );

net.Receive( "CarDealer::Remove", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local ent = Entity( net.ReadFloat() );
		if( IsValid( ent ) ) then
			
			for i2, v2 in pairs( ent.platforms ) do
				v2:Remove();
			end
			
			ent:Remove();
			
			timer.Simple( 1, function()
				SaveCarDealers();
			end );
			
			_p:ChatPrint( "Removed car dealer" );
		end
	end
end );

net.Receive( "CarDealerAdmin::GiveCar", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local user = net.ReadString();
		local car = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == user ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			table.insert( CarDealer.Players[ ply:SteamID64() ], car );
			CarDealer:UpdateClient( ply );
			net.Start( "CarDealerAdmin::GetCars" );
			net.WriteTable( CarDealer.Players[ ply:SteamID64() ] );
			net.Send( _p );
			_p:ChatPrint( "Car given to " .. user .. "." );
			ply:ChatPrint( car .. " was given to you by " .. _p:Nick() );
			
			if( CarDealer.Settings.MySQL.Using ) then
				CarDealer.__DB:Save( ply );
			else
				_p:SetPData( CarDealer.Settings.MySQL.Table, util.TableToJSON( CarDealer.Players[ ply:SteamID64() ] ) );
				CarDealer:UpdateClient( ply );
			end			
		end
		
	end
end );

net.Receive( "CarDealerAdmin::DeleteAll", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local user = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == user ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			CarDealer.Players[ ply:SteamID64() ] = {};

			net.Start( "CarDealerAdmin::GetCars" );
			net.WriteTable( CarDealer.Players[ ply:SteamID64() ] );
			net.Send( _p );
			_p:ChatPrint( "All cars removed from " .. user .. "." );
			ply:ChatPrint( "All your cars were removed by " .. _p.Nick() );
			
			if( CarDealer.Settings.MySQL.Using ) then
				CarDealer.__DB:Save( ply );
			else
				ply:SetPData( CarDealer.Settings.MySQL.Table, util.TableToJSON( CarDealer.Players[ ply:SteamID64() ] ) );
				CarDealer:UpdateClient( ply );
			end
		end
		
	end
end );

net.Receive( "CarDealerAdmin::RemoveCar", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local user = net.ReadString();
		local car = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == user ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			table.RemoveByValue( CarDealer.Players[ ply:SteamID64() ], car );
			net.Start( "CarDealerAdmin::GetCars" );
			net.WriteTable( CarDealer.Players[ ply:SteamID64() ] );
			net.Send( _p );
			_p:ChatPrint( "Car removed from " .. user .. "." );
			ply:ChatPrint( car .. " was removed from you by " .. _p:Nick() );
			
			if( CarDealer.Settings.MySQL.Using ) then
				CarDealer.__DB:Save( ply );
			else
				ply:SetPData( CarDealer.Settings.MySQL.Table, util.TableToJSON( CarDealer.Players[ ply:SteamID64() ] ) );
				CarDealer:UpdateClient( ply );
			end
		end
		
	end
end );

net.Receive( "CarDealerAdmin::GetCars", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local nick = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == nick ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			net.Start( "CarDealerAdmin::GetCars" );
			net.WriteTable( CarDealer.Players[ ply:SteamID64() ] );
			net.Send( _p );
		end
	end
end );

net.Receive( "CarDealer::Modify", function( len, _p )

	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local _id = net.ReadFloat();
		local _mdl = net.ReadString();
		local _e = Entity( net.ReadFloat() );
		local _name = net.ReadString();
		
		if( !isnumber( _id ) || !_mdl || !IsValid( _e ) ) then
			return false;
		end
		
		_e.dealerid =_id;
		_e:SetModel( _mdl );
		_e:SetNWString( "name", _name );
		
		for i, v in pairs( _e.platforms ) do
			v:SetColor( Color( 255, 255, 255, 0 ) );
		end
	
		_p:ChatPrint( "Dealer updated and saved!" );
		SaveCarDealers();
	end
end );

function RemoveDisconnected( _id, _e )

	timer.Create( _id.."DelCar", CarDealer.Settings.DeleteOnDisconnect, 1, function()

		local _found = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:SteamID64() == _id ) then
				_found = true;
			end
		end
		
		if( IsValid( _e ) && !_found ) then
			_e:Remove();
		end
	
	end );

end

net.Receive( "CarDealerAdmin::GetGroups", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local nick = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == nick ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			local groups = util.JSONToTable( ply:GetPData( "cardealergroups", "[]" ) );
			net.Start( "CarDealerAdmin::GetGroups" );
			net.WriteTable( groups );
			net.Send( _p );
		end
	end
end );

net.Receive( "CarDealerAdmin::AddGroup", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local nick = net.ReadString();
		local group = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == nick ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			
			local groups = util.JSONToTable( ply:GetPData( "cardealergroups", "[]" ) );
			table.insert( groups, group );
			ply.__GROUPS = groups;
			ply:SetPData( "cardealergroups", util.TableToJSON( groups ) );
			net.Start( "CarDealerAdmin::GetGroups" );
			net.WriteTable( groups );
			net.Send( _p );
			net.Start( "CarDealer::Groups" );
			net.WriteTable( groups );
			net.Send( ply );			
			ply:ChatPrint( "You were added into car dealer group " .. group .. " by " .. _p:Nick() .. "." );
			_p:ChatPrint( "Added " .. ply:Nick() .. " into car dealer group " .. group .. "." );
		end
	end
end );

net.Receive( "CarDealerAdmin::RemoveGroup", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local nick = net.ReadString();
		local group = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == nick ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			
			local groups = util.JSONToTable( ply:GetPData( "cardealergroups", "[]" ) );
			table.RemoveByValue( groups, group );
			ply.__GROUPS = groups;
			ply:SetPData( "cardealergroups", util.TableToJSON( groups ) );
			net.Start( "CarDealerAdmin::GetGroups" );
			net.WriteTable( groups );
			net.Send( _p );
			net.Start( "CarDealer::Groups" );
			net.WriteTable( groups );
			net.Send( ply );			
			ply:ChatPrint( "You were removed from car dealer group " .. group .. " by " .. _p:Nick() .. "." );
			_p:ChatPrint( "Removed " .. ply:Nick() .. " from car dealer group " .. group .. "." );			
		end
	end
end );

net.Receive( "CarDealerAdmin::DeleteAllGroups", function( len, _p )
	if( !table.HasValue( CarDealer.Settings.AdminMenu, _p:GetUserGroup() ) ) then
		_p:ChatPrint( "You don't have access to this command." );
		return false;
	else
		local nick = net.ReadString();
		local group = net.ReadString();
		local ply = false;
		for i, v in pairs( player.GetAll() ) do
			if( v:Nick() == nick ) then
				ply = v;
				break;
			end
		end
		
		if( !ply ) then
			_p:ChatPrint( "Invalid player." );
		else
			
			local groups = util.JSONToTable( ply:GetPData( "cardealergroups", "[]" ) );
			table.RemoveByValue( groups, group );
			ply.__GROUPS = groups;
			ply:SetPData( "cardealergroups", util.TableToJSON( groups ) );
			net.Start( "CarDealerAdmin::GetGroups" );
			net.WriteTable( groups );
			net.Send( _p );
			net.Start( "CarDealer::Groups" );
			net.WriteTable( groups );
			net.Send( ply );
			ply:ChatPrint( "Your car dealer groups were removed by " .. _p:Nick() .. "." );
			_p:ChatPrint( "Removed all groups from " .. ply:Nick() .. "." );			
		end
	end
end );