local mainPanelViewGenerator = function(progress, armor, stats, flags, params, neededExpr)
    return function ()
        local createMainPanel = function()
            return gui.createDefaultFrame({
                parent = UIParent,
                size = { width = 80, height = 290 },
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
        local createButtons = function(mainPanel)
            mainPanel.Roll = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = 3 * STIKConstants.button.height + 10 },
                image = "dice_pve", highlight = true,
                hint = STIKConstants.texts.dices,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                    swapPanel = function()
                        gui.swapPanel(DicePanel)
                        if (StatPanel:IsVisible()) then gui.swapPanel(StatPanel); end;
                        if (ArmorPanel:IsVisible()) then gui.swapPanel(ArmorPanel); end;
                        if (SettingsPanel:IsVisible()) then gui.swapPanel(SettingsPanel); end;
                    end
                },
            });
            mainPanel.Stat = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = 2 * STIKConstants.button.height },
                image = "stat",
                highlight = true,
                hint = STIKConstants.texts.stats.stat,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                    swapPanel = function()
                        gui.swapPanel(StatPanel)
                        if (DicePanel:IsVisible()) then gui.swapPanel(DicePanel); end;
                        if (ArmorPanel:IsVisible()) then gui.swapPanel(ArmorPanel); end;
                        if (SettingsPanel:IsVisible()) then gui.swapPanel(SettingsPanel); end;
                    end
                },
            });
            mainPanel.Armor = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = STIKConstants.button.height - 10 },
                image = "armor",
                highlight = true,
                hint = STIKConstants.texts.stats.armor,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                    swapPanel = function()
                        gui.swapPanel(ArmorPanel)
                        if (DicePanel:IsVisible()) then gui.swapPanel(DicePanel); end;
                        if (StatPanel:IsVisible()) then gui.swapPanel(StatPanel); end;
                        if (SettingsPanel:IsVisible()) then gui.swapPanel(SettingsPanel); end;
                    end
                },
            });
            mainPanel.HP = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = -20 },
                image = "hp",
                highlight = false,
                hint = STIKConstants.texts.stats.hp,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                },
            });
            mainPanel.Shield = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = -STIKConstants.button.height - 30 },
                image = "shield",
                highlight = false,
                hint = STIKConstants.texts.stats.shield,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                },
            });
            mainPanel.Settings = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = -2 * STIKConstants.button.height - 40 },
                image = "settings",
                highlight = true,
                hint = STIKConstants.texts.settings.title,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                    swapPanel = function()
                        gui.swapPanel(SettingsPanel);
                        if (DicePanel:IsVisible()) then gui.swapPanel(DicePanel); end;
                        if (StatPanel:IsVisible()) then gui.swapPanel(StatPanel); end;
                        if (ArmorPanel:IsVisible()) then gui.swapPanel(ArmorPanel); end;
                    end;
                },
            });
            mainPanel.HP.Text = gui.createLine({
                parent = mainPanel.HP,
                content = params.health,
                coords = { x = 0, y = 0 },
                direction = { x = "CENTER", y = "CENTER" }
            });
            mainPanel.Shield.Text = gui.createLine({
                parent = mainPanel.Shield,
                content = params.shield,
                coords = { x = 0, y = 0 },
                direction = { x = "CENTER", y = "CENTER" }
            });
        end;

        local mainPanel = createMainPanel();
        appendScripts(mainPanel);
        createButtons(mainPanel);

        return mainPanel;
    end;
end;

local mainPanelShortViewGenerator = function(progress, armor, stats, flags, params, neededExpr)
    return function()
        local createMainPanel = function()
            return gui.createDefaultFrame({
                parent = UIParent,
                size = { width = 80, height = 80 },
                aligment = { x = "LEFT", y = "LEFT" },
                point = { x = -60, y = 80 },
            });
        end;

        local appendScripts = function(mainPanel)
            mainPanel:SetScript("OnEnter", function(self)
                self:SetPoint("LEFT", UIParent, "LEFT", -20, 80);
            end);
            mainPanel:SetScript("OnLeave", function(self)
                if (not MouseIsOver(self) and not SettingsPanel:IsVisible()) then
                    self:SetPoint("LEFT", UIParent, "LEFT", -60, 80);
                end; 
            end);
        end;

        local createButtons = function(mainPanel)
            mainPanel.Settings = STIKRegister.mainButton({
                parent = mainPanel,
                coords = { x = 0, y = 0 },
                image = "settings",
                highlight = true,
                hint = STIKConstants.texts.settings.title,
                functions = {
                    showHint = gui.showPanelHint,
                    hideHint = gui.hidePanelHint,
                    swapPanel = function() gui.swapPanel(SettingsPanel); end;
                },
            });
        end;

        local mainPanel = createMainPanel();
        appendScripts(mainPanel);
        createButtons(mainPanel);
        return mainPanel;
    end;
end;

local targetInfoViewGenerator = function(progress, armor, stats, flags, params, neededExpr)
    return function()
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
        return targetFrame;
    end;
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
            local statsToPanel = {
                { name = "str", coords = { x = -90, y = -50 } },
                { name = "ag", coords = { x = -90, y = -75 } },
                { name = "snp", coords = { x = -90, y = -100 } },
                { name = "mg", coords = { x = -90, y = -125 } },
                { name = "body", coords = { x = -90, y = -150 } },
                { name = "moral", coords = { x = -90, y = -175 } },
            };
        
            for index, stat in pairs(statsToPanel) do
                statPanel["stat_"..stat.name] = STIKRegister.stat({
                    parent = statPanel, stat = stat.name, coords = stat.coords
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end;
        end;

        local displayProgressInfo = function (statPanel)
            local lvlMargin = 0;
            if (progress.lvl < 10) then lvlMargin = 35; else lvlMargin = 24; end;

            statPanel.Level = gui.createLine({
                parent = statPanel,
                content = STIKConstants.texts.stats.level..": "..progress.lvl,
                coords = { x = lvlMargin, y = - 225 },
                direction = { x = "LEFT", y = "TOP" }
            });
            statPanel.Exp = gui.createLine({
                parent = statPanel,
                content = STIKConstants.texts.stats.expr..": "..progress.expr.."/"..neededExpr,
                coords = { x = -90, y = -225 },
                direction = { x = "LEFT", y = "TOP" }
            });
            statPanel.Avl = gui.createLine({
                parent = statPanel,
                content = STIKConstants.texts.stats.avaliable..": "..params.points,
                coords = { x = -90, y = -205 },
                direction = { x = "LEFT", y = "TOP" }
            });
        end;

        local statPanel = createStatPanel();
        displayStats(statPanel);
        displayProgressInfo(statPanel);
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
            local dices = {
                { info = { size = 6, penalty = 1.2 }, coords = { x = 36, y = 12 } },
                { info = { size = 12, penalty = 1.3 }, coords = { x = 90, y = 12 } },
                { info = { size = 20, penalty = 1.4 }, coords = { x = 144, y = 12 } },
                { info = { size = 100, penalty = 1.4 }, coords = { x = 198, y = 12} },
            };

            for index, dice in pairs(dices) do
                STIKRegister.roll({
                    parent = dicePanel.Menu,
                    coords = dice.coords,
                    dice = dice.info,
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end
        end;

        local registerDicesTypes = function (dicePanel)
            local stats = {
                { name = 'str', coords = { x = 0, y = 3 * STIKConstants.smallButton.height + 30 }, image = 'sword' },
                { name = 'ag', coords = { x = 0, y = 2 * STIKConstants.smallButton.height + 20 }, image = 'dagger' },
                { name = 'snp', coords = { x = 0, y = STIKConstants.smallButton.height + 10 }, image = 'bow' },
                { name = 'mg', coords = { x = 0, y = 0 }, image = 'magic' },
                { name = 'body', coords = { x = 0, y = -STIKConstants.smallButton.height - 10 }, image = 'strong' },
                { name = 'moral', coords = { x = 0, y = -2* STIKConstants.smallButton.height - 20 }, image = 'fear' },
                { name = 'luck', coords = { x = 0, y = -3 * STIKConstants.smallButton.height - 30 }, image = 'luck' },
            };

            for index, stat in pairs(stats) do
                STIKRegister.dice({
                    views = { parent = dicePanel, main = MainPanelSTIK, menu = dicePanel.Menu },
                    coords = stat.coords,
                    image = stat.image,
                    hint = STIKConstants.texts.stats[stat.name],
                    stat = stat.name,
                });
            end
        end;

        local dicePanel = createDicePanel();
        createDiceMenu(dicePanel);
        registerRolls(dicePanel);
        registerDicesTypes(dicePanel);
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
            local armors = {
                { class = 'cloth', coords = { x = 50, y = 12 } },
                { class = 'leather', coords = { x = 130, y = 12 } },
                { class = 'mail', coords = { x = 210, y = 12 } },
                { class = 'plate', coords = { x = 290, y = 12 } },
                { class = 'nothing', coords = { x = 370, y = 12 } },
            };

            for index, armor in pairs(armors) do
                STIKRegister.armorType({
                    parent = armorPanel.Menu,
                    armorType = armor.class,
                    coords = armor.coords,
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end
        end;

        local registerArmorSlots = function (armorPanel)
            local slots = {
                {
                    name = 'head',
                    line = { coords = { x = -70, y = -60 }, direction = { x = "LEFT", y = "TOP" } },
                    button = { coords = { x = 70, y = -60 }, direction = { x = "RIGHT", y = "TOP" } }
                },
                {
                    name = 'body',
                    line = { coords = { x = -70, y = -90 }, direction = { x = "LEFT", y = "TOP" } },
                    button = { coords = { x = 70, y = -90 }, direction = { x = "RIGHT", y = "TOP" } }
                },
                {
                    name = 'legs',
                    line = { coords = { x = -70, y = -120 }, direction = { x = "LEFT", y = "TOP" } },
                    button = { coords = { x = 70, y = -120 }, direction = { x = "RIGHT", y = "TOP" } }
                }
            }

            for index, _slot in pairs(slots) do
                STIKRegister.armor({
                    views = { parent = armorPanel, armorMenu = armorPanel.Menu },
                    slot = _slot.name,
                    line = _slot.line,
                    button = _slot.button,
                }, STIKSharedFunctions.getPlayerContext(playerInfo));
            end
            
        end;

        local armorPanel = createArmorPanel();
        createArmorMenu(armorPanel);
        registerArmorTypes(armorPanel);
        registerArmorSlots(armorPanel);
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
            local checkboxTitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            checkboxTitle:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 20, -56);
            checkboxTitle:SetText(STIKConstants.texts.settings.parameters);

            settingsPanel.handlePlotInvites = gui.createCheckbox({
                parent = settingsPanel,
                content = STIKConstants.texts.settings.getPlotInv,
                wrapper = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 16, y = 76 },
                    size = { width = 290, height = 32 },
                },
                checkbox = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 0, y = 0 },
                    size = { width = 32, height = 32 },
                },
            });
            settingsPanel.handlePlotInvites.Checkbox:SetChecked(playerInfo.settings.getPlotInvites);
            settingsPanel.handlePlotInvites.Checkbox:SetScript("OnClick", function(self)
                playerInfo.settings.getPlotInvites = self:GetChecked();
            end);

            settingsPanel.handleEventInvites = gui.createCheckbox({
                parent = settingsPanel,
                content = STIKConstants.texts.settings.getEventInv,
                wrapper = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 16, y = 114 },
                    size = { width = 290, height = 32 },
                },
                checkbox = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 0, y = 0 },
                    size = { width = 32, height = 32 },
                },
            });
            settingsPanel.handleEventInvites.Checkbox:SetChecked(playerInfo.settings.getEventInvites);
            settingsPanel.handleEventInvites.Checkbox:SetScript("OnClick", function(self)
                playerInfo.settings.getEventInvites = self:GetChecked();
            end);

            settingsPanel.showRollInfo = gui.createCheckbox({
                parent = settingsPanel,
                content = STIKConstants.texts.settings.showRollInfo,
                wrapper = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 16, y = 154 },
                    size = { width = 290, height = 32 },
                },
                checkbox = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 0, y = 0 },
                    size = { width = 32, height = 32 },
                },
            });
            settingsPanel.showRollInfo.Checkbox:SetChecked(playerInfo.settings.showRollInfo);
            settingsPanel.showRollInfo.Checkbox:SetScript("OnClick", function(self)
                playerInfo.settings.showRollInfo = self:GetChecked();
            end);

            settingsPanel.showDeclineMessages = gui.createCheckbox({
                parent = settingsPanel,
                content = STIKConstants.texts.settings.showDeclineMessages,
                wrapper = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 16, y = 194 },
                    size = { width = 290, height = 32 },
                },
                checkbox = {
                    aligment = { x = "TOPLEFT", y = "TOPLEFT" },
                    point = { x = 0, y = 0 },
                    size = { width = 32, height = 32 },
                },
            });
            settingsPanel.showDeclineMessages.Checkbox:SetChecked(playerInfo.settings.showDeclineMessages);
            settingsPanel.showDeclineMessages.Checkbox:SetScript("OnClick", function(self)
                playerInfo.settings.showDeclineMessages = self:GetChecked();
            end);
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
                    clickHandler = function()
                        settingsPanel.createSinglePlot(plotID);
                    end,
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
                            clickHandler = function()
                                settingsPanel.createSinglePlot(plotID);
                            end,
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
        mainPanelShort = mainPanelShortViewGenerator(progress, armor, stats, flags, params, neededExpr),
        targetInfo = targetInfoViewGenerator(progress, armor, stats, flags, params, neededExpr),
        statPanel = statPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        dicePanel = dicePanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        armorPanel = armorPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
        settingsPanel = settingsPanelViewGenerator(progress, armor, stats, flags, params, neededExpr),
    };
end;