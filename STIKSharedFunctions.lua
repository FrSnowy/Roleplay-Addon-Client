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
    statHash = function (playerContext)
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
    end,
    isHashOK = function (playerContext)
        local hashofStats = STIKSharedFunctions.statHash(playerContext);
        local hashOfCtx = playerContext.hash;
        return tonumber(hashofStats) == tonumber(hashOfCtx);
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
        StatPanel.Avl:SetText(STIKConstants.texts.stats.avaliable..": "..params.points);
        return stat;
    end,
};