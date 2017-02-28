net.Receive( "CarDealer::StartSound", function( len )

	local _e = Entity( net.ReadFloat() );
	if( IsValid( _e ) && !_e.Sound ) then
		_e.Sound = CreateSound( _e, "ambient/water/water_run1.wav", _e:EntIndex() );
		_e.Sound:Play();
	end
	
end );

net.Receive( "CarDealer::StopSound", function( len )

	local _e = Entity( net.ReadFloat() );
	if( IsValid( _e ) && _e.Sound ) then
		_e.Sound:Stop();
		_e.Sound = nil;
	end

end );