-- Другие функции --

STIKSharedFunctions = {
    calculatePoints = function (stats, progress)
        return 100 + 5 * (progress.lvl - 1) - (stats.str + stats.ag + stats.snp + stats.mg + stats.body + stats.moral);
    end,
    calculateHealth = function (stats)
        return 3 + math.floor(stats.body / 20);
    end,
    getPlayerContext = function (playerInfo)
        if (playerInfo.settings.currentPlot == nil) then
            return nil;
        else
            return playerInfo[playerInfo.settings.currentPlot];
        end;
    end,
    statString = function (playerContext)
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
    
        return statString..flagsString..armorString..progressString..paramsString;
    end,
    skillString = function(playerContext)
        local getDictionaryAsString = function (dict)
            local dictString = "";
            for key, value in pairs(dict) do
                dictString = dictString.."&"..key.."="..value
            end;
    
            return dictString;
        end;

        local battleString = getDictionaryAsString(STIKSortTable(playerContext.skills.battle));
        local passiveString = getDictionaryAsString(STIKSortTable(playerContext.skills.passive));
        local socialString = getDictionaryAsString(STIKSortTable(playerContext.skills.social));

        local summaryString = battleString..passiveString..socialString;
        return summaryString;
    end,
    calculateHash = function(playerContext)
        local strOfStats = STIKSharedFunctions.statString(playerContext);
        local strOfSkills = STIKSharedFunctions.skillString(playerContext);
        return STIKStringHash(strOfStats..strOfSkills);
    end,
    isHashOK = function (playerContext)
        local actualHash = STIKSharedFunctions.calculateHash(playerContext);
        local hashOfCtx = playerContext.hash;
        return tonumber(actualHash) == tonumber(hashOfCtx);
    end,
    modifyStat = function (job, stat, playerContext)
        local flags = playerContext.flags;
        local progress = playerContext.progress;
        local params = playerContext.params;

        local isInBattle = not(flags.isInBattle == 0);
        
        if (isInBattle) then
            print(STIKConstants.texts.err.battle);
            return stat;
        end;

        local prevStatValue = stat;
        local jobConnector = {
            [STIKConstants.texts.jobs.add] = function()
                if (stat < 40 + 5 * (progress.lvl - 1) and params.points > 0) then return stat + 1;
                else return stat; end;
            end,
            [STIKConstants.texts.jobs.remove] = function()
                if (stat > 0) then return stat - 1;
                else return 0; end;
            end,
            [STIKConstants.texts.jobs.clear] = function()
                return 0;
            end,
        };

        stat = jobConnector[job]();
        params.points = params.points - (stat - prevStatValue);
        StatPanel.Avl:SetText(STIKConstants.texts.statsMeta.avaliable..": "..params.points);
        return stat;
    end,
    modifySkill = function (job, category, name, textView, playerContext)
        local skills = playerContext.skills;
        local flags = playerContext.flags;
        local points = MainPanelSTIK.Skills[category].Points.GetAvailablePoints();
        local progress = playerContext.progress;

        local isInBattle = not(flags.isInBattle == 0);
        
        if (isInBattle) then
            print(STIKConstants.texts.err.battle);
            return stat;
        end;

        local currentValue = skills[category][name];

        local jobConnector = {
            [STIKConstants.texts.jobs.add] = function()
                if (currentValue < 40 + 5 * (progress.lvl - 1) and points > 0) then return currentValue + 1;
                else return currentValue; end;
            end,
            [STIKConstants.texts.jobs.remove] = function()
                if (currentValue > 0) then return currentValue - 1;
                else return 0; end;
            end,
            [STIKConstants.texts.jobs.clear] = function()
                return 0;
            end,
        };

        currentValue = jobConnector[job]();
        skills[category][name] = currentValue;
        textView:SetText(STIKConstants.texts.skills[name]..": "..skills[category][name]);
        MainPanelSTIK.Skills[category].Points.RecalcPoints();
    end,
    preloadChecks = function(context)
        if (context == nil) then return 'NO_PLOT_SELECTED' end;

        if (not(STIKSharedFunctions.isHashOK(context))) then
            message(STIKConstants.texts.err.hashIsWrong);
            context = {
                hash = 1423957313,
                stats = { str = 0, moral = 0, mg = 0, ag = 0, snp = 0, body = 0 },
                skills = {
                    battle = {
                        nature = 0, shadows = 0, shooting = 0, elems = 0, magica = 0, fight_str = 0, holy = 0, fight_ag = 0,
                    },
                    social = {
                        hearing = 0, stealing = 0, hacking = 0, stealth = 0, profession = 0, talking = 0,
                    },
                    passive = {
                        hacking = 0, range_weapon = 0, armor = 0, stealth = 0, controll = 0, melee_weapon = 0,
                    },
                },
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
};