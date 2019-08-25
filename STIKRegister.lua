-- Динамические элементы для панелей --

STIKRegister = {
    mainButton = function (settings)
        local function setButtonView(view)
            view:SetSize(STIKConstants.button.width, STIKConstants.button.height);
            view:SetPoint("CENTER", settings.parent, "TOP", settings.coords.x, settings.coords.y);
            view:RegisterForClicks("AnyUp");
            view:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            if (settings.highlight) then
                view:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            end
            view:Show()
        end

        local function setButtonScripts(view)
            view:SetScript("OnEnter", settings.functions.showHint);
            view:SetScript("OnLeave", settings.functions.hideHint);
            view:SetScript("OnClick", settings.functions.swapPanel);
        end

        local button = CreateFrame("Button", "MainPanelButton", settings.parent, "SecureHandlerClickTemplate");
        button.hint = settings.hint;
        setButtonView(button);
        setButtonScripts(button);

        return button;
    end,
    dice = function (settings)
        local function setDiceView(view)
            view:SetSize(STIKConstants.smallButton.width, STIKConstants.smallButton.height);
            view:SetPoint("CENTER", settings.views.parent, "TOP", settings.coords.x, -10 + settings.coords.y);
            view:RegisterForClicks("AnyUp");
            view:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:Show()
        end

        local function setDiceScripts(view)
            view:SetScript("OnEnter", gui.showPanelHint);
            view:SetScript("OnLeave", gui.hidePanelHint);
            view:SetScript("OnClick",
                function()
                    local prevStat = settings.views.menu.stat;
                    settings.views.menu.stat = view.stat;

                    if ((prevStat == settings.views.menu.stat) and (settings.views.menu:IsVisible())) then 
                        settings.views.menu:Hide();
                    else
                        local countOfDices = #STIKConstants.dicePanelElements;
                        settings.views.menu:SetPoint("LEFT", settings.views.main, "TOPLEFT", 137, settings.coords.y);
                        settings.views.menu:Show();
                    end
                end
            );
        end

        local rollButton = CreateFrame("Button", "diceButton", settings.views.parent, "SecureHandlerClickTemplate")
        rollButton.hint = settings.hint;
        rollButton.stat = settings.stat;
        setDiceView(rollButton);
        setDiceScripts(rollButton);

        return rollButton;
    end,
    stat = function (settings, playerContext)
        local stats = playerContext.stats;
        if (not stats[settings.stat]) then stats[settings.stat] = 0; end;
        local panel = gui.createLine({
            parent = settings.parent,
            content = STIKConstants.texts.stats[settings.stat]..": "..stats[settings.stat],
            coords = settings.coords,
            direction = { x = "LEFT", y = "TOP" }
        });

        local AddButton = gui.createDefaultButton({
            parent = settings.parent, content = "+",
            coords = { x = 45, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        AddButton:SetScript("OnClick",
            function()
                stats[settings.stat] = STIKSharedFunctions.modifyStat(STIKConstants.texts.jobs.add, stats[settings.stat], playerContext);
                panel:SetText(STIKConstants.texts.stats[settings.stat]..": "..stats[settings.stat]);
                playerContext.params.health = STIKSharedFunctions.calculateHealth(stats);
                MainPanelSTIK.HP.Text:SetText(playerContext.params.health);

                local skillTypes = STIKConstants.skillTypes.types;
                for i = 1, #skillTypes do
                    local name = skillTypes[i].name;
                    MainPanelSTIK.Skills[name].Points.RecalcPoints();
                end;
                playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
            end
        );

        local RemoveButton = gui.createDefaultButton({
            parent = settings.parent, content = "-",
            coords = { x = 65, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });
        
        RemoveButton:SetScript("OnClick",
            function()
                stats[settings.stat] = STIKSharedFunctions.modifyStat(STIKConstants.texts.jobs.remove, stats[settings.stat], playerContext);
                panel:SetText(STIKConstants.texts.stats[settings.stat]..": "..stats[settings.stat]);
                playerContext.params.health = STIKSharedFunctions.calculateHealth(stats);
                MainPanelSTIK.HP.Text:SetText(playerContext.params.health);

                local skillTypes = STIKConstants.skillTypes.types;
                for i = 1, #skillTypes do
                    local name = skillTypes[i].name;
                    MainPanelSTIK.Skills[name].Points.RecalcPoints();
                end;
                playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
            end
        );
        
        local ClearButton = gui.createDefaultButton({
            parent = settings.parent, content = "0",
            coords = { x = 85, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });
    
        ClearButton:SetScript("OnClick",
            function()
                stats[settings.stat] = STIKSharedFunctions.modifyStat(STIKConstants.texts.jobs.clear, stats[settings.stat], playerContext);
                panel:SetText(STIKConstants.texts.stats[settings.stat]..": "..stats[settings.stat]);
                playerContext.params.health = STIKSharedFunctions.calculateHealth(stats);
                MainPanelSTIK.HP.Text:SetText(playerContext.params.health);

                local skillTypes = STIKConstants.skillTypes.types;
                for i = 1, #skillTypes do
                    local name = skillTypes[i].name;
                    MainPanelSTIK.Skills[name].Points.RecalcPoints();
                end;
                playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
            end
        );

        return panel;
    end,
    roll = function (settings, playerContext)
        local params = playerContext.params;
        local stats = playerContext.stats;
        local armor = playerContext.armor;

        local menu = settings.parent;

        local function setRollView(view)
            view:SetPoint("TOP", settings.parent, "LEFT", settings.coords.x, settings.coords.y);
            view:SetHeight(23);
            view:SetWidth(50);
            view:SetText("d"..settings.dice.size);
            view:RegisterForClicks("AnyUp");
        end

        local function setRollScript(view)
            view:SetScript("OnClick",
                function()
                    local usingStat = menu.stat;
                    local diceSize = settings.dice.size;
                    if (usingStat == 'luck') then return RandomRoll(0, diceSize); end;

                    local penaltyOfDice = settings.dice.penalty;
                    local modiferOfHealth = params.health/(3 + math.floor(stats.body / 20));
                    if (modiferOfHealth > 1) then modiferOfHealth = 1 end;

                    local resultSkill = modiferOfHealth * (stats[usingStat] / penaltyOfDice);

                    local penaltyByArmor = {
                        head = -STIKConstants.armorPenalty.head[armor.head][usingStat],
                        body = -STIKConstants.armorPenalty.body[armor.body][usingStat],
                        legs = -STIKConstants.armorPenalty.legs[armor.legs][usingStat],
                    };

                    local rollWithoutArmor = math.ceil((diceSize * resultSkill)/100);
                    local penaltyOfArmor = penaltyByArmor.head + penaltyByArmor.body + penaltyByArmor.legs;

                    local minRoll = rollWithoutArmor - math.ceil(rollWithoutArmor * penaltyOfArmor);
                    local maxRoll = diceSize + rollWithoutArmor;
                    maxRoll = maxRoll - math.ceil(maxRoll * penaltyOfArmor);

                    if (maxRoll == 0) then maxRoll = 1; end;
                    if (playerInfo.settings.showRollInfo) then
                        print('Бросок куба: '..STIKConstants.texts.stats[usingStat]..' (d'..settings.dice.size..')');
                        print('Приведенный навык: '..math.ceil((diceSize * stats[usingStat])/100));
                        print('Модификатор от размера куба: '..string.sub(1 / penaltyOfDice, 0, 5));
                        print('Модификатор от ОЗ: '..modiferOfHealth);
                        print('Бросок модифицированного навыка (без учета брони): '..rollWithoutArmor);
                        print('Дополнительный модификатор от брони: '..penaltyOfArmor);
                        print('Нижний порог: '..rollWithoutArmor..'-('..rollWithoutArmor..'*'..penaltyOfArmor..') = '..minRoll);
                        print('Верхний порог: ('..diceSize..'+'..rollWithoutArmor..')-(('..diceSize..'+'..rollWithoutArmor..')*'..penaltyOfArmor..') = '..maxRoll);
                    else
                        print('Бросок куба: '..STIKConstants.texts.stats[usingStat]..' (d'..settings.dice.size..')');
                    end;

                    if (playerInfo.settings.isEventStarted) then
                        SendAddonMessage("STIK_PLAYER_ANSWER", "roll_dice&"..STIKConstants.texts.stats[usingStat].." d"..settings.dice.size, "WHISPER", playerInfo.settings.currentMaster);
                    end;
                    RandomRoll(minRoll, maxRoll);
                end
            );
        end

        local button = CreateFrame("Button", "rollButton", menu, "UIPanelButtonTemplate");
        setRollView(button);
        setRollScript(button);
    end,
    armor = function (settings, playerContext)
        local armor = playerContext.armor;
        local armorLine = gui.createLine({
            parent = settings.views.parent,
            content = STIKConstants.texts.armor[settings.slot]..": "..STIKConstants.texts.armorTypes[armor[settings.slot]],
            coords = settings.line.coords,
            direction = settings.line.direction,
        });

        local armorButton = gui.createDefaultButton({
            parent = settings.views.parent,
            content = ">",
            coords = settings.button.coords,
            direction = settings.button.direction,
        });
        armorButton:SetScript("OnClick",
            function()
                local prevSlot = settings.views.armorMenu.slot;
                settings.views.armorMenu.slot = settings.slot;
                settings.views.armorMenu.connectedWith = armorLine;

                if ((prevSlot == settings.views.armorMenu.slot) and (settings.views.armorMenu:IsVisible())) then 
                    settings.views.armorMenu:Hide();
                else
                    settings.views.armorMenu:SetPoint("LEFT", settings.views.parent, "TOP", 70, settings.line.coords.y);
                    settings.views.armorMenu:Show();
                end
            end
        );

        armorLine.button = armorButton;
        return armorLine;
    end,
    armorType = function (settings, playerContext)
        local armor = playerContext.armor;
        local function setArmorTypeView(view)
            view:SetPoint("TOP", settings.parent, "LEFT", settings.coords.x, settings.coords.y);
            view:SetHeight(23);
            view:SetWidth(70);
            view:SetText(STIKConstants.texts.armorTypes[settings.armorType]);
            view:RegisterForClicks("AnyUp");
        end

        local function setArmorTypeScript(view)
            view:SetScript("OnClick",
                function()
                    
                    local currentPlot = playerInfo.settings.currentPlot;
                    local flags = playerInfo[currentPlot].flags;

                    if (flags.isInBattle == 1) then
                        print('Нельзя менять броню в бою');
                        return nil;
                    else
                        local slot = settings.parent.slot;
                        armor[slot] = settings.armorType;
                        settings.parent.connectedWith:SetText(STIKConstants.texts.armor[slot]..": "..STIKConstants.texts.armorTypes[armor[slot]]);
                        playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
                        settings.parent:Hide();
                    end;
                end
            )
        end

        local button = CreateFrame("Button", "rollButton", settings.parent, "UIPanelButtonTemplate");
        setArmorTypeView(button);
        setArmorTypeScript(button);

        return button;
    end,
    skillType = function (settings)
        local function setSkillView(view)
            view:SetSize(STIKConstants.smallButton.width, STIKConstants.smallButton.height);
            view:SetPoint("CENTER", settings.views.parent, "TOP", settings.coords.x, -10 + settings.coords.y);
            view:RegisterForClicks("AnyUp");
            view:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:Show()
        end

        local function setSkillScripts(view)
            view:SetScript("OnEnter", gui.showPanelHint);
            view:SetScript("OnLeave", gui.hidePanelHint);
            view:SetScript("OnClick",
                function()
                    local wasVisible = settings.views.main.Skills[settings.name]:IsVisible();

                    for i = 1, #STIKConstants.skills do
                        local category = STIKConstants.skills[i];
                        settings.views.main.Skills[category.name]:Hide();
                    end;

                    if (not wasVisible) then settings.views.main.Skills[settings.name]:Show(); end;
                end
            );
        end

        local skillTypeButton = CreateFrame("Button", "skillTypeButton", settings.views.parent, "SecureHandlerClickTemplate");
        skillTypeButton.hint = settings.hint;
        setSkillView(skillTypeButton);
        setSkillScripts(skillTypeButton);

        return skillTypeButton;
    end,
    skill = function (settings, playerContext)
        local skills = playerContext.skills;
        if (not skills[settings.category]) then skills[settings.category] = { }; end;
        if (not skills[settings.category][settings.name]) then skills[settings.category][settings.name] = 0; end;

        local panel = gui.createLine({
            parent = settings.views.parent,
            content = STIKConstants.texts.skills[settings.name]..": "..skills[settings.category][settings.name],
            coords = settings.coords,
            direction = { x = "LEFT", y = "TOP" }
        });

        local AddButton = gui.createDefaultButton({
            parent = settings.views.parent, content = "+",
            coords = { x = 55, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        AddButton:SetScript("OnClick",
            function()
                local havePoints = MainPanelSTIK.Skills[settings.category].Points.GetAvailablePoints();
                if (havePoints <= 0) then return; end;
                skills[settings.category][settings.name] = skills[settings.category][settings.name] + 1;
                panel:SetText(STIKConstants.texts.skills[settings.name]..": "..skills[settings.category][settings.name]);
                MainPanelSTIK.Skills[settings.category].Points.RecalcPoints();
                playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
            end
        );

        local RemoveButton = gui.createDefaultButton({
            parent = settings.views.parent, content = "-",
            coords = { x = 75, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        RemoveButton:SetScript("OnClick",
            function()
                local havePoints = MainPanelSTIK.Skills[settings.category].Points.GetAvailablePoints();
                if (skills[settings.category][settings.name] <= 0) then return; end;
                skills[settings.category][settings.name] = skills[settings.category][settings.name] - 1;
                panel:SetText(STIKConstants.texts.skills[settings.name]..": "..skills[settings.category][settings.name]);
                MainPanelSTIK.Skills[settings.category].Points.RecalcPoints();
                playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
            end
        );

        local ClearButton = gui.createDefaultButton({
            parent = settings.views.parent, content = "0",
            coords = { x = 95, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        ClearButton:SetScript("OnClick",
            function()
                skills[settings.category][settings.name] = 0
                panel:SetText(STIKConstants.texts.skills[settings.name]..": "..skills[settings.category][settings.name]);
                MainPanelSTIK.Skills[settings.category].Points.RecalcPoints();
                playerContext.hash = tonumber(STIKSharedFunctions.statHash(playerContext));
            end
        );

        return panel;
    end;
};