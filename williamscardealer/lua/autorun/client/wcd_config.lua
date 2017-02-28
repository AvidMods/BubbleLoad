--[[ #NoSimplerr# ]]
// This file is used for bodygroup/color saving settings clientside

local g = Color( 0, 255, 0, 255 );
local r = Color( 255, 0, 0, 255 );

CarDealer.Config = {};
	
	
function CarDealer:GetConfig()
	
	MsgC( "Attempting to get your preferred cars configuration..\n\n", g );
	
	if( file.Exists( CarDealer.Settings.Folder .. "/config.txt", "DATA" ) ) then
		MsgC( "Configuration found.\n\n", g );
	else
		if( !file.Exists( CarDealer.Settings.Folder, "DATA" ) ) then
			file.CreateDir( CarDealer.Settings.Folder );
		end
		file.Write( CarDealer.Settings.Folder .. "/config.txt", util.TableToJSON( "{}" ) );
		MsgC( "Configuration not found, created file.\n\n", g );
	end
	
	CarDealer.Config = util.JSONToTable( file.Read( CarDealer.Settings.Folder .. "/config.txt" ) );
	if( !CarDealer.Config || type( CarDealer.Config ) != "table" ) then
		CarDealer.Config = {};
	end
	MsgC( "Configuration file loaded.\n\n", g );
	
	
end

function CarDealer:SetConfig( _veh, _clr, _args, _skin )

	MsgC( "Attempting to set config for: " .. _veh .."\n\n", g );

	if( !CarDealer.Config || type( CarDealer.Config ) != "table" ) then
		CarDealer:GetConfig();
	end
	
	if( !CarDealer.Cars[ _veh ] ) then
		return;
	end
	CarDealer.Config[ _veh ] = { _clr, _skin, _args };
	for i, v in pairs( _args ) do
		CarDealer.Config[ _veh ][ 3 ][ i ] = v;
	end
	file.Write( CarDealer.Settings.Folder .. "/config.txt", util.TableToJSON( CarDealer.Config ) );
	MsgC( "Config updated.\n\n", g );
	CarDealer:GetConfig();
	

end

CarDealer:GetConfig();