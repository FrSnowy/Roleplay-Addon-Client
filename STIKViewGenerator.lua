local mainPanelViewGenerator = function(progress, armor, stats, flags, params, neededExpr)
    local generator = function (isShort)
        local createMainPanel = function()
            local panelHeight = 290;
            if (isShort) then panelHeight = 80; end;
            return gui.createDefaultFrame({
                parent = UIParent,
                size = { width = 80, height = panelHeight },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = -60, y = 80 },
            });
        end;

        local appendScripts = function(mainPanel)
            mainPanel:SetScript("OnEnter", function(self)
                self:SetPoint("LEFT", UIParent, "LEFT", -20, 80);
            end);
            mainPanel:SetScript("OnLeave", function(self)
                local isAnyPanelVisible = StatPanel:IsVisible() or DicePanel:IsVisible() or ArmorPanel:IsVisible() or SettingsPanel:IsVisible();
                if (not MouseIsOver(self) and not isAnyPanelVisible) then
                    self:SetPoint("LEFT", UIParent, "LEFT", -60, 80);
                end; 
            end);
        end;

        local createButtons = function(mainPanel, isShort)
            local mainPanelButtons = STIKSortTable(STIKConstants.mainPanelButtons);

            for i = 1, #mainPanelButtons do
                local panelButton = mainPanelButtons[i];
                if ((isShort and panelButton.name == 'Settings') or not isShort) then
                    local panelPosition = - i * (STIKConstants.button.height + 8);
                    if (isShort) then panelPosition = -40; end;

                    mainPanel[panelButton.name] = STIKRegister.mainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = panelPosition },
                        image = panelButton.image,
                        highlight = panelButton.highlight,
                        hint = panelButton.hint,
                        functions = {
                            showHint = gui.showPanelHint,
                            hideHint = gui.hidePanelHint,
                            swapPanel = function()
                                if (panelButton.showPanel) then
                                    local wasVisible = STIKPanelLinks[panelButton.name]:IsVisible();
                                    if (DicePanel and DicePanel:IsVisible()) then gui.swapPanel(DicePanel); end;
                                    if (StatPanel and StatPanel:IsVisible()) then gui.swapPanel(StatPanel); end;
                                    if (ArmorPanel and ArmorPanel:IsVisible()) then gui.swapPanel(ArmorPanel); end;
                                    if (SettingsPanel and SettingsPanel:IsVisible()) then gui.swapPanel(SettingsPanel); end;

                                    if (not wasVisible) then gui.swapPanel(STIKPanelLinks[panelButton.name]); end;
                                end;
                            end
                        },
                    });

                    if (panelButton.displayParameter) then
                        mainPanel[panelButton.name].Text = gui.createLine({
                            parent = mainPanel[panelButton.name],
                            content = params[panelButton.displayParameter],
                            coords = { x = 0, y = 0 },
                            direction = { x = "CENTER", y = "CENTER" }
                        });
                    end;
                end;
            end;
        end;

        local mainPanel = createMainPanel();
        appendScripts(mainPanel);
        createButtons(mainPanel, isShort);
        STIKPanelLinks.MainPanel = mainPanel;        

        return mainPanel;
    end;

    return generator;
end;

local targetInfoViewGenerator = function(progress, armor, stats, flags, params, neededExpr)
    local generator = function()
        local createTargetFrame = function ()
            return gui.createDefaultFrame({
                parent = TargetFrame,
                size = { width = TargetFrameHealthBar:GetWidth(), height = 32 },
                aligment = { x = "BOTTOMLEFT", y = "BOTTOMLEFT" },
                point = { x = 0, y = 0 },
            });
        end;

        local createAttackableStatus = function(targetFrame)
            targetFrame.AttackablePanel = CreateFrame("Button", "targetInfoAttackable", targetFrame);
            targetFrame.AttackablePanel:EnableMouse(); 
            targetFrame.AttackablePanel:SetWidth(STIKConstants.smallestButton.width);
            targetFrame.AttackablePanel:SetHeight(STIKConstants.smallestButton.height);
            targetFrame.AttackablePanel:SetPoint("RIGHT", targetFrame, "RIGHT", 0, 0);
            targetFrame.AttackablePanel:SetScript("OnEnter", gui.showPanelHint);
            targetFrame.AttackablePanel:SetScript("OnLeave", gui.hidePanelHint);
        end;

        local targetFrame = createTargetFrame();
        targetFrame:SetBackdrop(nil);
        targetFrame:Hide();
        createAttackableStatus(targetFrame);
        STIKPanelLinks.TargetFrame = targetFrame;
        return targetFrame;
    end;

    return generator;
end;

local statPanelViewGenerator = function(progress, armor, stats, flags, params, neededExpr)
    local generator = function(mainPanel)
        local createStatPanel = function ()
            local statPanel = gui.createDefaultFrame({
                parent = mainPanel,
                title = STIKConstants.texts.stats.stat,
                size = { width = 240, height = 260 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = 70, y = 0 }
            });
            statPanel:Hide();
            return statPanel;
        end;

        local displayStats = function (statPanel)
            local statsPanelCharsElements = STIKSortTable(STIKConstants.statsPanelElements.chars);
            for i = 1, #statsPanelCharsElements do
                local name = statsPanelCharsElements[i].name;
                statPanel['stat_'..name] = STIKRegister.stat({
                    parent = statPanel, stat = name, coords = { x = -90, y = -25 - 25 * i }
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end;
        end;

        local displayProgressInfo = function (statPanel)
            local lvlMargin = 24;
            if (progress.lvl < 10) then lvlMargin = 35; end;

            local statPanelMetaElements = STIKSortTable(STIKConstants.statsPanelElements.meta);
            for i = 1, #statPanelMetaElements do
                local metaElement = statPanelMetaElements[i];
                local metaCoords = {
                    x = metaElement.coords.x,
                    y = metaElement.coords.y,
                };

                if (metaCoords.x == 'BY_MARGIN') then metaCoords.x = lvlMargin; end;
                statPanel[metaElement.name] = gui.createLine({
                    parent = statPanel,
                    content = metaElement.getContent(progress, params, neededExpr),
                    coords = metaCoords,
                    direction = { x = "LEFT", y = "TOP" }
                });
            end;
        end;

        local statPanel = createStatPanel();
        displayStats(statPanel);
        displayProgressInfo(statPanel);
        STIKPanelLinks.Stat = statPanel;
        return statPanel;
    end;

    return generator;
end;

local dicePanelViewGenerator = function (progress, armor, stats, flags, params, neededExpr)
    local generator = function(mainPanel)
        local createDicePanel = function ()
            local dicePanel = gui.createDefaultFrame({
                parent = mainPanel,
                title = STIKConstants.texts.dices,
                size = { width = 80, height = 320 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = 70, y = 0 }
            });
            dicePanel:Hide();
            return dicePanel;
        end;

        local createDiceMenu = function (dicePanel)
            dicePanel.Menu = gui.createDefaultFrame({
                parent = dicePanel,
                size = { width = 236, height = 60 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = 0, y = 0 },
            });

            dicePanel.Menu:Hide();
        end;

        local registerRolls = function (dicePanel)
            local rollSizesElements = STIKSortTable(STIKConstants.rollSizes);
            for i = 1, #rollSizesElements do
                local rollInfo = rollSizesElements[i];
                STIKRegister.roll({
                    parent = dicePanel.Menu,
                    coords = { x = 36 + 54 * (i - 1), y = 12 },
                    dice = rollInfo,
                }, STIKSharedFunctions.getPlayerContext(playerInfo))
            end;
        end;

        local registerDicesTypes = function (dicePanel)            
            local dicePanelElements = STIKSortTable(STIKConstants.dicePanelElements);
            for i = 1, #dicePanelElements do
                local diceType = dicePanelElements[i];
                STIKRegister.dice({
                    views = { parent = dicePanel, main = MainPanelSTIK, menu = dicePanel.Menu },
                    coords = { x = 0, y = -i * (STIKConstants.smallButton.height + 10) - 15},
                    image = diceType.image,
                    hint = STIKConstants.texts.stats[diceType.name],
                    stat = diceType.name,
                });
            end;
        end;

        local dicePanel = createDicePanel();
        createDiceMenu(dicePanel);
        registerRolls(dicePanel);
        registerDicesTypes(dicePanel);
        STIKPanelLinks.Roll = dicePanel;
        return dicePanel;
    end;

    return generator;
end;

local armorPanelViewGenerator = function (progress, armor, stats, flags, params, neededExpr)
    local generator = function(mainPanel)
        local createArmorPanel = function ()
            local armorPanel = gui.createDefaultFrame({
                parent = mainPanel,
                title = STIKConstants.texts.stats.armor,
                size = { width = 180, height = 235 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = 70, y = 0 }
            });

            armorPanel:Hide();
            return armorPanel;
        end;

        local createArmorMenu = function (armorPanel)
            armorPanel.Menu = gui.createDefaultFrame({
                parent = armorPanel,
                size = { width = 430, height = 60 },
                aligment = { x = "LEFT", y = "TOP" },
                point = { x = 70, y = -60 },
            });

            armorPanel.Menu:Hide();
            armorPanel.Menu.slot = nil;
        end;

        local registerArmorTypes = function (armorPanel)
            local armorVariations = STIKSortTable(STIKConstants.armorTypes);
            for i = 1, #armorVariations do
                local armor = armorVariations[i];
                STIKRegister.armorType({
                    parent = armorPanel.Menu,
                    armorType = armor.name,
                    coords = { x = 50 + 80 * (i - 1), y = 12 },
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end;
        end;

        local registerArmorSlots = function (armorPanel)
            local armorSlots = STIKSortTable(STIKConstants.armorSlots);
            for i = 1, #armorSlots do
                local armorSlot = armorSlots[i];
                local lineConfig = {
                    coords = { x = -70, y = -60 - 30 * (i - 1) },
                    direction = { x = "LEFT", y = "TOP" },
                };
                local buttonConfig = {
                    coords = { x = 70, y = -60 - 30 * (i - 1) },
                    direction = { x = "RIGHT", y = "TOP" },
                };

                STIKRegister.armor({
                    views = { parent = armorPanel, armorMenu = armorPanel.Menu },
                    slot = armorSlot.name,
                    line = lineConfig,
                    button = buttonConfig,
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end;            
        end;

        local armorPanel = createArmorPanel();
        createArmorMenu(armorPanel);
        registerArmorTypes(armorPanel);
        registerArmorSlots(armorPanel);
        STIKPanelLinks.Armor = armorPanel;
        return armorPanel;
    end;

    return generator;
end;

local settingsPanelViewGenerator = function (progress, armor, stats, flags, params, neededExpr)
    local generator = function (mainPanel)
        local createSettingsPanel = function()
            local settingsPanel = gui.createDefaultFrame({
                parent = mainPanel,
                title = STIKConstants.texts.settings.title,
                size = { width = 580, height = 290 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = 70, y = 0 }
            });

            settingsPanel:Hide();

            return settingsPanel;
        end;

        local createCheckboxPart = function(settingsPanel)
            local cBoxesInfo = STIKConstants.settingsPanelElements.cBoxes;
            local cBoxes = STIKSortTable(cBoxesInfo.boxes);

            local checkboxTitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            checkboxTitle:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 20, -56);
            checkboxTitle:SetText(cBoxesInfo.title);

            for i = 1, #cBoxes do
                local checkBox = cBoxes[i];

                settingsPanel[checkBox.name] = gui.createCheckbox({
                    parent = settingsPanel,
                    content = checkBox.content,
                    wrapper = {
                        aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                        point = { x = 16, y = 76 + 38 * (i - 1) },
                        size = { width = 290, height = 32 },
                    },
                    checkbox = {
                        aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                        point = { x = 0, y = 0 },
                        size = { width = 32, height = 32 },
                    },
                });

                settingsPanel[checkBox.name].Checkbox:SetChecked(playerInfo.settings[checkBox.name]);
                settingsPanel[checkBox.name].Checkbox:SetScript("OnClick", function(self)
                    playerInfo.settings[checkBox.name] = self:GetChecked();
                end);
            end;
        end;

        local createPlotsPart = function(settingsPanel)
            if (not(settingsPanel.Title)) then
                settingsPanel.Title = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                settingsPanel.Title:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 290, -56);
                if (playerInfo.settings.isEventStarted) then
                    settingsPanel.Title:SetText(STIKConstants.texts.settings.activeEventTitle);
                else
                    settingsPanel.Title:SetText(STIKConstants.texts.settings.parts);
                end;
            end;

            settingsPanel.Plots = settingsPanel.Plots or { };
            settingsPanel.plotForScreen = 5;
            settingsPanel.plotsOffset = settingsPanel.plotsOffset or 0;
            if (playerInfo.settings.isEventStarted) then
                local plotID = playerInfo.settings.currentPlot;
                local plot = playerInfo.savedPlots[plotID];
                local plotView = gui.createPlotView({
                    id = plotID,
                    parent = settingsPanel,
                    size = { width = 240, height = 24 },
                    point = { x = 290, y = 80 },
                    text = plot.name;
                    clickHandler = function() settingsPanel.createSinglePlot(plotID);  end,
                });
                plotView.Text:SetTextColor(0.901, 0.494, 0.133, 1);
            else
                if (#settingsPanel.Plots > 0) then
                    for index, plotView in pairs(settingsPanel.Plots) do
                        plotView:Hide();
                        settingsPanel.Plots[index] = nil;
                    end;
                end;

                local plotIndex = 0;
                for plotID, plot in pairs(playerInfo.savedPlots) do
                    if (not(plotIndex < settingsPanel.plotsOffset)) then
                        local plotView = gui.createPlotView({
                            id = plotID,
                            parent = settingsPanel,
                            size = { width = 240, height = 24 },
                            point = { x = 290, y = 80 + 32 * (plotIndex - settingsPanel.plotsOffset) },
                            text = plot.name;
                            clickHandler = function() settingsPanel.createSinglePlot(plotID); end,
                        });
                        table.insert(settingsPanel.Plots, plotView);
                    end;
                    plotIndex = plotIndex + 1;
                    if (plotIndex == settingsPanel.plotForScreen + settingsPanel.plotsOffset) then break end;
                end;
            end;
        end;

        local createScrollBar = function(settingsPanel, plotCount)
            local scrollSize = plotCount - settingsPanel.plotForScreen;
            settingsPanel.Scrollbar = CreateFrame("Slider", nil, settingsPanel, "UIPanelScrollBarTemplate")
            settingsPanel.Scrollbar:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 540, -90);
            settingsPanel.Scrollbar:SetSize(30, 128);
            settingsPanel.Scrollbar:SetMinMaxValues(0, scrollSize);
            settingsPanel.Scrollbar:SetValueStep(1);
            settingsPanel.Scrollbar:SetValue(settingsPanel.plotsOffset);

            settingsPanel.Scrollbar:SetScript("OnValueChanged", function(self, value)
                settingsPanel.plotsOffset = value;
                createPlotsPart(settingsPanel);
            end);
        end;

        local settingsPanel = createSettingsPanel();
        createCheckboxPart(settingsPanel);
        createPlotsPart(settingsPanel);

        local plotCount = 0;
        for plotID, plot in pairs(playerInfo.savedPlots) do plotCount = plotCount + 1; end;

        if (plotCount > settingsPanel.plotForScreen) then
            createScrollBar(settingsPanel, plotCount);
        end;

        settingsPanel.createSinglePlot = function(plotID)
            local currentPlot = playerInfo.savedPlots[plotID];
            if (settingsPanel.SinglePlot) then settingsPanel.SinglePlot:Hide();  end;
            settingsPanel.SinglePlot = gui.createDefaultFrame({
                parent = settingsPanel,
                title = STIKConstants.texts.settings.plot,
                size = { width = 290, height = 290 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = 570, y = 0 }
            });

            settingsPanel.SinglePlot.Title = settingsPanel.SinglePlot:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            settingsPanel.SinglePlot.Title:SetPoint("CENTER", settingsPanel.SinglePlot, "TOP", 0, -60);
            settingsPanel.SinglePlot.Title:SetText('"'..currentPlot.name..'"');
            settingsPanel.SinglePlot.Title:SetTextColor(0.901, 0.494, 0.133, 1);
            settingsPanel.SinglePlot.Title:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE, MONOCHROME");

            settingsPanel.SinglePlot.Content = settingsPanel.SinglePlot:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            settingsPanel.SinglePlot.Content:SetPoint("TOPLEFT", settingsPanel.SinglePlot, "TOPLEFT", 24, -90);
            settingsPanel.SinglePlot.Content:SetText(currentPlot.content);
            settingsPanel.SinglePlot.Content:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE, MONOCHROME");
            settingsPanel.SinglePlot.Content:SetWidth(240);

            settingsPanel.SinglePlot.CloseButton = gui.createDefaultButton({
                parent = settingsPanel.SinglePlot,
                direction = { x = "TOPRIGHT", y = "TOPRIGHT" },
                coords = { x = -16, y = -16 },
                size = { width = 24, height = 24 },
                content = 'x',
            });

            settingsPanel.SinglePlot.CloseButton:SetScript("OnClick", function()
                settingsPanel.SinglePlot:Hide();
                settingsPanel.SinglePlot = nil;
            end);

            if (playerInfo.settings.isEventStarted) then
                settingsPanel.SinglePlot.UnactivateButton = gui.createDefaultButton({
                    parent = settingsPanel.SinglePlot,
                    direction = { x = "BOTTOMRIGHT", y = "BOTTOMRIGHT" },
                    coords = { x = -24, y = 24 },
                    size = { width = 204, height = 32 },
                    content = STIKConstants.texts.settings.unactivateButton,
                });

                settingsPanel.SinglePlot.UnactivateButton:SetScript("OnClick", function()
                    SendAddonMessage("STIK_PLAYER_ANSWER", "leave_event&"..UnitName("player"), "WHISPER", playerInfo.settings.currentMaster);
                    playerInfo.settings.currentPlot = nil;
                    playerInfo.settings.currentMaster = nil;
                    playerInfo.settings.isEventStarted = false;
                    if (MainPanelSTIK) then MainPanelSTIK:Hide(); end;
                    if (targetInfoFrame) then targetInfoFrame:Hide(); end;
                    if (StatPanel) then StatPanel:Hide(); end;
                    if (DicePanel) then DicePanel:Hide(); end;
                    if (ArmorPanel) then ArmorPanel:Hide(); end;
                    onAddonReady();
                end);
            else
                settingsPanel.SinglePlot.DeleteButton = gui.createDefaultButton({
                    parent = settingsPanel.SinglePlot,
                    direction = { x = "BOTTOMLEFT", y = "BOTTOMLEFT" },
                    coords = { x = 24, y = 24 },
                    size = { width = 96, height = 32 },
                    content = STIKConstants.texts.settings.removePlot,
                });

                settingsPanel.SinglePlot.DeleteButton:SetScript("OnClick", function()
                    playerInfo.savedPlots[plotID] = nil;
                    playerInfo[plotID] = nil;
                    settingsPanel.SinglePlot:Hide();
                    settingsPanel.SinglePlot = nil;
                    settingsPanel.RefreshPlotList();
                end);

                local selectBtnContent = nil;
                if (plotID == playerInfo.settings.currentPlot) then selectBtnContent = STIKConstants.texts.settings.unselectPlot;
                else selectBtnContent = STIKConstants.texts.settings.selectPlot;
                end;

                settingsPanel.SinglePlot.SelectButton = gui.createDefaultButton({
                    parent = settingsPanel.SinglePlot,
                    direction = { x = "BOTTOMRIGHT", y = "BOTTOMRIGHT" },
                    coords = { x = -24, y = 24 },
                    size = { width = 124, height = 32 },
                    content = selectBtnContent,
                });

                settingsPanel.SinglePlot.SelectButton:SetScript("OnClick", function()
                    if (plotID == playerInfo.settings.currentPlot) then
                        playerInfo.settings.currentPlot = nil;
                    else
                        playerInfo.settings.currentPlot = plotID;
                    end;
                    settingsPanel.RefreshPlotList();
                    if (MainPanelSTIK) then MainPanelSTIK:Hide(); end;
                    if (targetInfoFrame) then targetInfoFrame:Hide(); end;
                    if (StatPanel) then StatPanel:Hide(); end;
                    if (DicePanel) then DicePanel:Hide(); end;
                    if (ArmorPanel) then ArmorPanel:Hide(); end;
                    onAddonReady();
                end);
            end;                    
        end;

        settingsPanel.RefreshPlotList = function()
            local plotCount = 0;
            for plotID, plot in pairs(playerInfo.savedPlots) do plotCount = plotCount + 1; end;
            
            createPlotsPart(SettingsPanel);
            if (plotCount > SettingsPanel.plotForScreen) then
                createScrollBar(SettingsPanel, plotCount);
            else
                if (SettingsPanel.Scrollbar) then SettingsPanel.Scrollbar:Hide(); end;
            end;
        end;

        
        STIKPanelLinks.Settings = settingsPanel;

        return settingsPanel;
    end;

    return generator;
end;

STIKViewGenerator = function ()
    local progress = nil;
    local armor = nil;
    local stats = nil;
    local flags = nil;
    local params = nil;
    local neededExpr = nil;

    local playerContext = STIKSharedFunctions.getPlayerContext(playerInfo);

    STIKPanelLinks = { };

    if (playerContext) then
        progress = playerContext.progress;
        armor = playerContext.armor;
        stats = playerContext.stats;
        flags = playerContext.flags;
        params = playerContext.params;
        neededExpr = progress.lvl * 1000;
    end;
    
    return {
        mainPanel = mainPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        targetInfo = targetInfoViewGenerator(progress, armor, stats, flags, params, neededExpr),
        statPanel = statPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        dicePanel = dicePanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        armorPanel = armorPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        settingsPanel = settingsPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
    };
end;