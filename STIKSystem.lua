function onAddonReady()
    gui = SnowGUI();

    --- Генератор вьюшек ---
    local viewGenerator = function (playerContext)
        local progress = nil;
        local armor = nil;
        local stats = nil;
        local flags = nil;
        local params = nil;
        local neededExpr = nil;

        if (playerContext) then
            progress = playerContext.progress;
            armor = playerContext.armor;
            stats = playerContext.stats;
            flags = playerContext.flags;
            params = playerContext.params;
            neededExpr = progress.lvl * 1000;
        end;
        
        return {
            mainPanel = function ()
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
            end,
            mainPanelShort = function ()
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
            end,
            targetInfo = function()
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
            end,
            statPanel = function (mainPanel)
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
                        }, playerContext);
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
            end,
            dicePanel = function (mainPanel)
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
                        }, playerContext);
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
            end,
            armorPanel = function(mainPanel)
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
                        }, playerContext);
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
                        }, playerContext);
                    end
                    
                end;

                local armorPanel = createArmorPanel();
                createArmorMenu(armorPanel);
                registerArmorTypes(armorPanel);
                registerArmorSlots(armorPanel);
                return armorPanel;
            end,
            settingsPanel = function(mainPanel)
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
            end,
        };
    end;

    local preloadChecks = function(context)
        if (context == nil) then return 'NO_PLOT_SELECTED' end;

        if (not(STIKSharedFunctions.isHashOK(context))) then
            message(STIKConstants.texts.err.hashIsWrong);
            context = {
                hash = 2034843419,
                stats = { str = 0, moral = 0, mg = 0, ag = 0, snp = 0, body = 0 },
                progress = { expr = 0, lvl = 1 },
                flags = { isInBattle = 0 },
                armor = { legs = "nothing", head = "nothing", body = "nothing" },
                params = { shield = 0, points = 100, health = 3 },
            }

            context.params.points = STIKSharedFunctions.calculatePoints(context.stats, context.progress);
            context.params.health = STIKSharedFunctions.calculateHealth(context.stats);
            playerInfo[playerInfo.settings.currentPlot] = context;
        end;

        return 'OK';
    end;

    playerInfo = playerInfo or {
        savedPlots = { },
        settings = {
            currentPlot = nil,
            getPlotInvites = true,
            getEventInvites = true,
            showDeclineMessages = true,
            showRollInfo = false,
        },
    };

    currentContext = STIKSharedFunctions.getPlayerContext(playerInfo);
    local addonStatus = preloadChecks(currentContext);
    local generator = viewGenerator(currentContext);

    local addonStatusConnector = {
        OK = function()
            --- Основная панель ---
            MainPanelSTIK = generator.mainPanel();
            --- Панель цели ---
            targetInfoFrame = generator.targetInfo();
            --- Статы ---
            StatPanel = generator.statPanel(MainPanelSTIK);
            --- Панель кубов ---
            DicePanel = generator.dicePanel(MainPanelSTIK);
            --- Панель брони ---
            ArmorPanel = generator.armorPanel(MainPanelSTIK);
            --- Панель настроек ---
            SettingsPanel = generator.settingsPanel(MainPanelSTIK);
        end,
        NO_PLOT_SELECTED = function()
            --- Основная панель (только настройки) ---
            MainPanelSTIK = generator.mainPanelShort();
            --- Панель настроек ---
            SettingsPanel = generator.settingsPanel(MainPanelSTIK);
        end,
    }

    addonStatusConnector[addonStatus]();

end;

function onDMSaySomething(prefix, msg, tp, sender)
    if (not(prefix == 'STIK_SYSTEM')) then return end;
    local COMMAND, VALUE, PLOT = strsplit('&', msg);

    if (not(COMMAND == 'invite_to_plot') and not(COMMAND == 'invite_to_evt') and not(COMMAND == 'event_stop')) then
        if (not(playerInfo.settings.isEventStarted)) then
            SendAddonMessage("STIK_PLAYER_ANSWER", "not_on_event", "WHISPER", sender);
            return;
        end;

        if (not(playerInfo.settings.currentPlot == PLOT)) then
            SendAddonMessage("STIK_PLAYER_ANSWER", "not_on_plot", "WHISPER", sender);
        end;
    end;

    local currentPlot = nil;
    if (PLOT) then currentPlot = playerInfo[PLOT]; end;

    local commandHelpers = {
        clearTalantes = function (plot)
            plot.stats.str = 0;
            plot.stats.ag = 0;
            plot.stats.snp = 0;
            plot.stats.mg = 0;
            plot.stats.body = 0;
            plot.stats.moral = 0;
            plot.params.points = STIKSharedFunctions.calculatePoints(plot.stats, plot.progress);
            print("СИСТЕМА: Очки талантов сброшены!");
        end,
        updateStats = function (plot)
            StatPanel.stat_str:SetText(STIKConstants.texts.stats.str..": "..plot.stats.str);
            StatPanel.stat_ag:SetText(STIKConstants.texts.stats.ag..": "..plot.stats.ag);
            StatPanel.stat_snp:SetText(STIKConstants.texts.stats.snp..": "..plot.stats.snp);
            StatPanel.stat_mg:SetText(STIKConstants.texts.stats.mg..": "..plot.stats.mg);
            StatPanel.stat_body:SetText(STIKConstants.texts.stats.body..": "..plot.stats.body);
            StatPanel.stat_moral:SetText(STIKConstants.texts.stats.moral..": "..plot.stats.moral);
            StatPanel.Level:SetText(STIKConstants.texts.stats.level..": "..plot.progress.lvl);
            StatPanel.Exp:SetText(STIKConstants.texts.stats.expr..": "..plot.progress.expr.."/"..plot.progress.lvl * 1000);
            StatPanel.Avl:SetText(STIKConstants.texts.stats.avaliable..": "..STIKSharedFunctions.calculatePoints(plot.stats, plot.progress));

            plot.params.health = STIKSharedFunctions.calculateHealth(plot.stats);
            MainPanelSTIK.HP.Text:SetText(plot.params.health);
        end,
        getMaxHP = function(plot)
            return 3 + math.floor(plot.stats.body / 20)
        end,
    };

    local commandConnector = {
        give_exp = function(experience)
            local expr = tonumber(experience, 10);
            local progress = currentPlot.progress;
            local params = currentPlot.params;
            local stats = currentPlot.stats;

            progress.expr = progress.expr + expr;
            if (expr > 0) then
                print("СИСТЕМА: Вы получили "..expr.." exp");
                if (progress.expr >= progress.lvl * 1000) then
                    progress.lvl = progress.lvl + 1;
                    progress.expr = progress.expr - ((progress.lvl - 1) * 1000);
                    params.points = STIKSharedFunctions.calculatePoints(currentPlot.stats, currentPlot.progress);
                    print("СИСТЕМА: Ваш уровень был повышен!");
                end;
            else
                print("СИСТЕМА: Вы потеряли "..math.abs(expr).." exp");
                if (progress.expr < 0) then
                    if (progress.lvl > 1) then
                        local diff = math.abs(progress.expr);
                        progress.lvl = currentPlot.progress.lvl - 1;
                        progress.expr = (progress.lvl * 1000) - diff;
                        print("СИСТЕМА: Ваш уровень был понижен!");
                        commandHelpers.clearTalantes(currentPlot);
                    else progress.expr = 0;
                    end;
                end;
            end;
            commandHelpers.updateStats(currentPlot);
        end,
        set_level = function(level)
            local level = tonumber(level, 10);
            local progress = currentPlot.progress;
            local params = currentPlot.params;
            local stats = currentPlot.stats;
            local shouldClearParams = level < progress.lvl;
            progress.lvl = level;
            params.points = STIKSharedFunctions.calculatePoints(stats, progress);
            print('СИСТЕМА: Уровень установлен на '..progress.lvl);
            progress.expr = 0;
            if shouldClearParams then commandHelpers.clearTalantes(currentPlot) end;
            commandHelpers.updateStats(currentPlot);
        end,
        get_info = function()
            local stats = currentPlot.stats;
            local progress = currentPlot.progress;
            local params = currentPlot.params;
            local flags = currentPlot.flags;
            SendChatMessage('Версия: 2.0.1', "WHISPER", nil, sender);
            SendChatMessage("STR:"..stats.str.." AG:"..stats.ag.." SNP:"..stats.snp.." MG:"..stats.mg.." BODY:"..stats.body.." MRL:"..stats.moral, "WHISPER", nil, sender);
            SendChatMessage("LVL:"..progress.lvl.." EXPR:"..progress.expr.."/"..(progress.lvl * 1000).." PNT:"..params.points, "WHISPER", nil, sender);
            SendChatMessage("HP:"..params.health.." SHLD:"..params.shield, "WHISPER", nil, sender);
            if (flags.isInBattle == 0) then
                SendChatMessage("Не в бою", "WHISPER", nil, sender);
            else
                SendChatMessage("В бою", "WHISPER", nil, sender);
            end;
        end,
        mod_hp = function(health)
            local params = currentPlot.params;
            local stats = currentPlot.stats;
            local health = tonumber(health, 10);

            if (params.health + health <= commandHelpers.getMaxHP(currentPlot)) then
                currentPlot.params.health = currentPlot.params.health + health;
                if (currentPlot.params.health < 0) then currentPlot.params.health = 0; end;
                if (health < 0) then print('Вы потеряли '..math.abs(health)..' ХП')
                else print('Вы получили '..math.abs(health)..' ХП')
                end;
                if (currentPlot.params.health == 0) then 
                    print('Вы не можете продолжать бой');
                    SendChatMessage('(( Выведен из боя ))');
                end;
            else
                print ('Вам пытались выдать ' ..math.abs(health).. ' ХП, но ваше максимальное значение - ' ..commandHelpers.getMaxHP(currentPlot));
                print ('Значение здоровья было установлено в макс., лишние ХП - уничтожены');
                params.health = STIKSharedFunctions.calculateHealth(stats);
            end;
            MainPanelSTIK.HP.Text:SetText(params.health);
        end,
        change_battle_state = function(battleState)
            local flags = currentPlot.flags;
            local battleState = tonumber(battleState, 10);
            if (battleState == 0) then
                print('Вы вышли из режима боя');
                flags.isInBattle = 0;
            else
                print('Вы вошли в режим боя');
                flags.isInBattle = 1;
            end;
        end,
        restore_hp = function()
            local params = currentPlot.params;
            local stats = currentPlot.stats;

            params.health = STIKSharedFunctions.calculateHealth(stats);
            print('Ваши ХП были восстановлены');
            MainPanelSTIK.HP.Text:SetText(params.health);
        end,
        play_music = function(musicName)
            local _type, number = strsplit("_", musicName);
            PlayMusic("Interface\\AddOns\\STIKSystem\\MUSIC\\".._type.."\\"..number..".mp3");
        end,
        stop_music = function(musicName)
            StopMusic();
        end,
        mod_barrier = function(barrierScore)
            local params = currentPlot.params;

            local score = tonumber(barrierScore, 10);
            params.shield = params.shield + score;
            if (params.shield < 0) then params.shield = 0; end;
            if (score < 0) then print('Вы потеряли '..math.abs(score)..' пункт(-ов) барьера')
            else print('Вы получили '..math.abs(score)..' пункт(-ов) барьера')
            end;
            if (params.shield == 0) then print('Вы лишились барьера!'); end;
            
            MainPanelSTIK.Shield.Text:SetText(params.shield);
        end,
        damage = function (points)
            local params = currentPlot.params;

            local dmg = tonumber(points, 10);
            if (params.shield >= dmg) then
                params.shield = params.shield - dmg;
                print('Вы получили '..dmg.. ' урона. Он был поглощён щитом');
                if (params.shield == 0) then print('Вы потеряли наложенный на вас щит!'); end;
            elseif (params.shield > 0 and params.shield - dmg < 0) then
                local afterShieldDamage = math.abs(params.shield - dmg);
                print('Вы получили '..dmg..' урона. '..params.shield..' единиц были поглощены щитом');
                params.shield = 0;
                params.health = params.health - afterShieldDamage;
                if (params.health < 0) then params.health = 0; end;
                print(afterShieldDamage..' урона прошли через барьер, и нанесли вам повреждения');
                if (params.health == 0) then 
                    print('Вы не можете продолжать бой');
                    SendChatMessage('(( Выведен из боя ))');
                end;
            elseif (params.shield == 0 and params.health >= 0) then
                params.health = params.health - math.abs(dmg);
                print('Вы получили '..dmg..' урона.');
                if (params.health < 0) then params.health = 0; end;
                if (params.health == 0) then 
                    print('Вы не можете продолжать бой');
                    SendChatMessage('(( Выведен из боя ))');
                end;
            end;
            MainPanelSTIK.HP.Text:SetText(params.health);
            MainPanelSTIK.Shield.Text:SetText(params.shield);
        end,
        --[[play_effect = function(effect)
            local _type, number = strsplit("_", effect);
            PlaySoundFile("Interface\\AddOns\\STIKSystem\\EFFECTS\\".._type.."\\"..number..".mp3", "Ambience")
        end,]]--
        invite_to_plot = function(plotInfo)
            local master, meta, title, description = strsplit('~', plotInfo);

            if (not(playerInfo.settings.getPlotInvites)) then
                if (playerInfo.settings.showDeclineMessages) then
                    print('Приглашение на участие в сюжете "'..title..'" было автоматически отклонено');
                end;
                return;
            end;
            if (PopUpFrame and PopUpFrame:IsVisible()) then
                PopUpFrame:Hide();
            end;
            PlaySound("LEVELUPSOUND", "SFX");

            local PopUpFrame = CreateFrame("Frame", "PopUpFrame", UIParent);
                PopUpFrame:Show();
                PopUpFrame:EnableMouse();
                PopUpFrame:SetWidth(396);
                PopUpFrame:SetHeight(396);
                PopUpFrame:SetToplevel(true);
                PopUpFrame:SetBackdropColor(0, 0, 0, 1);
                PopUpFrame:SetFrameStrata("FULLSCREEN_DIALOG");
                PopUpFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
                PopUpFrame:SetBackdrop({
                    bgFile = "Interface\\AddOns\\STIKSystem\\IMG\\popup.blp",
                    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                    tile = false, tileSize = 32, edgeSize = 32,
                    insets = { left = 12, right = 12, top = 12, bottom = 12 },
                });

            local PopUpTitle = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpTitle:SetPoint("CENTER", PopUpFrame, "TOP", 0, -35);
                PopUpTitle:SetText('Приглашение');
                PopUpTitle:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE, MONOCHROME");
                PopUpTitle:Show();
                
            local PopUpInfo = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpInfo:SetWidth(348);
                PopUpInfo:SetPoint("TOP", PopUpFrame, "TOP", 0, -70);
                PopUpInfo:SetText('Ведущий '..master..' предлагает вам стать участником сюжета');
                PopUpInfo:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE, MONOCHROME");
                PopUpInfo:Show();

            local PopUpPlot = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpPlot:SetWidth(348);
                PopUpPlot:SetPoint("TOP", PopUpFrame, "TOP", 0, -120);
                PopUpPlot:SetText('"'..title..'"');
                PopUpPlot:SetTextColor(0.901, 0.494, 0.133, 1);
                PopUpPlot:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE, MONOCHROME");
                PopUpPlot:Show();

            local PopUpDescription = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpDescription:SetWidth(348);
                PopUpDescription:SetPoint("TOP", PopUpFrame, "TOP", 0, -160);
                PopUpDescription:SetText(description);
                PopUpDescription:SetTextColor(0.7, 0.7, 0.7, 1);
                PopUpDescription:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE, MONOCHROME");
                PopUpDescription:Show();

            local PopUpSubmit = CreateFrame("Button", "PopUpSubmit", PopUpFrame, "UIPanelButtonTemplate");
                PopUpSubmit:SetPoint("BOTTOMRIGHT", PopUpFrame, "BOTTOMRIGHT", -36, 36);
                PopUpSubmit:SetWidth(120);
                PopUpSubmit:SetHeight(32);
                PopUpSubmit:SetText('Присоединиться');
                PopUpSubmit:RegisterForClicks("AnyUp");
                PopUpSubmit:SetScript('OnClick', function()
                    SendAddonMessage('STIK_PLAYER_ANSWER', 'invite_accept&'..UnitName('player')..' '..meta, "WHISPER", master);
                    print('Вы присоединились к сюжету "'..title..'"');
                    if (not(playerInfo[meta])) then
                        playerInfo[meta] = {
                            hash = 2034843419,
                        };
                        playerInfo[meta].stats = { str = 0, moral = 0, mg = 0, body = 0, snp = 0, ag = 0 };
                        playerInfo[meta].progress = { expr = 0, lvl = 1 };
                        playerInfo[meta].params = {
                            shield = 0,
                            points = STIKSharedFunctions.calculatePoints(playerInfo[meta].stats, playerInfo[meta].progress),
                            health = STIKSharedFunctions.calculateHealth(playerInfo[meta].stats)
                        };
                        playerInfo[meta].armor = { legs = "nothing", body = "nothing", head = "nothing" };
                        playerInfo[meta].flags = { isInBattle = 0 };
                        playerInfo.savedPlots[meta] = {
                            name = title,
                            content = description,
                        };
                    else print('Вы уже участвовали в этом сюжете. Характеристики были загружены.');
                    end;
                    SettingsPanel:RefreshPlotList();
                    PopUpFrame:Hide();
                end)

            local PopUpDecline = CreateFrame("Button", "PopUpSubmit", PopUpFrame, "UIPanelButtonTemplate");
                PopUpDecline:SetPoint("BOTTOMLEFT", PopUpFrame, "BOTTOMLEFT", 36, 36);
                PopUpDecline:SetWidth(120);
                PopUpDecline:SetHeight(32);
                PopUpDecline:SetText('Отказать');
                PopUpDecline:RegisterForClicks("AnyUp");
                PopUpDecline:SetScript('OnClick', function()
                    SendAddonMessage('STIK_PLAYER_ANSWER', 'invite_decline&'..UnitName('player')..' '..meta, "WHISPER", master);
                    print('Вы отказались присоединиться к сюжету "'..title..'"');
                    PopUpFrame:Hide();
                end)
        end,
        invite_to_evt = function(msg)
            local master, index, shouldResHP, shouldNilBarrier = strsplit('~', VALUE);
            if (not(playerInfo.savedPlots[index])) then
                SendAddonMessage("STIK_PLAYER_ANSWER", "remove_me&"..index.."~"..UnitName("player"), "WHISPER", master);
                return;
            end;

            if (not(playerInfo.settings.getEventInvites)) then
                SendAddonMessage("STIK_PLAYER_ANSWER", "event_decline&"..UnitName("player"), "WHISPER", master);
                if (playerInfo.settings.showDeclineMessages) then
                    print('Приглашение на участие в событии "'..playerInfo.savedPlots[index].name..'" было автоматически отклонено');
                end;
                return;
            end;

            PlaySound("LEVELUPSOUND", "SFX");

            local PopUpFrame = CreateFrame("Frame", "PopUpFrame", UIParent);
                PopUpFrame:Show();
                PopUpFrame:EnableMouse();
                PopUpFrame:SetWidth(360);
                PopUpFrame:SetHeight(360);
                PopUpFrame:SetToplevel(true);
                PopUpFrame:SetBackdropColor(0, 0, 0, 1);
                PopUpFrame:SetFrameStrata("FULLSCREEN_DIALOG");
                PopUpFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
                PopUpFrame:SetBackdrop({
                    bgFile = "Interface\\AddOns\\STIKSystem\\IMG\\event-popup-background.blp",
                    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                    tile = false, tileSize = 32, edgeSize = 32,
                    insets = { left = 12, right = 12, top = 12, bottom = 12 },
                });

            local PopUpTitle = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpTitle:SetPoint("CENTER", PopUpFrame, "TOP", 0, -35);
                PopUpTitle:SetText('Приглашение');
                PopUpTitle:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE, MONOCHROME");
                PopUpTitle:Show();
                
            local PopUpInfo = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpInfo:SetWidth(348);
                PopUpInfo:SetPoint("TOP", PopUpFrame, "TOP", 0, -100);
                PopUpInfo:SetText('Ведущий '..master..' начинает событие в сюжете');
                PopUpInfo:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE, MONOCHROME");
                PopUpInfo:Show();

            local PopUpPlot = PopUpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
                PopUpPlot:SetWidth(348);
                PopUpPlot:SetPoint("TOP", PopUpFrame, "TOP", 0, -150);
                PopUpPlot:SetText('"'..playerInfo.savedPlots[index].name..'"');
                PopUpPlot:SetTextColor(0.901, 0.494, 0.133, 1);
                PopUpPlot:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE, MONOCHROME");
                PopUpPlot:Show();

            local PopUpSubmit = CreateFrame("Button", "PopUpSubmit", PopUpFrame, "UIPanelButtonTemplate");
                PopUpSubmit:SetPoint("CENTER", PopUpFrame, "CENTER", 0, -72);
                PopUpSubmit:SetWidth(160);
                PopUpSubmit:SetHeight(32);
                PopUpSubmit:SetText('Присоединиться');
                PopUpSubmit:RegisterForClicks("AnyUp");
                PopUpSubmit:SetScript("OnClick", function()
                    playerInfo.settings.currentPlot = index;
                    playerInfo.settings.currentMaster = master;
                    SettingsPanel.RefreshPlotList();

                    if (tonumber(shouldResHP) == 1) then
                        playerInfo[index].params.health = STIKSharedFunctions.calculateHealth(playerInfo[index].stats);
                        print('ОЗ были восстановлены по решению ведущего');
                    end;

                    if (tonumber(shouldNilBarrier) == 1) then
                        playerInfo[index].params.shield = 0;
                        print('Барьеры были сброшены по решению ведущего');
                    end;

                    playerInfo[index].hash = STIKSharedFunctions.statHash(playerInfo[index]);
        
                    if (MainPanelSTIK) then MainPanelSTIK:Hide(); end;
                    if (targetInfoFrame) then targetInfoFrame:Hide(); end;
                    if (StatPanel) then StatPanel:Hide(); end;
                    if (DicePanel) then DicePanel:Hide(); end;
                    if (ArmorPanel) then ArmorPanel:Hide(); end;
                    PopUpFrame:Hide();
                    onAddonReady();

                    playerInfo.settings.isEventStarted = true;
                    if (master == UnitName("player")) then return nil end;
                    SHOULD_ACCEPT_NEXT_INVITE = true;
                    MASTER = master;
                    SendAddonMessage("STIK_PLAYER_ANSWER", "event_accept&"..UnitName("player"), "WHISPER", master);
                end);

            local PopUpDecline = CreateFrame("Button", "PopUpSubmit", PopUpFrame, "UIPanelButtonTemplate");
                PopUpDecline:SetPoint("CENTER", PopUpFrame, "CENTER", 0, -112);
                PopUpDecline:SetWidth(160);
                PopUpDecline:SetHeight(32);
                PopUpDecline:SetText('Отказаться');
                PopUpDecline:RegisterForClicks("AnyUp");
                PopUpDecline:SetScript("OnClick", function()
                    SendAddonMessage("STIK_PLAYER_ANSWER", "event_decline&"..UnitName("player"), "WHISPER", master);
                    PopUpFrame:Hide();
                end);
        end,
        event_stop = function(plotID)
            if (not(playerInfo.settings.currentPlot == plotID)) then return nil; end;
            playerInfo.settings.isEventStarted = false;
            playerInfo.settings.currentPlot = nil;
            playerInfo.settings.currentMaster = nil;
            if (MainPanelSTIK) then MainPanelSTIK:Hide(); end;
            if (targetInfoFrame) then targetInfoFrame:Hide(); end;
            if (StatPanel) then StatPanel:Hide(); end;
            if (DicePanel) then DicePanel:Hide(); end;
            if (ArmorPanel) then ArmorPanel:Hide(); end;
            onAddonReady();
            print('Мастер завершил событие сюжета "'..playerInfo.savedPlots[plotID].name..'"');
        end,
    };

    commandConnector[COMMAND](VALUE);
    if (currentPlot) then currentPlot.hash = STIKSharedFunctions.statHash(currentPlot); end;
end;