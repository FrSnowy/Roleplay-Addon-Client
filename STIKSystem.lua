--- Переменные для панелей ---
local button = {
    width = 32,
    height = 32,
};

local smallButton = {
    width = button.width - 6,
    height = button.height - 6,
};

local smallestButton = {
    width = 16,
    height = 16,
};

local texts = {
    stats = {
        str = "Сила",
        ag = "Ловкость",
        snp = "Точность",
        mg = "Маг. способности",
        body = "Крепость",
        moral = "Мораль",
        luck = "Удача",
        level = "Уровень",
        hp = "Здоровье",
        shield = "Барьеры, щиты",
        armor = "Носимые доспехи",

        stat = "Характеристики",
        expr = "Опыт",
        avaliable = "Доступно",
    },
    jobs = {
        add = "add",
        remove = "remove",
        clear = "clear",
    },
    dices = "Кубы",
    settings = {
        title = "Настройки",
        getPlotInv = "Получать приглашения в сюжеты",
        getEventInv = "Получать приглашения на события",
        showDeclineMessages = "Показывать уведомления об отказе",
        showRollInfo = "Показывать информацию о броске",
        parameters = "Параметры",
        parts = "Сохраненные сюжеты",
        plot = "Сюжет",
        removePlot = "Удалить",
        selectPlot = "Активировать",
        unselectPlot = "Деактивировать",
        activeEventTitle = "Активный сюжет",
        unactivateButton = "Покинуть текущее событие"
    },
    err = {
        battle = "Нельзя изменить значение характеристики в процессе боя",
        hashIsWrong = "Кажется, параметры игрока были изменены из файла игры. Все параметры сброшены к нулю.",
    },
    canBeAttacked = {
        ok = "Цель может быть атакована в ближнем бою",
        notOK = "Цель не может быть атакована в ближнем бою",
    },
    armor = {
        head = "Шлем",
        body = "Нагрудник",
        legs = "Ноги",
    },
    armorTypes = {
        cloth = "Ткань",
        leather = "Кожа",
        mail = "Кольчуга",
        plate = "Латы",
        nothing = "Ничего",
    },
};

--- Интеракции для панелии ---
function showPanelHint(self)
    if (self.hint) then
        GameTooltip:SetOwner(self,"ANCHOR_TOP");
        GameTooltip:AddLine(self.hint);
        GameTooltip:Show();
    end
end

function hidePanelHint(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide();
    end
end

function swapPanel(panel)
    if panel:IsVisible() then panel:Hide();
    else panel:Show();
    end
end

function calculatePoints(stats, progress)
    return 100 + 5 * (progress.lvl - 1) - (stats.str + stats.ag + stats.snp + stats.mg + stats.body + stats.moral);
end

function calculateHealth(stats)
    return 3 + math.floor(stats.body / 20);
end

function getPlayerContext(playerInfo)
    if (playerInfo.settings.currentPlot == nil) then
        return nil;
    else
        return playerInfo[playerInfo.settings.currentPlot];
    end;
end;

function STIKSortTable(dict)
    local keys = { };
    for key in pairs(dict) do table.insert(keys, key) end;
    table.sort(keys)

    local sortedDict = { };
    for _, key in ipairs(keys) do sortedDict[key] = dict[key] end;
    return sortedDict;
end;

function STIKStringHash(text)
    local counter = 1
    local len = string.len(text)
    for i = 1, len, 3 do 
      counter = math.fmod(counter*8161, 4294967279) +
          (string.byte(text,i)*16776193) +
          ((string.byte(text,i+1) or (len-i+256))*8372226) +
          ((string.byte(text,i+2) or (len-i+256))*3932164)
    end
    return math.fmod(counter, 4294967291)
end

function STIKStatHash(playerContext)
    local getDictionaryAsString = function (dict)
        local dictString = "";
        for key, value in pairs(dict) do
            dictString = dictString.."&"..key.."="..value
        end;

        return dictString;
    end;
    
    local statString = getDictionaryAsString(STIKSortTable(playerContext.stats));
    local flagsString = getDictionaryAsString(STIKSortTable(playerContext.flags));
    local armorString = getDictionaryAsString(STIKSortTable(playerContext.armor));
    local progressString = getDictionaryAsString(STIKSortTable(playerContext.progress));
    local paramsString = getDictionaryAsString(STIKSortTable(playerContext.params));

    local summaryString = statString..flagsString..armorString..progressString..paramsString;
    return STIKStringHash(summaryString);
end;

function IsHashOK(playerContext)
    local hashofStats = STIKStatHash(playerContext);
    local hashOfCtx = playerContext.hash;
    return tonumber(hashofStats) == tonumber(hashOfCtx);
end;

function onAddonReady()
    -- Брать со знаком минус --
    -- Больше нуля - добавление, меньше - штраф --
    local armorPenalty = {
        head = {
            nothing = { str = 0, ag = 0, snp = 0.03, mg = 0.03, body = -0.05, moral = -0.05, luck = 0 },
            cloth = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, moral = 0, luck = 0 },
            leather = { str = 0, ag = -0.03, snp = -0.05, mg = 0, body = 0, moral = 0, luck = 0 },
            mail = { str = 0, ag = -0.05, snp = -0.1,  mg = 0, body = 0.05, moral = 0.05, luck = 0 },
            plate = { str = 0, ag = -0.07, snp = -0.2, mg = 0, body = 0.1, moral = 0.1, luck = 0 },
        },
        body = {
            nothing = { str = 0, ag = 0.1, snp = 0, mg = 0.1, body = -0.3, moral = -0.2, luck = 0 },
            cloth = { str = 0, ag = 0.05, snp = 0, mg = 0, body = -0.1, moral = 0, luck = 0 },
            leather = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, moral = 0.03, luck = 0 },
            mail = { str = 0.05, ag = -0.05, snp = -0.05, mg = -0.02, body = 0.05, moral = 0.07, luck = 0 },
            plate = { str = 0.1, ag = -0.2, snp = -0.1, mg = -0.05, body = 0.2, moral = 0.1, luck = 0 },
        },
        legs = {
            nothing = { str = 0, ag = 0.1, snp = 0, mg = 0.1, body = -0.3, moral = -0.5, luck = 0 },
            cloth = { str = 0, ag = 0.05, snp = 0, mg = 0, body = -0.1, moral = 0, luck = 0 },
            leather = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, moral = 0.03, luck = 0 },
            mail = { str = 0.05, ag = -0.05, snp = 0, mg = -0.02, body = 0.05, moral = 0.07, luck = 0 },
            plate = { str = 0.1, ag = -0.2, snp = -0.1, mg = -0.05, body = 0.1, moral = 0.1, luck = 0 },
        },
    };
    --- Функции, которые работают с гуем без контекста ---
    gui = {
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
        registerMainButton = function (settings)
            local function setButtonView(view)
                view:SetSize(button.width, button.height);
                view:SetPoint("CENTER", settings.parent, "CENTER", settings.coords.x, settings.coords.y);
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
        registerDice = function (settings)
            local function setDiceView(view)
                view:SetSize(smallButton.width, smallButton.height);
                view:SetPoint("CENTER", settings.views.parent, "CENTER", settings.coords.x, -10 + settings.coords.y);
                view:RegisterForClicks("AnyUp");
                view:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
                view:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..settings.image..".blp");
                view:Show()
            end

            local function setDiceScripts(view)
                view:SetScript("OnEnter", showPanelHint);
                view:SetScript("OnLeave", hidePanelHint);
                view:SetScript("OnClick",
                    function()
                        local prevStat = settings.views.menu.stat;
                        settings.views.menu.stat = view.stat;
    
                        if ((prevStat == settings.views.menu.stat) and (settings.views.menu:IsVisible())) then 
                            settings.views.menu:Hide();
                        else
                            settings.views.menu:SetPoint("LEFT", settings.views.main, "LEFT", 130, -10 + settings.coords.y);
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
    --- Функции, которые работают с контекстом ---
    helpers = {
        modifyStat = function (job, stat, playerContext)
            local flags = playerContext.flags;
            local progress = playerContext.progress;
            local params = playerContext.params;

            local isInBattle = not(flags.isInBattle == 0);
            
            if (isInBattle) then
                print(texts.err.battle);
                return stat;
            end;

            local prevStatValue = stat;
            local jobConnector = {
                [texts.jobs.add] = function()
                    if (stat < 40 + 5 * (progress.lvl - 1) and params.points > 0) then return stat + 1;
                    else return stat; end;
                end,
                [texts.jobs.remove] = function()
                    if (stat > 0) then return stat - 1;
                    else return 0; end;
                end,
                [texts.jobs.clear] = function()
                    return 0;
                end,
            };

            stat = jobConnector[job]();
            params.points = params.points - (stat - prevStatValue);
            StatPanel.Avl:SetText(texts.stats.avaliable..": "..params.points);
            return stat;
        end,
        registerStat = function (settings, playerContext)
            local stats = playerContext.stats;
            local panel = gui.createLine({
                parent = settings.parent,
                content = texts.stats[settings.stat]..": "..stats[settings.stat],
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
                    stats[settings.stat] = helpers.modifyStat(texts.jobs.add, stats[settings.stat], playerContext);
                    panel:SetText(texts.stats[settings.stat]..": "..stats[settings.stat]);
                    playerContext.params.health = calculateHealth(stats);
                    MainPanelSTIK.HP.Text:SetText(playerContext.params.health);
                    playerContext.hash = tonumber(STIKStatHash(playerContext));
                end
            );
    
            local RemoveButton = gui.createDefaultButton({
                parent = settings.parent, content = "-",
                coords = { x = 65, y = settings.coords.y },
                direction = { x = "LEFT", y = "TOP" }
            });
            
            RemoveButton:SetScript("OnClick",
                function()
                    stats[settings.stat] = helpers.modifyStat(texts.jobs.remove, stats[settings.stat], playerContext);
                    panel:SetText(texts.stats[settings.stat]..": "..stats[settings.stat]);
                    playerContext.params.health = calculateHealth(stats);
                    MainPanelSTIK.HP.Text:SetText(playerContext.params.health);
                    playerContext.hash = tonumber(STIKStatHash(playerContext));
                end
            );
            
            local ClearButton = gui.createDefaultButton({
                parent = settings.parent, content = "0",
                coords = { x = 85, y = settings.coords.y },
                direction = { x = "LEFT", y = "TOP" }
            });
        
            ClearButton:SetScript("OnClick",
                function()
                    stats[settings.stat] = helpers.modifyStat(texts.jobs.clear, stats[settings.stat], playerContext);
                    panel:SetText(texts.stats[settings.stat]..": "..stats[settings.stat]);
                    playerContext.params.health = calculateHealth(stats);
                    MainPanelSTIK.HP.Text:SetText(playerContext.params.health);
                    playerContext.hash = tonumber(STIKStatHash(playerContext));
                end
            );
    
            return panel;
        end,
        registerRoll = function (settings, playerContext)
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
                            head = -armorPenalty.head[armor.head][usingStat],
                            body = -armorPenalty.body[armor.body][usingStat],
                            legs = -armorPenalty.legs[armor.legs][usingStat],
                        };
    
                        local rollWithoutArmor = math.ceil((diceSize * resultSkill)/100);
                        local penaltyOfArmor = penaltyByArmor.head + penaltyByArmor.body + penaltyByArmor.legs;
    
                        local minRoll = rollWithoutArmor - math.ceil(rollWithoutArmor * penaltyOfArmor);
                        local maxRoll = diceSize + rollWithoutArmor;
                        maxRoll = maxRoll - math.ceil(maxRoll * penaltyOfArmor);
    
                        if (maxRoll == 0) then maxRoll = 1; end;
                        if (playerInfo.settings.showRollInfo) then
                            print('Бросок куба: '..texts.stats[usingStat]..' (d'..settings.dice.size..')');
                            print('Приведенный навык: '..math.ceil((diceSize * stats[usingStat])/100));
                            print('Модификатор от размера куба: '..string.sub(1 / penaltyOfDice, 0, 5));
                            print('Модификатор от ОЗ: '..modiferOfHealth);
                            print('Бросок модифицированного навыка (без учета брони): '..rollWithoutArmor);
                            print('Дополнительный модификатор от брони: '..penaltyOfArmor);
                            print('Нижний порог: '..rollWithoutArmor..'-('..rollWithoutArmor..'*'..penaltyOfArmor..') = '..minRoll);
                            print('Верхний порог: ('..diceSize..'+'..rollWithoutArmor..')-(('..diceSize..'+'..rollWithoutArmor..')*'..penaltyOfArmor..') = '..maxRoll);
                        else
                            print('Бросок куба: '..texts.stats[usingStat]..' (d'..settings.dice.size..')');
                        end;

                        if (playerInfo.settings.isEventStarted) then
                            SendAddonMessage("STIK_PLAYER_ANSWER", "roll_dice&"..texts.stats[usingStat].." d"..settings.dice.size, "WHISPER", playerInfo.settings.currentMaster);
                        end;
                        RandomRoll(minRoll, maxRoll);
                    end
                );
            end

            local button = CreateFrame("Button", "rollButton", menu, "UIPanelButtonTemplate");
            setRollView(button);
            setRollScript(button);
        end,
        registerArmor = function (settings, playerContext)
            local armor = playerContext.armor;
            local armorLine = gui.createLine({
                parent = settings.views.parent,
                content = texts.armor[settings.slot]..": "..texts.armorTypes[armor[settings.slot]],
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
        registerArmorType = function (settings, playerContext)
            local armor = playerContext.armor;
            local function setArmorTypeView(view)
                view:SetPoint("TOP", settings.parent, "LEFT", settings.coords.x, settings.coords.y);
                view:SetHeight(23);
                view:SetWidth(70);
                view:SetText(texts.armorTypes[settings.armorType]);
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
                            settings.parent.connectedWith:SetText(texts.armor[slot]..": "..texts.armorTypes[armor[slot]]);
                            playerContext.hash = tonumber(STIKStatHash(playerContext));
                            settings.parent:Hide();
                        end;
                    end
                )
            end
    
            local button = CreateFrame("Button", "rollButton", settings.parent, "UIPanelButtonTemplate");
            setArmorTypeView(button);
            setArmorTypeScript(button);
    
            return button;
        end
    };

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
                    mainPanel.Roll = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = 3 * button.height + 10 },
                        image = "dice_pve", highlight = true,
                        hint = texts.dices,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                            swapPanel = function()
                                swapPanel(DicePanel)
                                if (StatPanel:IsVisible()) then swapPanel(StatPanel); end;
                                if (ArmorPanel:IsVisible()) then swapPanel(ArmorPanel); end;
                                if (SettingsPanel:IsVisible()) then swapPanel(SettingsPanel); end;
                            end
                        },
                    });
                    mainPanel.Stat = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = 2 * button.height },
                        image = "stat",
                        highlight = true,
                        hint = texts.stats.stat,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                            swapPanel = function()
                                swapPanel(StatPanel)
                                if (DicePanel:IsVisible()) then swapPanel(DicePanel); end;
                                if (ArmorPanel:IsVisible()) then swapPanel(ArmorPanel); end;
                                if (SettingsPanel:IsVisible()) then swapPanel(SettingsPanel); end;
                            end
                        },
                    });
                    mainPanel.Armor = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = button.height - 10 },
                        image = "armor",
                        highlight = true,
                        hint = texts.stats.armor,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                            swapPanel = function()
                                swapPanel(ArmorPanel)
                                if (DicePanel:IsVisible()) then swapPanel(DicePanel); end;
                                if (StatPanel:IsVisible()) then swapPanel(StatPanel); end;
                                if (SettingsPanel:IsVisible()) then swapPanel(SettingsPanel); end;
                            end
                        },
                    });
                    mainPanel.HP = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = -20 },
                        image = "hp",
                        highlight = false,
                        hint = texts.stats.hp,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                        },
                    });
                    mainPanel.Shield = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = -button.height - 30 },
                        image = "shield",
                        highlight = false,
                        hint = texts.stats.shield,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                        },
                    });
                    mainPanel.Settings = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = -2 * button.height - 40 },
                        image = "settings",
                        highlight = true,
                        hint = texts.settings.title,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                            swapPanel = function()
                                swapPanel(SettingsPanel);
                                if (DicePanel:IsVisible()) then swapPanel(DicePanel); end;
                                if (StatPanel:IsVisible()) then swapPanel(StatPanel); end;
                                if (ArmorPanel:IsVisible()) then swapPanel(ArmorPanel); end;
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
                    mainPanel.Settings = gui.registerMainButton({
                        parent = mainPanel,
                        coords = { x = 0, y = 0 },
                        image = "settings",
                        highlight = true,
                        hint = texts.settings.title,
                        functions = {
                            showHint = showPanelHint,
                            hideHint = hidePanelHint,
                            swapPanel = function() swapPanel(SettingsPanel); end;
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
                    targetFrame.AttackablePanel:SetWidth(smallestButton.width);
                    targetFrame.AttackablePanel:SetHeight(smallestButton.height);
                    targetFrame.AttackablePanel:SetPoint("RIGHT", targetFrame, "RIGHT", 0, 0);
                    targetFrame.AttackablePanel:SetScript("OnEnter", showPanelHint);
                    targetFrame.AttackablePanel:SetScript("OnLeave", hidePanelHint);
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
                        title = texts.stats.stat,
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
                        statPanel["stat_"..stat.name] = helpers.registerStat({
                            parent = statPanel, stat = stat.name, coords = stat.coords
                        }, playerContext);
                    end;
                end;

                local displayProgressInfo = function (statPanel)
                    local lvlMargin = 0;
                    if (progress.lvl < 10) then lvlMargin = 35; else lvlMargin = 24; end;

                    statPanel.Level = gui.createLine({
                        parent = statPanel,
                        content = texts.stats.level..": "..progress.lvl,
                        coords = { x = lvlMargin, y = - 225 },
                        direction = { x = "LEFT", y = "TOP" }
                    });
                    statPanel.Exp = gui.createLine({
                        parent = statPanel,
                        content = texts.stats.expr..": "..progress.expr.."/"..neededExpr,
                        coords = { x = -90, y = -225 },
                        direction = { x = "LEFT", y = "TOP" }
                    });
                    statPanel.Avl = gui.createLine({
                        parent = statPanel,
                        content = texts.stats.avaliable..": "..params.points,
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
                        title = texts.dices,
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
                        helpers.registerRoll({
                            parent = dicePanel.Menu,
                            coords = dice.coords,
                            dice = dice.info,
                        }, playerContext);
                    end
                end;

                local registerDicesTypes = function (dicePanel)
                    local stats = {
                        { name = 'str', coords = { x = 0, y = 3 * smallButton.height + 30 }, image = 'sword' },
                        { name = 'ag', coords = { x = 0, y = 2 * smallButton.height + 20 }, image = 'dagger' },
                        { name = 'snp', coords = { x = 0, y = smallButton.height + 10 }, image = 'bow' },
                        { name = 'mg', coords = { x = 0, y = 0 }, image = 'magic' },
                        { name = 'body', coords = { x = 0, y = -smallButton.height - 10 }, image = 'strong' },
                        { name = 'moral', coords = { x = 0, y = -2* smallButton.height - 20 }, image = 'fear' },
                        { name = 'luck', coords = { x = 0, y = -3 * smallButton.height - 30 }, image = 'luck' },
                    };

                    for index, stat in pairs(stats) do
                        gui.registerDice({
                            views = { parent = dicePanel, main = MainPanelSTIK, menu = dicePanel.Menu },
                            coords = stat.coords,
                            image = stat.image,
                            hint = texts.stats[stat.name],
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
                        title = texts.stats.armor,
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
                        helpers.registerArmorType({
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
                        helpers.registerArmor({
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
                        title = texts.settings.title,
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
                    checkboxTitle:SetText(texts.settings.parameters);

                    settingsPanel.handlePlotInvites = gui.createCheckbox({
                        parent = settingsPanel,
                        content = texts.settings.getPlotInv,
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
                        content = texts.settings.getEventInv,
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
                        content = texts.settings.showRollInfo,
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
                        content = texts.settings.showDeclineMessages,
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
                            settingsPanel.Title:SetText(texts.settings.activeEventTitle);
                        else
                            settingsPanel.Title:SetText(texts.settings.parts);
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
                        title = texts.settings.plot,
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
                            content = texts.settings.unactivateButton,
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
                            content = texts.settings.removePlot,
                        });
    
                        settingsPanel.SinglePlot.DeleteButton:SetScript("OnClick", function()
                            playerInfo.savedPlots[plotID] = nil;
                            playerInfo[plotID] = nil;
                            settingsPanel.SinglePlot:Hide();
                            settingsPanel.SinglePlot = nil;
                            settingsPanel.RefreshPlotList();
                        end);
    
                        local selectBtnContent = nil;
                        if (plotID == playerInfo.settings.currentPlot) then selectBtnContent = texts.settings.unselectPlot;
                        else selectBtnContent = texts.settings.selectPlot;
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

        if (not(IsHashOK(context))) then
            message(texts.err.hashIsWrong);
            context = {
                hash = 2034843419,
                stats = { str = 0, moral = 0, mg = 0, ag = 0, snp = 0, body = 0 },
                progress = { expr = 0, lvl = 1 },
                flags = { isInBattle = 0 },
                armor = { legs = "nothing", head = "nothing", body = "nothing" },
                params = { shield = 0, points = 100, health = 3 },
            }

            context.params.points = calculatePoints(context.stats, context.progress);
            context.params.health = calculateHealth(context.stats);
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

    currentContext = getPlayerContext(playerInfo);
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
            plot.params.points = calculatePoints(plot.stats, plot.progress);
            print("СИСТЕМА: Очки талантов сброшены!");
        end,
        updateStats = function (plot)
            StatPanel.stat_str:SetText(texts.stats.str..": "..plot.stats.str);
            StatPanel.stat_ag:SetText(texts.stats.ag..": "..plot.stats.ag);
            StatPanel.stat_snp:SetText(texts.stats.snp..": "..plot.stats.snp);
            StatPanel.stat_mg:SetText(texts.stats.mg..": "..plot.stats.mg);
            StatPanel.stat_body:SetText(texts.stats.body..": "..plot.stats.body);
            StatPanel.stat_moral:SetText(texts.stats.moral..": "..plot.stats.moral);
            StatPanel.Level:SetText(texts.stats.level..": "..plot.progress.lvl);
            StatPanel.Exp:SetText(texts.stats.expr..": "..plot.progress.expr.."/"..plot.progress.lvl * 1000);
            StatPanel.Avl:SetText(texts.stats.avaliable..": "..calculatePoints(plot.stats, plot.progress));

            plot.params.health = calculateHealth(plot.stats);
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
                    params.points = calculatePoints(currentPlot.stats, currentPlot.progress);
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
            params.points = calculatePoints(stats, progress);
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
                params.health = calculateHealth(stats);
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

            params.health = calculateHealth(stats);
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
                            points = calculatePoints(playerInfo[meta].stats, playerInfo[meta].progress),
                            health = calculateHealth(playerInfo[meta].stats)
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
                        playerInfo[index].params.health = calculateHealth(playerInfo[index].stats);
                        print('ОЗ были восстановлены по решению ведущего');
                    end;

                    if (tonumber(shouldNilBarrier) == 1) then
                        playerInfo[index].params.shield = 0;
                        print('Барьеры были сброшены по решению ведущего');
                    end;

                    playerInfo[index].hash = STIKStatHash(playerInfo[index]);
        
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
    if (currentPlot) then currentPlot.hash = STIKStatHash(currentPlot); end;
end;

function acceptEventInvite()
    if (SHOULD_ACCEPT_NEXT_INVITE) then
        AcceptGroup();
    end;
end;

function sendRaidRequest()
    if (SHOULD_ACCEPT_NEXT_INVITE) then
        StaticPopup_Hide("PARTY_INVITE");
        SendAddonMessage("STIK_PLAYER_ANSWER", "maybe_raid", "WHISPER", MASTER);
        MASTER = nil;
        SHOULD_ACCEPT_NEXT_INVITE = false;
    end;
end;

function showTargetInfo(selectionType)
    if (not(playerInfo.settings.isEventStarted)) then
        return nil;
    end;

    local currentPlot = playerInfo.settings.currentPlot;
    if (not(playerInfo[currentPlot])) then
        return nil;
    end;

    local flags = playerInfo[currentPlot].flags;

    local targetName = UnitName("target");
    local isTargetExists = not (targetName == nil)
    local isTargetPlayer = UnitPlayerControlled("target")

    if (isTargetExists and not isTargetPlayer) then
        local canBeAttackedMelee = CheckInteractDistance("target", 3);
        if (canBeAttackedMelee) then
            targetInfoFrame.AttackablePanel:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_ok.blp");
            targetInfoFrame.AttackablePanel:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_ok.blp");
            targetInfoFrame.AttackablePanel.hint = texts.canBeAttacked.ok;
        else
            targetInfoFrame.AttackablePanel:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_not.blp");
            targetInfoFrame.AttackablePanel:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_not.blp");
            targetInfoFrame.AttackablePanel.hint = texts.canBeAttacked.notOK;
        end
    
        if (flags.isInBattle == 1) then targetInfoFrame:Show();
        else targetInfoFrame:Hide();
        end;
    else targetInfoFrame:Hide();
    end
end

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