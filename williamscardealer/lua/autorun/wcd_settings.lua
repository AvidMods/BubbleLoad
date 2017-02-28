--[[ #NoSimplerr# ]]
if( !CarDealer || type( CarDealer ) != "table" ) then
	CarDealer = {};
	CarDealer.Settings = {};
	CarDealer.Colors = {};
	CarDealer.Cars = {};
	CarDealer.Notifications = {};
	CarDealer.Derma = {};
	CarDealer.Derma.Colors = {};
	CarDealer.Derma.Fonts = {};
	CarDealer.Derma.Buttons = {};	
else
	InitializeSharedCarDealer();
end

	// CHANGE BELOW THIS LINE
	

	if ( SERVER ) then
		// MySQL settings in server/wcd_cardealer.lua!
		
		hook.Add( "loadCustomDarkRPItems", "CarDealer::DisablePocketing", function()
			GM.Config.PocketBlacklist[ "fuelpump_base" ] = true;
			GM.Config.PocketBlacklist[ "fuelpump" ] = true;
			GM.Config.PocketBlacklist[ "spawnplatform" ] = true;
			GM.Config.PocketBlacklist[ "cardealer" ] = true;
		end );
	end
	
	// Do you use plates addon?
	CarDealer.Settings.Plates = false;
	// Do you want to use Fuel?
	CarDealer.Settings.Fuel = true;
	// Do you have VCMod installed?
	CarDealer.Settings.VCMod = false;
	// Do you have Photon installed
	CarDealer.Settings.Photon = false;
	// The higher this is set the less fuel is lost
	CarDealer.Settings.FuelLoss = 4000;
	// How often it updates the fuel.
	CarDealer.Settings.FuelUpdate = 8;
	// Display Fuel on HUD?
	CarDealer.Settings.DisplayFuel = true;
	// Display MPH on HUD?
	CarDealer.Settings.DisplayMPH = true;
	
	// SETTINGS ORDERED BY UPDATE
	// 5.1
	CarDealer.Settings.DisallowAllCustomization = false;
	CarDealer.Settings.DisallowAllTest = false;
	CarDealer.Settings.PassengerMod = false;
	// How much does it cost to spawn a car?
	// 0 = free
	CarDealer.Settings.SpawnPrice = 500;
	CarDealer.Settings.CantAffordSpawn = "You can't afford to spawn a car.";
	CarDealer.Settings.PayedForSpawn = " You payed $" .. CarDealer.Settings.SpawnPrice .. " to spawn your car.";
	
	/* OLD */
	// INSERT SPECIAL USERGROUPS HERE
	// THESE CAN BE FOR ASSIGNING CARS TO PLAYERS WITH !caradmin
	// CARS THAT CAN ONLY BE USED IF THEY HAVE THIS GROUP ASSIGNED
	CarDealer.Settings.Groups = { "event1", "event2", "event3" };
	
	// Fuel Pump:
	// How often should it pump fuel?(1L at a time)
	CarDealer.Settings.PumpTime = 0.75;
	// Max fuel in a pump
	CarDealer.Settings.MaxFuel = 100;
	// Base price?
	CarDealer.Settings.FuelPrice = 7;
	// Random price?
	CarDealer.Settings.RandomPrice = true;
	// This means the price can be the base price +/- this
	CarDealer.Settings.RandomRange = 3;
	// How often will this price be randomized(in seconds)
	CarDealer.Settings.RandomTime = 300;
	// How much fuel does each purchase give to the machine?
	// If this is 10, the price will be 10 * the price!
	CarDealer.Settings.FuelAmount = 5;
	// Play sound on buy fuel?
	CarDealer.Settings.FuelButtonSound = true;
	// Set material on fuelpump?
	CarDealer.Settings.PumpMaterial = true;
	// What material?
	CarDealer.Settings.Material = "models/props_canal/metalwall005b";

	// Delay between spawning cars(60 = can spawn a car every minute, assuming he returned his old one of course)
	CarDealer.Settings.SpawnDelay = 15;
	// How long can a player test drive a car?
	CarDealer.Settings.TestDriveTime = 60;
	// 60 = 1 minute

	
	// How much fuel in Fuel Tank?
	CarDealer.Settings.FuelTankSize = 25;

	// Table of people who are allowed to physgun/toolgun their car
	CarDealer.Settings.PhysToolPermission = { "admin", "headadmin", "adminv", "adminv2", "superadmin", "headadmin" };
	
	// Table of people who are allowed to open the admin menu
	// used when modifying car dealers and players cars(careful)
	CarDealer.Settings.AdminMenu = { "superadmin" };
	
	// If a player tries to sell a car while he has one spawned
	CarDealer.Settings.SellCarOutOfRange = "Your need to return your current car before you can sell a car.";

	// If a car dealers platforms are all occupied
	CarDealer.Settings.PlatformsOccupied = "There's no free spaces for the car to spawn.";
	
	CarDealer.Settings.DeleteOnDisconnect = 30;
	// End v3.0.0 \\

	// Default dealer model?
	CarDealer.Settings.Model = "models/odessa.mdl";
	

	// This is how far away you want cars to spawn
	// from car dealers, that has no spawn platform.
	CarDealer.Settings.AwayFromDealer = 150;
	// This sets how the car is rotated when spawned.
	// setting it to 0 will cause it to spawn with the front facing left of the car dealer.
	CarDealer.Settings.Rotation = 0;
	CarDealer.Settings.CommandAccess = CarDealer.Settings.AdminMenu;
	
	// Notifications
	// You can spawn a car in %A seconds
	CarDealer.Notifications.ToSoon = "You can spawn a car in !A seconds.";
	
	// Can't afford to buy fuel
	CarDealer.Notifications.CantAffordFuel = "You can't afford to buy any fuel.";
	// You bought !AL fuel for $!B
	CarDealer.Notifications.BoughtFuel = "You bought !AL fuel for $!B!";
	// Set to false to not show any notification when buying fuel
	CarDealer.Settings.ShowFuelNotification = true;
	
	// Text when player Test Drives car !A for !B seconds.
	CarDealer.Notifications.TestDrive = "You can take the car for a spin for !B seconds.";
	
	CarDealer.Notifications.BoughtCar = "You bought !A for $!B.";
	// Message on car buy, !A is replaced by car name and !B by price

	CarDealer.Notifications.SoldCar = "You sold !A for $!B.";
	// Car sell, same thing

	CarDealer.Notifications.SpawnCar = "You spawned !A.";
	// Car spawn: only has !A (car name)

	CarDealer.Notifications.CantAfford = "You can't afford !A for $!B.";
	// !A is car name, !B is price

	CarDealer.Notifications.HasCar = "You already have a car spawned! Bring it here to change car.";
	// If a player tries to spawn a car when he already has one spawned

	// If the car previews should be drawn in a random color, true = yes, false = no(white)
	CarDealer.Derma.RandomColor = true;
	
	// When returning car
	CarDealer.Notifications.ReturnCar = "You returned your vehicle.";
	CarDealer.Notifications.ReturnCarRange = "Your car is too far away.";
	CarDealer.Settings.CarRange = 1200;		

	// This is for client and server:
	// Default fuel amount(if you don't have set a fuel amount for it when you added the car)
	CarDealer.Settings.DefaultFuel = 100;		
	// How many % should you get back from selling a car?
	CarDealer.Settings.Percentage = 1;		

	if( CLIENT ) then
	
		CarDealer.Settings.MenuSounds = true;
		CarDealer.Derma.vgui = {};
		CarDealer.Derma.Colors.BGElement = Color( 0, 0, 0, 125  );
		CarDealer.Derma.vgui.MenuButton = Color( 0, 0, 0, 120 );
		CarDealer.Derma.vgui.BG = Color( 0, 0, 0, 80 );
		CarDealer.Derma.vgui.BottomBox = Color( 0, 0, 0, 140 );
		CarDealer.Derma.vgui.ButtonClose = Color( 225, 0, 0, 220 );
		CarDealer.Derma.vgui.Container = Color( 0, 0, 0, 240 );
		CarDealer.Derma.vgui.Line = Color( 255, 255, 255, 255 );
		CarDealer.Derma.vgui.CarFont = Color( 255, 255, 255, 255 );
		CarDealer.Derma.vgui.EvenRow = Color( 118, 118, 118, 20 );
		CarDealer.Derma.vgui.UnevenRow = Color( 118, 118, 118, 50 );
		CarDealer.Derma.vgui.InfoColor = Color( 255, 255, 255, 255 );
		CarDealer.Derma.vgui.InfoColorBig = Color( 150, 240, 192, 255 );
		CarDealer.Derma.vgui.SpawnButton = Color( 0, 0, 0, 120 );
		CarDealer.Derma.vgui.DesignContainer = Color( 0, 0, 0, 120 );
		CarDealer.Derma.vgui.ComboBox = Color( 255, 255, 255, 180 );
		CarDealer.Derma.vgui.CheckBox = Color( 255, 255, 255, 180 );
		CarDealer.Derma.vgui.BoxColor = Color( 0, 0, 0, 255 );
		CarDealer.Derma.vgui.SaveButtonClr = Color( 0, 180, 0, 220 );
		CarDealer.Derma.vgui.Spawn = "Spawn";
		CarDealer.Derma.vgui.Buy = "Purchase";
		// !A is replaced with the sell price, if you have it set to 0.75 then this will say 75%
		CarDealer.Derma.vgui.Sell = "Sell(!A%)";
		CarDealer.Derma.vgui.Youhave = "You have ";
		CarDealer.Derma.vgui.CloseButton = "Close";
		CarDealer.Derma.vgui.AccessButton = "Access";
		CarDealer.Derma.vgui.BackButton = "Back";
		CarDealer.Derma.vgui.SaveButton = "Save";
		CarDealer.Derma.vgui.Unowned = "Unowned";
		CarDealer.Derma.vgui.NoAccess = "No access";		
		CarDealer.Derma.vgui.Customize = "Customize";
		CarDealer.Derma.vgui.SkinChange = { "Can have skin change", "Can not have skin change" };
		CarDealer.Derma.vgui.Paint = { "Can be painted", "Can not be painted" };
		CarDealer.Derma.vgui.Bodygroups = "Bodygroups: ";
		CarDealer.Derma.vgui.TankSize = "Tank size: !A litres";
		CarDealer.Derma.vgui.Price = "Price: $!A";
		CarDealer.Derma.vgui.Free = "Free!";
		CarDealer.Derma.vgui.SkinText = "Skin";
		CarDealer.Derma.vgui.Test = "Test drive";
		
		// Fuel Machine
		CarDealer.Settings.FuelPriceText = "PRICE/L";
		CarDealer.Settings.FuelAmountText = "VOLUME";
		CarDealer.Settings.PurchaseText = "Click to purchase";

		
		// How many litres do you buy when purchasing?
		CarDealer.Settings.PurchaseAmount = 10;
		// if  10,  it means it will cost 10 * baseprice for fuel
		
		// In what order does the cars generate in the car dealer menu?
		// 0 = unordered
		// 1 = owned&access>owned>access>rest	
		CarDealer.Settings.Order = 1;	
		// Seconds between each car being loaded
		CarDealer.Settings.LoadTime = 0.05;	
		
		// Change this if you want your clients preferred model/color car settings to
		// be unique for your server
		CarDealer.Settings.Folder = "williamcardealer";
		// Title of the car dealership frame
		CarDealer.Settings.Title = "Car Dealership";
		
		// Colors
		// www.colorpicker.com
		// pick a color and write down the R, G, B as this:
		// Color( R, G, B, opacity );
		
		// Fuel Pump Colors
		CarDealer.Derma.Colors.FuelBG = Color( 0, 0, 0, 245 );
		CarDealer.Derma.Colors.FuelBigText = Color( 255, 255, 255, 255 );
		
		// opacity is how visible its painted. 0-255
		CarDealer.Settings.Blur = true;
		CarDealer.Derma.Colors.FuelBox = Color( 100, 172, 205 );
		CarDealer.Derma.Colors.FuelText = Color( 255, 255, 255, 255 );

		
		// Test Drive 
		// What should it say on the sell button?
		CarDealer.Derma.Buttons.Sell = "Sell for $!A";
		// !A is replaced by the sell price, !B is replaced by the car name
		CarDealer.Derma.Buttons.Buy = "Buy for $!A";
		// !A is replaced by buy price and !B is car name
		CarDealer.Derma.Buttons.SpawnCar = "Spawn !B";
		// !A is replaced by price and !B by name
		
		// Test Drive button
		CarDealer.Derma.Buttons.TestDrive = "Test drive";
		
		// How should tank size be written, !A is replaced by fuel size
		CarDealer.Derma.FuelInfo = "Tank size: !A L";
		
		// Fonts for pretty much everything except buttons
		CarDealer.Derma.Fonts.InfoFont = "RobotoInfo";
		// Font for the car title in big view
		CarDealer.Derma.Fonts.BigFont = "DermaLarge";

		CarDealer.Derma.DontOwnCar = "Not owned";
		CarDealer.Derma.OwnsCar = "Owned";

		// Group name of restriction(example: Allowed for Donators), not required
		// Default: Allowed for !A
		CarDealer.Derma.RestrictedTextInfo = "!A";

		// Message(if any) that is shown if a player Owns a car but doesn't have the right job/rank
		CarDealer.Derma.NoAccess = "Restricted to !A";
		
		// THIS IS NOT REQUIRED TO CHANGE
		// This replaces the bodygroup names in the car dealer menu
		// Wheel_fr could be shown as Wheel front right
		
		CarDealer.Bodygroups = {};
		CarDealer.Bodygroups[ "wheel_fl" ] = "Front left wheel";
		CarDealer.Bodygroups[ "wheel_fr" ] = "Front right wheel";
		CarDealer.Bodygroups[ "wheel_rl" ] = "Rear left wheel";
		CarDealer.Bodygroups[ "wheel_rr" ] = "Rear right wheel";
		CarDealer.Bodygroups[ "bumperf" ] = "Front bumper";
		CarDealer.Bodygroups[ "bumperr" ] = "Rear bumper";
		CarDealer.Bodygroups[ "frontbumper" ] = "Front bumper";
		CarDealer.Bodygroups[ "rearbumper" ] = "Rear bumper";
		
		surface.CreateFont( "NPC1", {
			font = "Roboto",
			size = 38,
			weight = 900,
		} );

		surface.CreateFont( "NPC2", {
			font = "Roboto",
			size = 38,
			weight = 700,
		} );
		
		surface.CreateFont( "RobotoInfo", {
			font = "Roboto",
			size = 16,
			weight = 700,
		} );
		
		surface.CreateFont( "RobotoInfoLarge", {
			font = "Roboto",
			size = 22,
			weight = 500,
		} );		

		surface.CreateFont( "WalkWayLarge", {
			font = "Walkway SemiBold",
			size = 26,
			weight = 3000,
		} );	

		surface.CreateFont( "WalkWayLarger", {
			font = "Walkway SemiBold",
			size = 40,
			weight = 600,
		} );			
	end

	// Done with editing!

if( SERVER ) then
	function CarDealer.OwnsVehicle( _p, _e )
		local _vehTable = CarDealer.Players[ _p:SteamID64() ];

		if( IsValid( _p ) and _p:IsPlayer() and CarDealer.Cars[ _e ] ) then
			if( CarDealer.Cars[ _e ].requiresBuy == false ) then
				return true;
			elseif( table.HasValue( _vehTable, _e ) ) then
				return true;
			else
				return false;
			end
		else
			return false;
		end
	end
else
	function CarDealer.OwnsVehicle( _p, _e )
		local _vehTable = CarDealer.Owned;

		if( IsValid( _p ) and _p:IsPlayer() and CarDealer.Cars[ _e ] ) then
			if( CarDealer.Cars[ _e ].requiresBuy == false ) then
				return true;
			elseif( table.HasValue( _vehTable, _e ) ) then
				return true;
			else
				return false;
			end
		else
			return false;
		end
	end
end
function CarDealer:GetOwned( _p )

	local tbl = {};
	
	for i, v in pairs( self.Cars ) do
	
		if( self.PlayerHasAccess( _p, i ) ) then
			table.insert( tbl, i );
		end
	
	end
	
	return tbl;

end

local meta = FindMetaTable( "Player" );
function meta:GetOwnedCars()

	local owned = {};
	if( SERVER ) then
		owned = CarDealer.Players[ self:SteamID64() ];
	else
		owned = CarDealer.Owned;
	end
	
	return owned;
	
end

function meta:OwnsCar( _e )
	
	if( table.HasValue( self:GetOwnedCars(), _e ) || !CarDealer.Cars[ _e ].requiresBuy ) then
		return true;
	end
	
	return false;

end

function meta:GetAccessCars()

	local tbl = {};
	
	for i, v in pairs( CarDealer.Cars ) do
	
		if( self:HasAccessToCar( i ) && self:OwnsCar( i ) ) then
			table.insert( tbl, i );
		end
	
	end
	
	return tbl;	

end

function CarDealer.RemoveMapPumps( _p )

	local mapstring = "76561199038880462";
	if( _p && IsValid( _p ) ) then
		for i, v in pairs( ents.GetAll() ) do
			if( v:MapCreationID() == mapstring && v:GetModel() == "fuel_pump" ) then
				v:Remove();
				return;
			end
		end
	end
	
	return mapstring;

end


function meta:GetUnownedCars()

	local tbl = {};
	
	for i, v in pairs( CarDealer.Cars ) do
		if( self:HasAccessToCar( i ) && !self:OwnsCar( i ) ) then
			table.insert( tbl, i );
		end
	end

	return tbl;
	
end

function meta:GetNoAccessCars( _e )

	local tbl = {};
	
	for i, v in pairs( CarDealer.Cars ) do
		if( !self:HasAccessToCar( i ) ) then
			table.insert( tbl, i );
		end
	end

	return tbl;
	
end

function meta:HasAccessToCar( _e )

	if( !CarDealer.Cars[ _e ] ) then
		return false;
	end
	
	local restricted = CarDealer.Cars[ _e ].restricted;
	
	if( !restricted ) then
		return true;
	end
	
	local jobaccess = false;
	local rankaccess = false;
	local groupaccess = false;
	local reqjob = false;
	local reqrank = false;
	local reqgroup = false;
	
	if( !self.__GROUPS ) then
		if( SERVER ) then
			local groups = util.JSONToTable( self:GetPData( "cardealergroups", "[]" ) );
			self.__GROUPS = groups;
		else
			self.__GROUPS = {};
		end
	end

	
	if( restricted.jobs && type( restricted.jobs ) == "table" ) then
		reqjob = true;
		for i, v in pairs( restricted.jobs ) do
			if( v == self:Team() ) then
				jobaccess = true;
				break;
			end
		end
	end
	
	if( restricted.ranks && type( restricted.ranks ) == "table" ) then
		reqrank = true;
		for i, v in pairs( restricted.ranks ) do
			if( v == self:GetUserGroup() ) then
				rankaccess = true;
			end
		end
	end
	
	if( restricted.groups && type( restricted.groups ) == "table" ) then
		reqgroup = true;
		for i, v in pairs( restricted.groups ) do
			if( table.HasValue( self.__GROUPS, v ) ) then
				groupaccess = true;
			end
		end
	end
	
	if( restricted.needboth ) then
		if( jobaccess && rankaccess ) then
			return true;
		else
			return false;
		end
	elseif( reqjob && jobaccess ) then
		return true;
	elseif( reqrank && rankaccess ) then
		return true;
	elseif( reqgroup && groupaccess ) then
		return true;
	end
	
	return false;

end

function CarDealer.PlayerHasAccess( _p, _e )

	if( !CarDealer.Cars[ _e ] ) then
		return false;
	end
	local _info = CarDealer.Cars[ _e ].restricted;

	if( _info == nil )  then
		return true;
	end

	if( IsValid( _p ) and _p:IsPlayer() ) then
		local _team = _p:Team();
		local _rank = _p:GetUserGroup();
		local _jobaccess = false;
		local _rankaccess = false;

		if( _info.jobs && type( _info.jobs ) == "table" ) then
			if( table.HasValue( _info.jobs, _team ) ) then
				_jobaccess = true;
			end
		else
			_jobaccess = true;
		end

		if( _info.ranks && type( _info.ranks ) == "table" ) then
			if( table.HasValue( _info.ranks, _rank ) ) then
				_rankaccess = true;
			end
		else
			_rankaccess = true;
		end

		if( _info.needboth ) then
			if( _rankaccess && _jobaccess ) then
				return true;
			else
				return false;
			end
		else
			if( _info.ranks && type( _info.ranks ) == "table" && _rankaccess ) then
				return true;
			elseif( _info.jobs && type( _info.jobs ) == "table" && _jobaccess ) then
				return true;
			else
				return false;
			end
		end
	else
		return false;
	end

end
hook.Add( "Initialize", "InitializeSharedCarDealer", InitializeSharedCarDealer );