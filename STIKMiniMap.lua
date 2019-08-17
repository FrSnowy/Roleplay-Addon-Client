function STIKMiniMapButton_OnClick()
    if MainPanelSTIK:IsVisible() then MainPanelSTIK:Hide();
    else MainPanelSTIK:Show();
    end
end

STIKMiniMapButtonPosition = {
	locationAngle = -45,
	x = 52-(80*cos(-45)),
	y = ((80*sin(-45))-52)
}

function STIKMiniMapButton_Reposition()
	STIKMiniMapButtonPosition.x = 52-(80*cos(STIKMiniMapButtonPosition.locationAngle))
	STIKMiniMapButtonPosition.y = ((80*sin(STIKMiniMapButtonPosition.locationAngle))-52)
	STIKMiniMapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",STIKMiniMapButtonPosition.x,STIKMiniMapButtonPosition.y)
end

function STIKMiniMapButtonPosition_LoadFromDefaults()
	STIKMiniMapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",STIKMiniMapButtonPosition.x,STIKMiniMapButtonPosition.y)
end

function STIK_Minimap_Update()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 
	ypos = ypos/UIParent:GetScale()-ymin-70

	STIKMiniMapButtonPosition.locationAngle = math.deg(math.atan2(ypos,xpos))
	STIKMiniMapButton_Reposition()
end