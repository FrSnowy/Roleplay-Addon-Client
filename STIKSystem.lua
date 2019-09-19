function onAddonReady()
    gui = SnowGUI();

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
    local addonStatus = STIKSharedFunctions.preloadChecks(currentContext);
    local generator = STIKViewGenerator();

    local addonStatusConnector = {
        OK = function()
            --- Основная панель ---
            MainPanelSTIK = generator.mainPanel(false);
            --- Панель цели ---
            targetInfoFrame = generator.targetInfo();
            --- Статы ---
            StatPanel = generator.statPanel(MainPanelSTIK);
            --- Навыки ---
            SkillPanel = generator.skillPanel(MainPanelSTIK);
            --- Панель кубов ---
            DicePanel = generator.dicePanel(MainPanelSTIK);
            --- Панель брони ---
            ArmorPanel = generator.armorPanel(MainPanelSTIK);
            --- Панель настроек ---
            SettingsPanel = generator.settingsPanel(MainPanelSTIK);
        end,
        NO_PLOT_SELECTED = function()
            --- Основная панель (только настройки) ---
            MainPanelSTIK = generator.mainPanel(true);
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
            local sortedStats = STIKSortTable(STIKConstants.statsPanelElements.chars);
            for i = 1, #sortedStats do
                local currentStat = sortedStats[i].name;
                plot.stats[currentStat] = 0;
            end;

            local sortedSkills = STIKSortTable(STIKConstants.skillTypes.types);
            for i = 1, #sortedSkills do
                local currentSkill = sortedSkills[i].name;
                MainPanelSTIK.Skills[currentSkill].Points.RecalcPoints();
            end;

            plot.params.points = STIKSharedFunctions.calculatePoints(plot.stats, plot.progress);
            print("СИСТЕМА: Очки характеристик сброшены!");
        end,
        updateStats = function (plot)
            local sortedStats = STIKSortTable(STIKConstants.statsPanelElements.chars);
            for i = 1, #sortedStats do
                local currentStat = sortedStats[i].name;
                local identifier = 'stat_'..currentStat;
                StatPanel[identifier]:SetText(STIKConstants.texts.stats[currentStat]..": "..plot.stats[currentStat]);
            end;
            StatPanel.Level:SetText(STIKConstants.texts.statsMeta.level..": "..plot.progress.lvl);
            StatPanel.Exp:SetText(STIKConstants.texts.statsMeta.expr..": "..plot.progress.expr.."/"..plot.progress.lvl * 1000);
            StatPanel.Avl:SetText(STIKConstants.texts.statsMeta.avaliable..": "..STIKSharedFunctions.calculatePoints(plot.stats, plot.progress));

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
            currentPlot.hash = tonumber(STIKSharedFunctions.calculateHash(currentPlot));
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
            if shouldClearParams then
                commandHelpers.clearTalantes(currentPlot);
            end;
            commandHelpers.updateStats(currentPlot);
            currentPlot.hash = tonumber(STIKSharedFunctions.calculateHash(currentPlot));
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
                        playerInfo[meta].skills = { };
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