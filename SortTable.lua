-- Сортировка таблиц по индексу --

function STIKSortTable(dict)
    local keys = { };
    for key in pairs(dict) do table.insert(keys, key) end;
    table.sort(keys)

    local sortedDict = { };
    for _, key in ipairs(keys) do sortedDict[key] = dict[key] end;
    return sortedDict;
end;