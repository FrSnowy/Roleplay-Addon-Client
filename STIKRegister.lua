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
    diceCategory = function (settings)
        local function setCategoryView(view)
            view:SetSize(STIKConstants.smallButton.width, STIKConstants.smallButton.height);
            view:SetPoint("CENTER", settings.views.parent, "TOP", settings.coords.x, -10 + settings.coords.y);
            view:RegisterForClicks("AnyUp");
            view:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:Show()
        end;

        local function setCategoryScripts(view)
            view:SetScript("OnEnter", gui.showPanelHint);
            view:SetScript("OnLeave", gui.hidePanelHint);
            view:SetScript("OnClick",
                function()
                    local wasVisible = settings.views.main.DicePanels[settings.name]:IsVisible();

                    for i = 1, #STIKConstants.skills do
                        local category = STIKConstants.skills[i];
                        settings.views.main.DicePanels[category.name]:Hide();
                    end;

                    if (not wasVisible) then settings.views.main.DicePanels[settings.name]:Show(); end;
                    STIKPanelLinks.RollPanel:Hide();
                end
            );
        end;

        local diceCategory = CreateFrame("Button", "diceCategory", settings.views.parent, "SecureHandlerClickTemplate");
        diceCategory.hint = settings.hint;
        setCategoryView(diceCategory);
        setCategoryScripts(diceCategory);

        return diceCategory;
    end,
    diceElement = function (settings)
        local function setElementView(view)
            view:SetSize(STIKConstants.smallButton.width, STIKConstants.smallButton.height);
            view:SetPoint("CENTER", settings.views.parent, "TOP", settings.coords.x, -10 + settings.coords.y);
            view:RegisterForClicks("AnyUp");
            view:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
            view:Show()
        end;

        local function setElementScrips(view)
            view:SetScript("OnEnter", gui.showPanelHint);
            view:SetScript("OnLeave", gui.hidePanelHint);
            view:SetScript("OnClick", function()
                STIKPanelLinks.RollPanel:SetPoint("TOPLEFT", settings.views.parent, "TOPLEFT", 100, settings.coords.y + 20)
                if (settings.name == STIKPanelLinks.RollPanel.Name and STIKPanelLinks.RollPanel:IsVisible()) then
                    STIKPanelLinks.RollPanel:Hide();
                    STIKPanelLinks.RollPanel.Name = nil;
                    STIKPanelLinks.RollPanel.Category = nil;
                else
                    STIKPanelLinks.RollPanel.Name = settings.name;
                    STIKPanelLinks.RollPanel.Category = settings.category;
                    STIKPanelLinks.RollPanel:Show();
                end;
            end)
        end;

        local diceElement = CreateFrame("Button", "diceElementButton", settings.views.parent, "SecureHandlerClickTemplate");
        diceElement.hint = settings.hint;
        setElementView(diceElement);
        setElementScrips(diceElement);
        return diceElement;
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
                playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
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
                playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
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
                playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
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
                    local categoryName = STIKPanelLinks.RollPanel.Category;
                    local skillName = STIKPanelLinks.RollPanel.Name;
                    local size = settings.dice.size;

                    local getSkill = function(category, name)
                        local skills = STIKSortTable(STIKConstants.skills);

                        local getCategory = function(category)
                            local foundedCategory = nil;
                            for i = 1, #skills do
                                local currentCategory = skills[i];
                                if (currentCategory.name == category) then foundedCategory = currentCategory; end;
                            end;
                            return foundedCategory;
                        end;

                        local category = getCategory(category);
                        local foundedSkill = nil;

                        for i = 1, #category.skills do
                            local currentSkill = category.skills[i];
                            if (currentSkill.name == name) then foundedSkill = currentSkill; end;
                        end;
                        return foundedSkill;
                    end;

                    local skill = getSkill(categoryName, skillName);

                    local getClearSkillValue = function()
                        local clearSkill = playerContext.skills[categoryName][skillName];
                        if (playerInfo.settings.showRollInfo) then
                            print('Чистое значение навыка: '..clearSkill);
                        end;
                        return clearSkill;
                    end;

                    local getSkillStatBonuses = function(skillValue, skill)
                        local stats = {
                            main = skill.stats.main,
                            sub = skill.stats.sub,
                            third = skill.stats.third,
                        };

                        local statValues = {
                            main = playerContext.stats[stats.main],
                            sub = playerContext.stats[stats.sub],
                            third = playerContext.stats[stats.third],
                        };

                        local bonuceFromStats = {
                            main = math.floor(statValues.main / 5),
                            sub = math.floor(statValues.sub / 10),
                            third = math.floor(statValues.third / 15),
                        };

                        local resultBonuce = bonuceFromStats.main + bonuceFromStats.sub + bonuceFromStats.third;
                        if (playerInfo.settings.showRollInfo) then
                            print('Навык с бонусом от характеристик: '..skillValue + resultBonuce);
                        end;
                        return skillValue + resultBonuce;
                    end;

                    local getRollSize = function(modifier)
                        local toDiceSize = function(num, diceSize)
                            return math.ceil((num * diceSize) / 100);
                        end;
                        if (playerInfo.settings.showRollInfo) then
                            print('Нормированное значение кубиков: '..toDiceSize(modifier, size)..'-'..size + toDiceSize(modifier, size));
                        end;
                        return { min = toDiceSize(modifier, size), max = size + toDiceSize(modifier, size) };
                    end;

                    local getHealthPenalty = function(roll)
                        local modiferOfHealth = params.health/(3 + math.floor(stats.body / 20));
                        if (modiferOfHealth > 1) then modiferOfHealth = 1 end;
                        if (playerInfo.settings.showRollInfo) then
                            print('После штрафа от ОБ: '..roll.min * modiferOfHealth..'-'..roll.max * modiferOfHealth);
                        end;
                        return { min = roll.min * modiferOfHealth, max = roll.max * modiferOfHealth };
                    end;

                    local getSkillModifierBonuses = function(roll, skill)
                        if (not skill.modifier) then return roll; end;

                        local getSkillModifier = function(modifier)
                            local normal = modifier.normal;
                            local skillValue = playerContext.skills[modifier.category][modifier.name];
                            if (modifier.reverse) then
                                if (skillValue > normal) then
                                    local penalty = (skillValue/normal) / 100;
                                    return -penalty;
                                else
                                    return 0;
                                end;
                            else
                                if (skillValue < normal) then
                                    local penalty = 1 - skillValue/normal;
                                    return -penalty;
                                elseif (skillValue > normal) then
                                    local bonus = skillValue/normal - 1;
                                    return bonus / 5;
                                else
                                    return 0;
                                end;
                            end;
                        end;

                        local modifiers = STIKSortTable(skill.modifier);
                        for i = 1, #modifiers do
                            local modifier = modifiers[i];
                            local modifierValue = 0;
                            if (modifier.block == 'skills') then
                                modifierValue = getSkillModifier(modifier);
                            end;

                            roll = {
                                min = math.floor(roll.min + (roll.min * modifierValue)),
                                max = math.floor(roll.max + (roll.max * modifierValue))
                            };
                        end;
                        if (playerInfo.settings.showRollInfo) then
                            print('После модификатора от навыков: '..roll.min..'-'..roll.max);
                        end;
                        return roll;
                    end;

                    local getArmorModifierBonuses = function(roll, skill)
                        local changeModifierBySkill = function (modifier)
                            local skill = playerContext.skills.passive.armor;
                            if (modifier < 0) then
                                local percent = skill / 100;
                                local newModifier = modifier + percent / 3;
                                if (newModifier > 0) then newModifier = 0; end;
                                return newModifier;
                            else
                                local percent = (skill / 100) / 4;
                                local newModifier = modifier + percent;
                                if (newModifier > 0.35) then newModifier = 0.25; end;
                                return newModifier;
                            end;
                        end;

                        local clearModifierByArmor = {
                            head = STIKConstants.armorPenalty.head[armor.head][skill.name],
                            body = STIKConstants.armorPenalty.body[armor.body][skill.name],
                            legs = STIKConstants.armorPenalty.legs[armor.legs][skill.name],
                        };

                        local modifierByArmor = {
                            head = -changeModifierBySkill(clearModifierByArmor.head),
                            body = -changeModifierBySkill(clearModifierByArmor.body),
                            legs = -changeModifierBySkill(clearModifierByArmor.legs),
                        };

                        local armorSummaryModifier = modifierByArmor.head + modifierByArmor.body + modifierByArmor.legs;
                        roll = {
                            min = math.floor(roll.min - (roll.min * armorSummaryModifier)),
                            max = math.floor(roll.max - (roll.max * armorSummaryModifier)),
                        };
                        if (playerInfo.settings.showRollInfo) then
                            print('После модификаторов брони: '..roll.min..'-'..roll.max);
                        end;
                        return roll;
                    end;

                    local getPenaltyBySize = function(roll, penalty)
                        roll = { min = math.floor(roll.min * penalty), max = math.floor(roll.max * penalty) };
                        if (playerInfo.settings.showRollInfo) then
                            print('После модификаторов размера куба: '..roll.min..'-'..roll.max);
                        end;
                        return roll;
                    end;

                    if (MainPanelSTIK.Skills[categoryName].Points.GetAvailablePoints() < 0) then
                        print('Требуется перераспределить '..STIKConstants.texts.skillTypes[categoryName]..' навыки');
                        return nil;
                    end;
                    
                    print('Бросок куба: '..STIKConstants.texts.skills[skill.name].." (d"..size..")");
                    
                    local skillValue = getClearSkillValue();
                    
                    if (skill.fireWithStat and skillValue == 0) then
                        print('Персонаж не владеет нужным навыком');
                        if (playerInfo.settings.isEventStarted) then
                            SendAddonMessage(
                                "STIK_PLAYER_ANSWER",
                                "roll_dice&"..STIKConstants.texts.skills[skill.name].."|d"..size,
                                "WHISPER",
                                playerInfo.settings.currentMaster
                            );
                        end;
                        RandomRoll(0, 1);
                        return nil;
                    end;

                    local skillWithBonuses = getSkillStatBonuses(skillValue, skill);
                    local roll = getRollSize(skillWithBonuses, size);
                    local rollWithHealth = getHealthPenalty(roll);
                    local rollWithSkillModifier = getSkillModifierBonuses(rollWithHealth, skill);
                    local rollWithArmor = getArmorModifierBonuses(rollWithSkillModifier, skill);
                    --local finalRoll = getPenaltyBySize(rollWithArmor, settings.dice.penalty);
                    local finalRoll = rollWithArmor;

                    if (finalRoll.min < 0) then
                        finalRoll.max = finalRoll.max - math.abs(finalRoll.min);
                        finalRoll.min = 0;
                    end;

                    if (finalRoll.max == 0) then finalRoll.max = 1; end;

                    if (playerInfo.settings.isEventStarted) then
                        SendAddonMessage(
                            "STIK_PLAYER_ANSWER",
                            "roll_dice&"..STIKConstants.texts.skills[skill.name].." d"..size,
                            "WHISPER",
                            playerInfo.settings.currentMaster
                        );
                    end;
                    RandomRoll(finalRoll.min, finalRoll.max);
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
                        playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
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
                STIKSharedFunctions.modifySkill(STIKConstants.texts.jobs.add, settings.category, settings.name, panel, playerContext);
                playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
            end
        );

        local RemoveButton = gui.createDefaultButton({
            parent = settings.views.parent, content = "-",
            coords = { x = 75, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        RemoveButton:SetScript("OnClick",
            function()
                STIKSharedFunctions.modifySkill(STIKConstants.texts.jobs.remove, settings.category, settings.name, panel, playerContext);
                playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
            end
        );

        local ClearButton = gui.createDefaultButton({
            parent = settings.views.parent, content = "0",
            coords = { x = 95, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        ClearButton:SetScript("OnClick",
            function()
                STIKSharedFunctions.modifySkill(STIKConstants.texts.jobs.clear, settings.category, settings.name, panel, playerContext);
                playerContext.hash = tonumber(STIKSharedFunctions.calculateHash(playerContext));
            end
        );

        return panel;
    end;
};