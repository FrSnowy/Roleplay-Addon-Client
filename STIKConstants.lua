--- Наборы констант ---
STIKConstants = {
    button = {
        width = 32,
        height = 32,
    },
    smallButton = {
        width = 26,
        height = 26,
    };
    smallestButton = {
        width = 16,
        height = 16,
    },
    texts = {
        stats = {
            str = "Сила",
            ag = "Ловкость",
            snp = "Точность",
            mg = "Маг. способности",
            body = "Крепость",
            moral = "Мораль",
            luck = "Удача",
        },
        statsMeta = {
            level = "Уровень",
            expr = "Опыт",
            avaliable = "Доступно",
        },
        jobs = {
            add = "add",
            remove = "remove",
            clear = "clear",
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
    },
    mainPanelButtons = {
        {
            name = "Roll",
            image = "dice_pve",
            hint = "Кубы",
            highlight = true,
            showPanel = 'DicePanel',
        },
        {
            name = "Stat",
            image = "stat",
            hint = "Характеристики",
            highlight = true,
            showPanel = 'StatPanel',
        },
        {
            name = "Armor",
            image = "armor",
            hint = "Носимые доспехи",
            highlight = true,
            showPanel = 'ArmorPanel',
        },
        {
            name = "HP",
            image = "hp",
            hint = "Здоровье",
            highlight = false,
            showPanel = nil,
            displayParameter = 'health',
        },
        {
            name = "Shield",
            image = "shield",
            hint = "Барьеры, щиты",
            highlight = false,
            showPanel = nil,
            displayParameter = 'shield',
        },
        {
            name = "Settings",
            image = "settings",
            hint = "Настройки",
            highlight = true,
            showPanel = 'SettingsPanel',
        },
    },
    statsPanelElements = {
        title = "Характеристики",
        chars = {
            { name = 'str' },
            { name = 'ag' },
            { name = 'snp' },
            { name = 'mg' },
            { name = 'body' },
            { name = 'moral' },
        },
        meta = {
            {
                name = 'Level',
                coords = { x = 'BY_MARGIN', y = 35 },
                getContent = function(progress, params, neededExpr)
                    return STIKConstants.texts.statsMeta.level..": "..progress.lvl;
                end,
            },
            {
                name = 'Exp',
                coords = { x = -90, y = 35 },
                getContent = function(progress, params, neededExpr)
                    return STIKConstants.texts.statsMeta.expr..": "..progress.expr.."/"..neededExpr;
                end,
            },
            {
                name = 'Avl',
                coords = { x = -90, y = 55 },
                getContent = function(progress, params, neededExpr)
                    return STIKConstants.texts.statsMeta.avaliable..": "..params.points;
                end,
            },
        },
    },
    dicePanelElements = {
        title = "Кубы",
        elements = {
            { name = 'str', image = 'sword' },
            { name = 'ag', image = 'dagger' },
            { name = 'sng', image = 'bow' },
            { name = 'mg', image = 'magic' },
            { name = 'body', image = 'strong' },
            { name = 'moral', image = 'fear' },
            { name = 'luck', image = 'luck' },
        },
    },
    armorPanelElements = {
        title = "Носимые доспехи",
        types = {
            { name = 'cloth' },
            { name = 'leather' },
            { name = 'mail' },
            { name = 'plate' },
            { name = 'nothing' },
        },
        slots = {
            { name = 'head' },
            { name = 'body' },
            { name = 'legs' },
        }
    },
    rollSizes = {
        { size = 6, penalty = 1.2 },
        { size = 12, penalty = 1.3 },
        { size = 20, penalty = 1.4 },
        { size = 100, penalty = 1.4 },
    },
    armorPenalty = {
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
    },
    settingsPanelElements = {
        title = "Настройки",
        cBoxes = {
            title = "Параметры",
            boxes = {
                {
                    name = "getPlotInvites",
                    content = "Получать приглашения в сюжеты",
                },
                {
                    name = "getEventInvites",
                    content = "Получать приглашения на события",
                },
                {
                    name = "showRollInfo",
                    content = "Показывать информацию о броске",
                },
                {
                    name = "showDeclineMessages",
                    content = "Показывать уведомления об отказе",
                },
            },
        },
        plots = {
            title = {
                active = "Активный сюжет",
                passive = "Сохраненные сюжеты",
            },
        },
        plot = {
            title = "Сюжет",
            buttons = {
                leave = "Покинуть текущее событие",
                remove = "Удалить",
                activate = "Активировать",
                unselect = "Деактивировать",
            }
        },
    },
};