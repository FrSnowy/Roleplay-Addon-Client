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
};