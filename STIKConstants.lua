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
            mg = "Интеллект",
            snp = "Точность",
            cntr = "Концентрация",
            body = "Крепость",
            will = "Воля",
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
        skillTypes = {
            battle = 'Боевые',
            passive = 'Пассивные',
            social = 'Социальные',
        },
        skillMeta = {
            avaliable = "Доступно",
        },
        skills = {
            fight_str = 'Силовой бой',
            fight_ag = 'Ловкий бой',
            shooting = 'Стрельба',
            magica = 'Колдовство',
            holy = 'Свет',
            armor = 'Ношение доспехов',
            controll = 'Самоконтроль',
            melee_weapon = 'Оружие ближнего боя',
            range_weapon = 'Оружие дальнего боя',
            talking = 'Убеждение',
            stealing = 'Воровство',
            hearing = 'Подслушивание',
        },
    },
    mainPanelButtons = {
        {
            name = "Roll",
            image = "dice_pve",
            hint = "Кубы",
            highlight = true,
            showPanel = true,
        },
        {
            name = "Stat",
            image = "stat",
            hint = "Характеристики",
            highlight = true,
            showPanel = true,
        },
        {
            name = "Skill",
            image = "skills",
            hint = "Навыки",
            highlight = true,
            showPanel = true,
        },
        {
            name = "Armor",
            image = "armor",
            hint = "Носимые доспехи",
            highlight = true,
            showPanel = true,
        },
        {
            name = "HP",
            image = "hp",
            hint = "Здоровье",
            highlight = false,
            showPanel = false,
            displayParameter = 'health',
        },
        {
            name = "Shield",
            image = "shield",
            hint = "Барьеры, щиты",
            highlight = false,
            showPanel = false,
            displayParameter = 'shield',
        },
        {
            name = "Settings",
            image = "settings",
            hint = "Настройки",
            highlight = true,
            showPanel = true,
        },
    },
    statsPanelElements = {
        title = "Характеристики",
        chars = {
            { name = 'str' },
            { name = 'ag' },
            { name = 'mg' },
            { name = 'snp' },
            { name = 'cntr' },
            { name = 'body' },
            { name = 'will' },
        },
        meta = {
            {
                name = 'Level',
                coords = { x = 'BY_MARGIN', y = 50 },
                getContent = function(progress, params, neededExpr)
                    return STIKConstants.texts.statsMeta.level..": "..progress.lvl;
                end,
            },
            {
                name = 'Exp',
                coords = { x = -90, y = 50 },
                getContent = function(progress, params, neededExpr)
                    return STIKConstants.texts.statsMeta.expr..": "..progress.expr.."/"..neededExpr;
                end,
            },
            {
                name = 'Avl',
                coords = { x = -90, y = 30 },
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
            { name = 'snp', image = 'bow' },
            { name = 'cntr', image = 'eye' },
            { name = 'mg', image = 'magic' },
            { name = 'body', image = 'strong' },
            { name = 'will', image = 'fear' },
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
            nothing = { str = 0, ag = 0, snp = 0.03, mg = 0.03, body = -0.05, will = -0.05, luck = 0 },
            cloth = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, will = 0, luck = 0 },
            leather = { str = 0, ag = -0.03, snp = -0.05, mg = 0, body = 0, will = 0, luck = 0 },
            mail = { str = 0, ag = -0.05, snp = -0.1,  mg = 0, body = 0.05, will = 0, luck = 0 },
            plate = { str = 0, ag = -0.07, snp = -0.2, mg = 0, body = 0.1, will = 0, luck = 0 },
        },
        body = {
            nothing = { str = 0, ag = 0.1, snp = 0, mg = 0.1, body = -0.3, will = 0, luck = 0 },
            cloth = { str = 0, ag = 0.05, snp = 0, mg = 0, body = -0.1, will = 0, luck = 0 },
            leather = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, will = 0, luck = 0 },
            mail = { str = 0.05, ag = -0.05, snp = -0.05, mg = -0.02, body = 0.05, will = 0, luck = 0 },
            plate = { str = 0.1, ag = -0.2, snp = -0.1, mg = -0.05, body = 0.2, will = 0, luck = 0 },
        },
        legs = {
            nothing = { str = 0, ag = 0.1, snp = 0, mg = 0.1, body = -0.3, will = 0, luck = 0 },
            cloth = { str = 0, ag = 0.05, snp = 0, mg = 0, body = -0.1, will = 0, luck = 0 },
            leather = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, will = 0, luck = 0 },
            mail = { str = 0.05, ag = -0.05, snp = 0, mg = -0.02, body = 0.05, will = 0, luck = 0 },
            plate = { str = 0.1, ag = -0.2, snp = -0.1, mg = -0.05, body = 0.1, will = 0, luck = 0 },
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
    skillTypes = {
        title = "Навыки",
        types = {
            {
                name = 'battle',
                image = 'sword',
            },
            {
                name = 'passive',
                image = 'body',
            },
            {
                name = 'social',
                image = 'eye',
            },
        },
    },
    skills = {
        {
            name = 'battle',
            skills = {
                {
                    name = 'fight_str',
                    stats = { main = 'str', sub = 'body' },
                },
                {
                    name = 'fight_ag',
                    stats = { main = 'ag', sub = 'snp' },
                },
                {
                    name = 'shooting',
                    stats = { main = 'snp', sub = 'cntr' },
                },
                {
                    name = 'magica',
                    stats = { main = 'mg', sub = 'cntr' },
                },
                {
                    name = 'holy',
                    stats = { main = 'will', sub = 'cntr' },
                },
            },
            points = {
                { value = 2, from = { 'str', 'ag', 'mg' } },
                { value = 4, from = { 'snp', 'cntr', 'will' } },
                { value = 8, from = { 'body' } },
            },
        },
        {
            name = 'passive',
            skills = {
                {
                    name = 'armor',
                    stats = { main = 'body', sub = 'str' },
                },
                {
                    name = 'controll',
                    stats = { main = 'will', sub = 'body' },
                },
                {
                    name = 'melee_weapon',
                    stats = { main = 'str', sub = 'mg' },
                },
                {
                    name = 'range_weapon',
                    stats = { main = 'ag', sub = 'snp' },
                },
            },
            points = {
                { value = 2, from = { 'body', 'will' } },
                { value = 4, from = { 'str', 'ag' } },
                { value = 8, from = { 'cntr' } }
            },
        },
        {
            name = 'social',
            skills = {
                {
                    name = 'talking',
                    stats = { main = 'mg', sub = 'will' },
                },
                {
                    name = 'stealing',
                    stats = { main = 'ag', sub = 'cntr' },
                },
                {
                    name = 'hearing',
                    stats = { main = 'cntr', sub = 'mg' },
                },
            },
            points = {
                { value = 2, from = { 'mg', 'cntr' } },
                { value = 4, from = { 'ag', 'will' } },
            },
        },
    },
};