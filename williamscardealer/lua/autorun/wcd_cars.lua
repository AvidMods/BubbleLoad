// This file is for cars only!
/*
				if you need any help you are welcome to add me:
				http://steamcommunity.com/id/Busan1

	Format:
	CarDealer.Cars[ "entityname" ] = {
		requiresBuy = true/false,
		restricted = { name = "Government", jobs = { TEAM_POLICE } },
		price = 25000,
		disallowPaint = false,
		disallowSkin = false,
		disallowBodygroups = false,
		defaultSkin = 1,
		fuel = 100,
		fuelLoss = 5000,
		dealerid = 1,
		name = "NAME IS NOT REQUIRED"
	}
	
	requiresBuy: this has to be set, always!
	false is good for  donator/police cars
	false means that it's 100% free to spawn
	it doesn't save in the database
	so if it at some point changes to true,
	then players need to buy it.
	
	restricted: this doesn't have to be set
	if it is, then you can use:
	jobs = { TEAM_POLICE, TEAM_SWAT  etc },
	AND, OR:
	ranks = { "donator", "vipdonator" }
	If you want to restrict to police + donator, that means:
	restricted = { name = "VIP or Police", jobs = { TEAM_POLICE }, ranks = { "donator" }, needboth = false }
	if you want to restrict to VIP OR police, or VIP AND police,
	use needboth.
	needboth = true = must be donator + police
	needboth = false = must be donator OR police
	
	price = 25000, how much does it cost?
	^ should be set always ^
	
	disallowPaint = can the car be painted?(good for police cars)
	^ not required to be set, defaults to false ^
	
	disallowSkin  = can the car skin be changed?(good for police cars)
	^ not required to be set, defaults to false ^
	
	disallowBodygroups = can you change bodygroups?(good for police cars)
	^ not required to be set, defaults to false ^
	
	defaultSkin = set a default skin(good for police cars)
	^ not required to be set, defaults to false ^
	
	fuel = how many litres of fuel is in the car?
	^ doesn't have to be set, it will default to wcd_settings.lua^
	
	fuelLoss = 5000 - if a car should lose  more or less fuel.
	^ doesn't have to be set, it defaults to whatever is set in wcd_settings.lua(line 65)
	default value: 3500
	
	dealerid = 5
	^ does not have to be set ^
	defaults to 0
	if you set to something else than 0, all dealers with this id will deal the cars
	useful to make a Police car dealer etc.
	It can  also look like:
	dealerid = { 1, 2, 3 } if multiple car dealers sell this car!
	
	name = "anything"
	This will overwrite the default name(taken from Q menu)
	
	not set means that you don't need it!
	A car can look this easy:
	CarDealer.Cars[ "camarozl1tdm" ] = {
		requiresBuy = true,
		price = 50000
	}
	
*/

// THESE ARE  JUST SOME EXAMPLE CARS!
// If you dont have these cars on the server
// You will be unable to open the car dealer menu
// Please read the description above on how to add your own cars
function InitializeSharedCarDealer()

	if( !CarDealer ) then
		return;
	end

	// PLEASE READ THE TEXT ABOVE TO UNDERSTAND HOW TO ADD A CAR.
	// YOU CAN GENERATE ALL TDM CARS BY TYPING IN YOUR SERVER/WEB CONSOLE:
	// lua_run GenerateAllMyCarsPlease()
	// THEN GO TO garrysmod/data/GENERATEDCARS.txt 
	// COPY EVERYTHING AND PASTE BELOW.
	// THEN SET PRICES and add any of the config things you find above.
	
	
	CarDealer.Cars[ "gallardospydtdm" ] = {
		price = 10000,
		fuel = 100,
		requiresBuy = true
	}
	
	
	
	
	
	
	 
	
	
	// Editing done!
	CarDealer.MaxFuelFromModel = {};
	for i, v in pairs( list.Get( "Vehicles" ) ) do
		if( CarDealer.Cars[ i ] && v.Model ) then
			v.Model  = string.lower( v.Model );
			CarDealer.MaxFuelFromModel[ v.Model ] = CarDealer.Cars[ i ].fuel or CarDealer.Settings.DefaultFuel;
			util.PrecacheModel( v.Model );
		end
	end

end

InitializeSharedCarDealer();
