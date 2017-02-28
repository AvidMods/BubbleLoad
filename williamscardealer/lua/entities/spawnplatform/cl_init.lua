include('shared.lua')

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawShadow( false );
	if( self:GetColor().a == 0 ) then
		self:SetColor( Color( 255, 255, 255, 0 ) );
		return;
	end
	
	self:DrawModel();
	
	local _e = self;
	
	local mins = _e:OBBMins();
	local maxs = _e:OBBMaxs();
	local startpos = _e:GetPos();
	local dir = _e:GetUp();
	local len = 128;

	local tr = util.TraceHull( {
		start = startpos, 
		endpos = startpos + dir * len, 
		maxs = maxs, 
		mins = mins, 
		filter = _e
	} )
	
	local clr = color_white
	if ( tr.Hit ) then
		clr = Color( 255, 0, 0 );
	end

	render.DrawWireframeBox( startpos, self:GetAngles(), mins + Vector( 0, 0, 120 ), maxs, Color( 255, 255, 255, 255 ), true );
	render.DrawWireframeBox( startpos, self:GetAngles(), Vector( mins.x, 150, 118 ), maxs, Color( 255, 0, 0, 255 ), true );
end