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
    err = {
        battle = "Нельзя изменить значение характеристики в процессе боя",
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

function onAddonReady()
    stats = stats or {
        str = Str or 0,
        ag = Ag or 0,
        snp = Snp or 0,
        mg = Mg or 0,
        body = Body or 0,
        moral = Moral or 0,
    };

    progress = progress or {
        lvl = Lvl or 1,
        expr = Expr or 0,
    };

    params = params or {
        health = calculateHealth(stats),
        shield = 0,
        points = calculatePoints(stats, progress),
    };

    armor = armor or {
        head = 'nothing',
        body = 'nothing',
        legs = 'nothing',
    };

    flags = flags or {
        isInBattle = inBattle or 0,
    };

    neededExpr = progress.lvl * 1000;

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

    local function modifyStat(job, stat)
        if (flags.isInBattle == 0) then
            local was = stat;
            if job == texts.jobs.add then
                if (stat < 60 and stat < 40 + 5 * (progress.lvl - 1) and params.points > 0) then
                    stat = stat + 1;
                end
            end
            if job == texts.jobs.remove then
                if (stat > 0) then
                    stat = stat - 1;
                end
            end
            if job == texts.jobs.clear then
                stat = 0;
            end
            local diff = was - stat;
            params.points = params.points + diff;
            StatText_Avl:SetText(texts.stats.avaliable..": "..params.points);
            return stat;
        else
            print(texts.err.battle)
            return stat;
        end;
    end;

    local function createLine(settings)
        local panel = settings.parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            panel:SetPoint(settings.direction.x, settings.parent, settings.direction.y, settings.coords.x, settings.coords.y);
            panel:SetText(settings.content);
            panel:SetAlpha(0.85);
            panel:Show();

        return panel;
    end

    local function createDefaultButton(settings)
        local function defaultButtonSettings(view)
            view:SetPoint(settings.direction.x, settings.parent, settings.direction.y, settings.coords.x, settings.coords.y);
            view:SetHeight(16);
            view:SetWidth(14);
            view:SetText(settings.content);
            view:RegisterForClicks("AnyUp");
        end

        local button = CreateFrame("Button", "defaultButton", settings.parent, "UIPanelButtonTemplate");
        defaultButtonSettings(button);
        return button;
    end

    local function registerMainButton(settings)

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
    end

    local function registerStat(settings)
        local panel = createLine({
            parent = settings.parent,
            content = texts.stats[settings.stat]..": "..stats[settings.stat],
            coords = settings.coords,
            direction = { x = "LEFT", y = "TOP" }
        });

        local AddButton = createDefaultButton({
            parent = settings.parent, content = "+",
            coords = { x = 45, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });

        AddButton:SetScript("OnClick",
            function()
                stats[settings.stat] = modifyStat(texts.jobs.add, stats[settings.stat]);
                panel:SetText(texts.stats[settings.stat]..": "..stats[settings.stat]);
            end
        );

        local RemoveButton = createDefaultButton({
            parent = settings.parent, content = "-",
            coords = { x = 65, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });
        
        RemoveButton:SetScript("OnClick",
            function()
                stats[settings.stat] = modifyStat(texts.jobs.remove, stats[settings.stat]);
                panel:SetText(texts.stats[settings.stat]..": "..stats[settings.stat]);
            end
        );
        
        local ClearButton = createDefaultButton({
            parent = settings.parent, content = "0",
            coords = { x = 85, y = settings.coords.y },
            direction = { x = "LEFT", y = "TOP" }
        });
    
        ClearButton:SetScript("OnClick",
            function()
                stats[settings.stat] = modifyStat(texts.jobs.clear, stats[settings.stat]);
                panel:SetText(texts.stats[settings.stat]..": "..stats[settings.stat]);
            end
        );

        return panel;
    end

    local function registerDice(settings)

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
    end

    local function registerRoll(settings)
        
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
                    local usingStat = Dice_MENU.stat;
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
                    RandomRoll(minRoll, maxRoll);
                end
            );
        end

        local button = CreateFrame("Button", "rollButton", Dice_MENU, "UIPanelButtonTemplate");
        setRollView(button);
        setRollScript(button);
    end

    local function registerArmor(settings)
        local armorLine = createLine({
            parent = settings.views.parent,
            content = texts.armor[settings.slot]..": "..texts.armorTypes[armor[settings.slot]],
            coords = settings.line.coords,
            direction = settings.line.direction,
        });

        local armorButton = createDefaultButton({
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
    end

    local function registerArmorType(settings)
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
                    local slot = settings.parent.slot;
                    armor[slot] = settings.armorType;
                    settings.parent.connectedWith:SetText(texts.armor[slot]..": "..texts.armorTypes[armor[slot]]);
                end
            )
        end

        local button = CreateFrame("Button", "rollButton", settings.parent, "UIPanelButtonTemplate");
        setArmorTypeView(button);
        setArmorTypeScript(button);

        return button;
    end

    --- Панель цели ---
    targetInfoFrame = CreateFrame("Frame", "targetInfo", TargetFrame);
        targetInfoFrame:EnableMouse();
        targetInfoFrame:SetWidth(TargetFrameHealthBar:GetWidth() + 20);
        targetInfoFrame:SetHeight(50);
        targetInfoFrame:SetBackdropColor(0, 0, 0, 1);
        targetInfoFrame:SetFrameStrata("FULLSCREEN_DIALOG");
        targetInfoFrame:SetPoint("BOTTOMLEFT", TargetFrame, "BOTTOMLEFT", -5, -5);
        targetInfoFrame:SetBackdrop({
	        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	        tile = true, tileSize = 32, edgeSize = 32,
	        insets = { left = 12, right = 12, top = 12, bottom = 12 },
        });

        targetInfoAttackable = CreateFrame("Button", "targetInfoAttackable", targetInfoFrame);
            targetInfoAttackable:EnableMouse(); 
            targetInfoAttackable:SetWidth(smallestButton.width);
            targetInfoAttackable:SetHeight(smallestButton.height);
            targetInfoAttackable:SetPoint("CENTER", targetInfoFrame, "CENTER", 0, 0);
            targetInfoAttackable:SetScript("OnEnter", showPanelHint);
            targetInfoAttackable:SetScript("OnLeave", hidePanelHint);

    --- Основная панель ---
    local MainPanelSTIK = CreateFrame("Frame", "MainPanelSTIK", UIParent);
        MainPanelSTIK:EnableMouse();
        MainPanelSTIK:SetWidth(80);
        MainPanelSTIK:SetHeight(240);
        MainPanelSTIK:SetToplevel(true);
        MainPanelSTIK:SetBackdropColor(0, 0, 0, 1);
        MainPanelSTIK:SetFrameStrata("FULLSCREEN_DIALOG");
        MainPanelSTIK:SetPoint("LEFT", UIParent, "LEFT", -60, 80);
        MainPanelSTIK:SetBackdrop({
	        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	        tile = true, tileSize = 32, edgeSize = 32,
	        insets = { left = 12, right = 12, top = 12, bottom = 12 },
        });
        MainPanelSTIK:SetScript("OnEnter",
            function()
                MainPanelSTIK:SetPoint("LEFT", UIParent, "LEFT", -20, 80);
            end
        );
        MainPanelSTIK:SetScript("OnLeave",
            function()
                if (not MouseIsOver(MainPanelSTIK) and not StatPanel:IsVisible() and not DicesPanel:IsVisible() and not ArmorPanel:IsVisible()) then
                    MainPanelSTIK:SetPoint("LEFT", UIParent, "LEFT", -60, 80);
                end; 
            end
        );


    --- Кнопки на основной панели ---
    local MainPanel_Rolls = registerMainButton({
        parent = MainPanelSTIK,
        coords = { x = 0, y = 2 * button.height + 20 },
        image = "dice_pve",
        highlight = true,
        hint = texts.dices,
        functions = {
            showHint = showPanelHint,
            hideHint = hidePanelHint,
            swapPanel = function()
                swapPanel(DicesPanel)
                if (StatPanel:IsVisible()) then swapPanel(StatPanel); end;
                if (ArmorPanel:IsVisible()) then swapPanel(ArmorPanel); end;
            end
        },
    });

    local MainPanel_Stats = registerMainButton({
        parent = MainPanelSTIK,
        coords = { x = 0, y = button.height + 10 },
        image = "stat",
        highlight = true,
        hint = texts.stats.stat,
        functions = {
            showHint = showPanelHint,
            hideHint = hidePanelHint,
            swapPanel = function()
                swapPanel(StatPanel)
                if (DicesPanel:IsVisible()) then swapPanel(DicesPanel); end;
                if (ArmorPanel:IsVisible()) then swapPanel(ArmorPanel); end;
            end
        },
    });

    local MainPanel_Armor = registerMainButton({
        parent = MainPanelSTIK,
        coords = { x = 0, y = 0 },
        image = "armor",
        highlight = true,
        hint = texts.stats.armor,
        functions = {
            showHint = showPanelHint,
            hideHint = hidePanelHint,
            swapPanel = function()
                swapPanel(ArmorPanel)
                if (DicesPanel:IsVisible()) then swapPanel(DicesPanel); end;
                if (StatPanel:IsVisible()) then swapPanel(StatPanel); end;
            end
        },
    });

    local MainPanel_HP = registerMainButton({
        parent = MainPanelSTIK,
        coords = { x = 0, y = -button.height - 10 },
        image = "hp",
        highlight = false,
        hint = texts.stats.hp,
        functions = {
            showHint = showPanelHint,
            hideHint = hidePanelHint,
        },
    });
    local MainPanel_Shield = registerMainButton({
        parent = MainPanelSTIK,
        coords = { x = 0, y = -2 * button.height - 20 },
        image = "shield",
        highlight = false,
        hint = texts.stats.shield,
        functions = {
            showHint = showPanelHint,
            hideHint = hidePanelHint,
        },
    });

    HP_TEXT = createLine({
        parent = MainPanel_HP,
        content = params.health,
        coords = { x = 0, y = 0 },
        direction = { x = "CENTER", y = "CENTER" }
    });

    SHIELD_TEXT = createLine({
        parent = MainPanel_Shield,
        content = params.shield,
        coords = { x = 0, y = 0 },
        direction = { x = "CENTER", y = "CENTER" }
    });

    --- Статы ---

    StatPanel = CreateFrame("Frame", "StatPanel", MainPanelSTIK);
        StatPanel:Hide();
        StatPanel:SetWidth(240);
        StatPanel:SetHeight(260);
        StatPanel:SetBackdropColor(40, 40, 40, 1);
        StatPanel:SetFrameStrata("FULLSCREEN_DIALOG");
        StatPanel:SetPoint("LEFT", MainPanelSTIK, "LEFT", 70, 0);
        StatPanel:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 },
        });

        local StatTitle = StatPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            StatTitle:SetPoint("CENTER", StatPanel, "TOP", 0, -25);
            StatTitle:SetText(texts.stats.stat);
            StatTitle:SetAlpha(0.85);
            StatTitle:Show();

        StatText_STR = registerStat({
            parent = StatPanel, stat = "str",
            coords = { x = -90, y = -50 },
        });

        StatText_AG = registerStat({
            parent = StatPanel, stat = "ag",
            coords = { x = -90, y = -75 },
        });

        StatText_SNP = registerStat({
            parent = StatPanel, stat = "snp",
            coords = { x = -90, y = -100 },
        });

        StatText_MG = registerStat({
            parent = StatPanel, stat = "mg",
            coords = { x = -90, y = -125 },
        });

        StatText_BODY = registerStat({
            parent = StatPanel, stat = "body",
            coords = { x = -90, y = -150 },
        });

        StatText_MORAL = registerStat({
            parent = StatPanel, stat = "moral",
            coords = { x = -90, y = -175 },
        });
        
        local lvlMargin = 0;

        if (progress.lvl < 10) then lvlMargin = 35;
        else lvlMargin = 24;
        end;

        StatText_Level = createLine({
            parent = StatPanel,
            content = texts.stats.level..": "..progress.lvl,
            coords = { x = lvlMargin, y = - 225 },
            direction = { x = "LEFT", y = "TOP" }
        });
        StatText_Exp = createLine({
            parent = StatPanel,
            content = texts.stats.expr..": "..progress.expr.."/"..neededExpr,
            coords = { x = -90, y = -225 },
            direction = { x = "LEFT", y = "TOP" }
        });
        StatText_Avl = createLine({
            parent = StatPanel,
            content = texts.stats.avaliable..": "..params.points,
            coords = { x = -90, y = -205 },
            direction = { x = "LEFT", y = "TOP" }
        });
    
    --- Панель кубов ---

    DicesPanel = CreateFrame("Frame", "DicesPanel", MainPanelSTIK);
        DicesPanel:Hide();
        DicesPanel:SetWidth(80);
        DicesPanel:SetHeight(320);
        DicesPanel:SetBackdropColor(40, 40, 40, 1);
        DicesPanel:SetFrameStrata("FULLSCREEN_DIALOG");
        DicesPanel:SetPoint("LEFT", MainPanelSTIK, "LEFT", 70, 0);
        DicesPanel:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 12, right = 12, top = 12, bottom = 12 },
        });

    local DicesTitle = createLine({
        parent = DicesPanel,
        content = texts.dices,
        coords = { x = 0, y = - 25 },
        direction = { x = "CENTER", y = "TOP" }
    });

    Dice_MENU = CreateFrame("Frame", "PvEDiceSTRMenu", DicesPanel);
        Dice_MENU:Hide();
        Dice_MENU:SetWidth(236);
        Dice_MENU:SetHeight(60);
        Dice_MENU:SetBackdropColor(40, 40, 40, 1);
        Dice_MENU:SetFrameStrata("FULLSCREEN_DIALOG");
        Dice_MENU:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 },
        });

        local Dice_d6 = registerRoll({
            parent = Dice_MENU,
            coords = { x = 36, y = 12 },
            dice = { size = 6, penalty = 1.2 },
        });

        local Dice_d12 = registerRoll({
            parent = Dice_MENU,
            coords = { x = 90, y = 12 },
            dice = { size = 12, penalty = 1.3 },
        });

        local Dice_d20 = registerRoll({
            parent = Dice_MENU,
            coords = { x = 144, y = 12 },
            dice = { size = 20, penalty = 1.4 },
        });

        local Dice_d100 = registerRoll({
            parent = Dice_MENU,
            coords = { x = 198, y = 12 },
            dice = { size = 100, penalty = 1.4 },
        });

    local Dice_STR = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = { x = 0, y = 3 * smallButton.height + 30 },
        image = "sword",
        hint = texts.stats.str,
        stat = 'str',
    });

    local Dice_AGL = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = { x = 0, y = 2 * smallButton.height + 20 },
        image = "dagger",
        hint = texts.stats.ag,
        stat = 'ag',
    });

    local Dice_SNP = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = {x = 0, y = smallButton.height + 10 },
        image = "bow",
        hint = texts.stats.snp,
        stat = 'snp',
    });

    local Dice_MGK = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = { x = 0, y = 0 },
        image = "magic",
        hint = texts.stats.mg,
        stat = 'mg',
    });

    local Dice_Body = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = { x = 0, y = -smallButton.height - 10 },
        image = "strong",
        hint = texts.stats.body,
        stat = 'body',
    });

    local Dice_Moral = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = { x = 0, y = -2* smallButton.height - 20 },
        image = "fear",
        hint = texts.stats.moral,
        stat = 'moral',
    });

    local Dice_Luck = registerDice({
        views = { parent = DicesPanel, main = MainPanelSTIK, menu = Dice_MENU },
        coords = { x = 0, y = -3 * smallButton.height - 30 },
        image = "luck",
        hint = texts.stats.luck,
        stat = 'luck',
    });
    
    --- Панель брони ---

    local function defaultArmorSettings(frame, hint, x, y, icon)
        frame:SetSize(button.width, button.height);
        frame:SetPoint("CENTER", ArmorPanel, "CENTER", x, y);
        frame:RegisterForClicks("AnyUp");
        frame:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..icon..".blp");
        frame:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\"..icon..".blp");
        frame:Show()
        frame.hint = hint;
        frame:SetScript("OnEnter", showPanelHint);
        frame:SetScript("OnLeave", hidePanelHint);
    end

    ArmorPanel = CreateFrame("Frame", "ArmorPanel", MainPanelSTIK);
        ArmorPanel:Hide();
        ArmorPanel:SetWidth(180);
        ArmorPanel:SetHeight(235);
        ArmorPanel:SetBackdropColor(40, 40, 40, 1);
        ArmorPanel:SetFrameStrata("FULLSCREEN_DIALOG");
        ArmorPanel:SetPoint("LEFT", MainPanelSTIK, "LEFT", 70, 0);
        ArmorPanel:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 },
        });

        local Armor_Title = createLine({
            parent = ArmorPanel,
            content = texts.stats.armor,
            coords = { x = 0, y = -25 },
            direction = { x = "CENTER", y = "TOP" }
        });

        Armor_MENU = CreateFrame("Frame", "ArmorMenu", ArmorPanel);
            Armor_MENU:SetPoint("LEFT", ArmorPanel, "TOP", 70, -60);
            Armor_MENU:SetWidth(430);
            Armor_MENU:SetHeight(60);
            Armor_MENU:SetBackdropColor(40, 40, 40, 1);
            Armor_MENU:SetFrameStrata("FULLSCREEN_DIALOG");
            Armor_MENU:Hide();
            Armor_MENU:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                tile = true, tileSize = 32, edgeSize = 32,
                insets = { left = 8, right = 8, top = 8, bottom = 8 },
            });

            Armor_MENU.slot = nil;

            local Armor_Cloth = registerArmorType({
                parent = Armor_MENU,
                coords = { x = 50, y = 12 },
                armorType = 'cloth',
            });

            local Armor_Leather = registerArmorType({
                parent = Armor_MENU,
                coords = { x = 130, y = 12 },
                armorType = 'leather',
            });

            local Armor_Mail = registerArmorType({
                parent = Armor_MENU,
                coords = { x = 210, y = 12 },
                armorType = 'mail',
            });

            local Armor_Plate = registerArmorType({
                parent = Armor_MENU,
                coords = { x = 290, y = 12 },
                armorType = 'plate',
            });

            local Armor_Nothing = registerArmorType({
                parent = Armor_MENU,
                coords = { x = 370, y = 12 },
                armorType = 'nothing',
            });

        local Armor_HELM = registerArmor({
            views = { parent = ArmorPanel, armorMenu = Armor_MENU },
            slot = 'head',
            line = {
                coords = { x = -70, y = -60 },
                direction = { x = "LEFT", y = "TOP" },
            },
            button = {
                coords = { x = 70, y = -60 },
                direction = { x = "RIGHT", y = "TOP" }
            },
        });

        local Armor_BODY = registerArmor({
            views = { parent = ArmorPanel, armorMenu = Armor_MENU },
            slot = 'body',
            line = {
                content = texts.armor.body..": "..armor.body,
                coords = { x = -70, y = -90 },
                direction = { x = "LEFT", y = "TOP" },
            },
            button = {
                coords = { x = 70, y = -90 },
                direction = { x = "RIGHT", y = "TOP" }
            }
        });

        local Armor_LEGS = registerArmor({
            views = { parent = ArmorPanel, armorMenu = Armor_MENU },
            slot = 'legs',
            line = {
                content = texts.armor.legs..": "..armor.legs,
                coords = { x = -70, y = -120 },
                direction = { x = "LEFT", y = "TOP" },
            },
            button = {
                coords = { x = 70, y = -120 },
                direction = { x = "RIGHT", y = "TOP" }
            }
        });
end;

function onDMSaySomething(prefix, msg, tp, sender)
    if (not(prefix == 'STIK_SYSTEM')) then return end;
    local COMMAND, VALUE = strsplit('&', msg);

    local commandConnector = {
        give_exp = function(experience)
            local experience = tonumber(experience, 10);
            if (experience >= 0) then
                print("СИСТЕМА: Вы получили "..experience.." exp");
                progress.expr = progress.expr + experience;
                if (progress.expr >= neededExpr) then
                    progress.lvl = progress.lvl + 1;
                    progress.expr = progress.expr - neededExpr;
                    neededExpr = progress.lvl * 1000;
                    params.points = calculatePoints(stats, progress);
                    print("СИСТЕМА: Ваш уровень был повышен!");
                end
            else
                print("СИСТЕМА: Вы потеряли "..math.abs(experience).." exp");
                progress.expr = progress.expr + experience;
                if (progress.expr < 0) then
                    if (progress.lvl > 1) then
                        local diff = math.abs(progress.expr);
                        progress.lvl = progress.lvl - 1;
                        neededExpr = progress.lvl * 1000;
                        progress.expr = neededExpr - diff;
                        clearTalantes();
                        print("СИСТЕМА: Ваш уровень был понижен!");
                    else
                        progress.expr = 0;
                    end;
                end;
            end;
            updateStats();
        end,
        set_level = function(level)
            local level = tonumber(level, 10);
            local shouldClearParams = level < progress.lvl;
            progress.lvl = level;
            print('СИСТЕМА: Уровень установлен на '..progress.lvl);
            neededExpr = progress.lvl * 1000;
            progress.expr = 0;
            if shouldClearParams then clearTalantes(); end;
            updateStats();
        end,
        get_info = function(DMName)
            SendChatMessage('Версия: 1.0.0', "WHISPER", nil, DMName);
            SendChatMessage(texts.stats.str..": "..stats.str.." "..texts.stats.ag..": "..stats.ag.." "..texts.stats.snp..": "..stats.snp, "WHISPER", nil, DMName);
            SendChatMessage(texts.stats.mg..": "..stats.mg.." "..texts.stats.body..": "..stats.body.." "..texts.stats.moral..": "..stats.moral, "WHISPER", nil, DMName);
            SendChatMessage(texts.stats.level..": "..progress.lvl.." "..texts.stats.expr..": "..progress.expr.." "..texts.stats.avaliable..": "..params.points, "WHISPER", nil, DMName);
            SendChatMessage("ХП: "..params.health, "WHISPER", nil, DMName);
            SendChatMessage("Щит: "..params.shield, "WHISPER", nil, DMName);
            if (flags.isInBattle == 0) then
                SendChatMessage("Не в бою", "WHISPER", nil, DMName);
            else
                SendChatMessage("В бою", "WHISPER", nil, DMName);
            end;
        end,
        mod_hp = function(health)
            local health = tonumber(health, 10);
            if (params.health + health <= 3 + math.floor(stats.body / 20)) then
                params.health = params.health + health;
                if (params.health < 0) then params.health = 0; end;
                HP_TEXT:SetText(params.health);
                if (health < 0) then 
                    print('Вы потеряли '..math.abs(health)..' ХП')
                else
                    print('Вы получили '..math.abs(health)..' ХП')
                end;
                if (params.health == 0) then 
                    print('Вы не можете продолжать бой');
                    SendChatMessage('(( Выведен из боя ))');
                end;
            else
                print ('Вам пытались выдать ' ..math.abs(health).. ' ХП, но ваше максимальное значение - ' ..3 + math.floor(stats.body / 20));
                print ('Значение здоровья было установлено в макс., лишние ХП - уничтожены');
                params.health = calculateHealth(stats);
                HP_TEXT:SetText(params.health);
            end;
        end,
        change_battle_state = function(battleState)
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
            params.health = calculateHealth(stats);
            print('Ваши ХП были восстановлены');
            HP_TEXT:SetText(params.health);
        end,
        play_music = function(musicName)
            local _type, number = strsplit("_", musicName);
            PlayMusic("Interface\\AddOns\\STIKSystem\\MUSIC\\".._type.."\\"..number..".mp3");
        end,
        stop_music = function(musicName)
            StopMusic();
        end,
        mod_barrier = function(barrierScore)
            local score = tonumber(barrierScore, 10);
            params.shield = params.shield + score;
            if (params.shield < 0) then params.shield = 0; end;
            SHIELD_TEXT:SetText(params.shield);
            if (score < 0) then 
                print('Вы потеряли '..math.abs(score)..' пункт(-ов) барьера')
            else
                print('Вы получили '..math.abs(score)..' пункт(-ов) барьера')
            end;
            if (params.shield == 0) then print('Вы лишились барьера!'); end;
        end,
        damage = function (points)
            local dmg = tonumber(points, 10);
            if (params.shield >= dmg) then
                params.shield = params.shield - dmg;
                print('Вы получили '..dmg.. ' урона. Он был поглощён щитом');
                SHIELD_TEXT:SetText(params.shield);
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
                HP_TEXT:SetText(params.health);
                SHIELD_TEXT:SetText(params.shield);
            elseif (params.shield == 0 and params.health >= 0) then
                params.health = params.health - math.abs(dmg);
                print('Вы получили '..dmg..' урона.');
                if (params.health < 0) then params.health = 0; end;
                if (params.health == 0) then 
                    print('Вы не можете продолжать бой');
                    SendChatMessage('(( Выведен из боя ))');
                end;
                HP_TEXT:SetText(params.health);
            end;
        end,
        kick = function()
            ForceQuit();
        end,
        play_effect = function(effect)
            local _type, number = strsplit("_", effect);
            PlaySoundFile("Interface\\AddOns\\STIKSystem\\EFFECTS\\".._type.."\\"..number..".mp3", "Ambience")
        end,
        invite_to_plot = function(plotInfo)
            if (PopUpFrame and PopUpFrame:IsVisible()) then
                PopUpFrame:Hide();
            end;
            PlaySound("LEVELUPSOUND", "SFX");

            local meta, title, description = strsplit('~', plotInfo);
            local master = strsplit('-', meta);

            PopUpFrame = CreateFrame("Frame", "PopUpFrame", UIParent);
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
    };

    commandConnector[COMMAND](VALUE);
end;

function clearTalantes()
    stats.str = 0;
    stats.ag = 0;
    stats.snp = 0;
    stats.mg = 0;
    stats.body = 0;
    stats.moral = 0;
    params.points = calculatePoints(stats, progress);
    print("СИСТЕМА: Очки талантов сброшены!");
end;

function updateStats()
    StatText_STR:SetText(texts.stats.str..": "..stats.str);
    StatText_AG:SetText(texts.stats.ag..": "..stats.ag);
    StatText_SNP:SetText(texts.stats.snp..": "..stats.snp);
    StatText_MG:SetText(texts.stats.mg..": "..stats.mg);
    StatText_BODY:SetText(texts.stats.body..": "..stats.body);
    StatText_MORAL:SetText(texts.stats.moral..": "..stats.moral);
    StatText_Level:SetText(texts.stats.level..": "..progress.lvl);
    StatText_Exp:SetText(texts.stats.expr..": "..progress.expr.."/"..neededExpr);
    StatText_Avl:SetText(texts.stats.avaliable..": "..calculatePoints(stats, progress));

    params.health = calculateHealth(stats);
    HP_TEXT:SetText(params.health);
end

function showTargetInfo(selectionType)
    local targetName = UnitName("target");
    local isTargetExists = not (targetName == nil)
    local isTargetPlayer = UnitPlayerControlled("target")

    if (isTargetExists and not isTargetPlayer) then
        local canBeAttackedMelee = CheckInteractDistance("target", 3);
        if (canBeAttackedMelee) then
            targetInfoAttackable:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_ok.blp");
            targetInfoAttackable:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_ok.blp");
            targetInfoAttackable.hint = texts.canBeAttacked.ok;
        else
            targetInfoAttackable:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_not.blp");
            targetInfoAttackable:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_not.blp");
            targetInfoAttackable.hint = texts.canBeAttacked.notOK;
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
	STIKButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",STIKMiniMapButtonPosition.x,STIKMiniMapButtonPosition.y)
end

function STIK_Minimap_Update()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 
	ypos = ypos/UIParent:GetScale()-ymin-70

	STIKMiniMapButtonPosition.locationAngle = math.deg(math.atan2(ypos,xpos))
	STIKMiniMapButton_Reposition()
end