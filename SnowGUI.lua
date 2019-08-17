-- Создание и управление типичными ГУИ-элементами --

SnowGUI = function ()
    return {
        showPanelHint = function(self)
            if (self.hint) then
                GameTooltip:SetOwner(self,"ANCHOR_TOP");
                GameTooltip:AddLine(self.hint);
                GameTooltip:Show();
            end
        end,
        hidePanelHint = function(self)
            if GameTooltip:IsOwned(self) then
                GameTooltip:Hide();
            end
        end,
        swapPanel = function(panel)
            if panel:IsVisible() then
                panel:Hide();
            else
                panel:Show();
            end
        end,
        createLine = function (settings)
            local panel = settings.parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                panel:SetPoint(settings.direction.x, settings.parent, settings.direction.y, settings.coords.x, settings.coords.y);
                panel:SetText(settings.content);
                panel:SetAlpha(0.85);
                panel:Show();
    
            return panel;
        end,
        createDefaultButton = function(settings)
            local function defaultButtonSettings(view)
                view:SetPoint(settings.direction.x, settings.parent, settings.direction.y, settings.coords.x, settings.coords.y);
                view:SetHeight((settings.size and settings.size.height) or 16);
                view:SetWidth((settings.size and settings.size.width) or 14);
                view:SetText(settings.content);
                view:RegisterForClicks("AnyUp");
            end
    
            local button = CreateFrame("Button", "defaultButton", settings.parent, "UIPanelButtonTemplate");
            defaultButtonSettings(button);
            return button;
        end,
        createDefaultFrame = function (settings)
            local defFrame = CreateFrame("Frame", "defaultFrame", settings.parent);
            defFrame:EnableMouse();
            defFrame:SetWidth(settings.size.width);
            defFrame:SetHeight(settings.size.height);
            defFrame:SetToplevel(true);
            defFrame:SetBackdropColor(0, 0, 0, 1);
            defFrame:SetFrameStrata("FULLSCREEN_DIALOG");
            defFrame:SetPoint(settings.aligment.x, settings.parent, settings.aligment.y, settings.point.x, settings.point.y);
            defFrame:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = true, tileSize = 32, edgeSize = 32,
                insets = { left = 12, right = 12, top = 12, bottom = 12 },
            });

            if (not(settings.title == nil)) then
                local defFrameTitle = gui.createLine({
                    parent = defFrame,
                    content = settings.title,
                    coords = { x = 0, y = - 25 },
                    direction = { x = "CENTER", y = "TOP" }
                });
            end;

            return defFrame;
        end,
        createCheckbox = function (settings)
            local checkBoxFrame = CreateFrame("Frame", "cb-frame", settings.parent);
            checkBoxFrame:EnableMouse();
            checkBoxFrame:SetWidth(settings.wrapper.size.width);
            checkBoxFrame:SetHeight(settings.wrapper.size.height);
            checkBoxFrame:SetPoint(settings.wrapper.aligment.x, settings.parent, settings.wrapper.aligment.y, settings.wrapper.point.x, -settings.wrapper.point.y);
            checkBoxFrame:SetToplevel(true);
            checkBoxFrame:SetBackdropColor(0, 0, 0, 1);
            checkBoxFrame:SetFrameStrata("FULLSCREEN_DIALOG");

            checkBoxFrame.Checkbox = CreateFrame("CheckButton", "checkbox", checkBoxFrame, "ChatConfigCheckButtonTemplate");
            checkBoxFrame.Checkbox:SetPoint(settings.checkbox.aligment.x, checkBoxFrame, settings.checkbox.aligment.y, settings.checkbox.point.x, settings.checkbox.point.y);
            checkBoxFrame.Checkbox:SetWidth(settings.checkbox.size.width);
            checkBoxFrame.Checkbox:SetHeight(settings.checkbox.size.height);
            
            checkBoxFrame.Content = checkBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            checkBoxFrame.Content:SetPoint("LEFT", checkBoxFrame.Checkbox, "LEFT", 36, 0);
            checkBoxFrame.Content:SetText(settings.content);

            return checkBoxFrame;
        end,
        createPlotView = function (settings)
            local plotView = CreateFrame("Button", "AddPlotPanel", settings.parent);
            plotView:EnableMouse();
            plotView:SetWidth(settings.size.width);
            plotView:SetHeight(settings.size.height);
            plotView:SetToplevel(true);
            plotView:SetBackdropColor(0, 0, 0, 1);
            plotView:SetFrameStrata("FULLSCREEN_DIALOG");
            plotView:SetPoint("TOPLEFT", settings.parent, "TOPLEFT", settings.point.x, -settings.point.y);
            plotView:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\plot-background.blp");
            plotView:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\plot-background.blp");

            plotView.Text = plotView:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            plotView.Text:SetPoint("LEFT", plotView, "LEFT", 16, 0);
            if (settings.id == playerInfo.settings.currentPlot) then
                plotView.Text:SetTextColor(0.901, 0.494, 0.133, 1);
            end;
            plotView.Text:SetText(settings.text);
            plotView:SetScript("OnClick", settings.clickHandler);

            return plotView;
        end,
    }
end;