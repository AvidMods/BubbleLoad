// vgui

// DFrame main
local PANEL = {};

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( 6, 0, 0, w, h, CarDealer.Derma.vgui.BG, true, true, true, true );
end

vgui.Register( "WCD::DFrame", PANEL, "DFrame" );

// button
local PANEL = {};
function PANEL:Init()
	self.colors = table.Copy( CarDealer.Derma.vgui.MenuButton );
	self:SetColor( Color( 255, 255, 255, 255 ) );
	self:SetFont( "RobotoInfoLarge" );
	AccessorFunc( PANEL, "active", "State", FORCE_BOOL );
end

function PANEL:Paint( w, h )
	if( self:GetState() ) then
		local color = table.Copy( self.colors );
		color.a = 180;
		draw.RoundedBoxEx( 6, 0, 0, w, h, color, true, true, false, false );
	else
		draw.RoundedBoxEx( 6, 0, 0, w, h, self.colors, true, true, false, false );
	end
end

function PANEL:OnCursorEntered()
    self.colors.a = 180;
end;

function PANEL:OnCursorExited()
   self.colors.a = 120;
end;

vgui.Register( "WCD::ButtonMenu", PANEL, "DButton" );

// combobox
local PANEL = {};
function PANEL:Init()
	self:SetColor( CarDealer.Derma.vgui.BoxColor );
end

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( 6, 0, 0, w, h, CarDealer.Derma.vgui.ComboBox, true, true, true, true );
end

function PANEL:OnCursorEntered()

end;

function PANEL:OnCursorExited()

end;

vgui.Register( "WCD::ComboBox", PANEL, "DComboBox" );

// combobox
local PANEL = {};
function PANEL:Init()
	self:SetColor( CarDealer.Derma.vgui.BoxColor );
	self.material = Material( "materials/vgui/wcd/wcdtick.png" );
end

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( 6, 0, 0, w, h, CarDealer.Derma.vgui.CheckBox, true, true, true, true );
	if( self:GetChecked() ) then
		surface.SetDrawColor( 255, 255, 255, 255 );
		surface.SetMaterial( self.material );
		surface.DrawTexturedRect( 0, 0, w, h );
	end
end

function PANEL:OnCursorEntered()

end;

function PANEL:OnCursorExited()

end;

vgui.Register( "WCD::CheckBox", PANEL, "DCheckBox" );

// Spawn button
local PANEL = {};
function PANEL:Init()
	self.colors = table.Copy( CarDealer.Derma.vgui.SpawnButton );
	self:SetColor( Color( 255, 255, 255, 255 ) );
	self:SetFont( "RobotoInfoLarge" );
end

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( 6, 0, 0, w, h, self.colors, true, true, false, false );
end

function PANEL:OnCursorEntered()
    self.colors.a = 180;
end;

function PANEL:OnCursorExited()
   self.colors.a = 120;
end;

vgui.Register( "WCD::SpawnButton", PANEL, "DButton" );

// Spawn button
local PANEL = {};
AccessorFunc( PANEL, "ClickTime", "Clicked", FORCE_NUMBER );
function PANEL:Init()
	self.colors = table.Copy( CarDealer.Derma.vgui.SaveButtonClr );
	self:SetColor( Color( 255, 255, 255, 255 ) );
	self:SetFont( "RobotoInfoLarge" );
	self.material = Material( "materials/vgui/wcd/wcdtick.png" );
	self:SetClicked( 0 );
end

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( 6, 0, 0, w, h, self.colors, true, true, false, false );
	if( self:GetClicked() > 0 ) then
		surface.SetDrawColor( 255, 255, 255, self:GetClicked() );
		surface.SetMaterial( self.material );
		surface.DrawTexturedRect( 0, 0, w, h );
		self:SetClicked( self:GetClicked() - 1 );
	end		
end

function PANEL:OnCursorEntered()
    self.colors.a = 255;
end;

function PANEL:OnCursorExited()
   self.colors.a = 220;
end;

vgui.Register( "WCD::SaveButton", PANEL, "DButton" );

// Close button
local PANEL = {};
function PANEL:Init()
	self.colors = CarDealer.Derma.vgui.ButtonClose;
end

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( 6, 0, 0, w, h, self.colors, true, true, false, false );
end

function PANEL:OnCursorEntered()
    self.colors.r = 255;
end;

function PANEL:OnCursorExited()
   self.colors.r = 225;
end;

vgui.Register( "WCD::ButtonClose", PANEL, "WCD::ButtonMenu" );