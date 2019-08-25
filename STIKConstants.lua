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
            ptnc = "Терпение",
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
            battle = 'Активные',
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
            magica = 'Чаротворство',
            shadows = 'Колдовство',
            holy = 'Свет',
            elems = 'Стихии',
            nature = 'Природа',
            armor = 'Ношение доспехов',
            controll = 'Самоконтроль',
            melee_weapon = 'Оружие ближнего боя',
            range_weapon = 'Оружие дальнего боя',
            hacking = 'Взлом замков',
            stealth = 'Незаметность',
            talking = 'Убеждение',
            stealing = 'Воровство',
            hearing = 'Подслушивание',
            profession = 'Профессии',
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
            { name = 'ptnc' },
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
            { name = 'ptnc', image = 'fear' },
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
            nothing = { str = 0, ag = 0, snp = 0.03, mg = 0.03, body = -0.05, will = -0.05, ptnc = 0, luck = 0 },
            cloth = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, will = 0, ptnc = 0, luck = 0 },
            leather = { str = 0, ag = -0.03, snp = -0.05, mg = 0, body = 0, will = 0, ptnc = 0, luck = 0 },
            mail = { str = 0, ag = -0.05, snp = -0.1,  mg = 0, body = 0.05, will = 0, ptnc = 0, luck = 0 },
            plate = { str = 0, ag = -0.07, snp = -0.2, mg = 0, body = 0.1, will = 0, ptnc = 0, luck = 0 },
        },
        body = {
            nothing = { str = 0, ag = 0.1, snp = 0, mg = 0.1, body = -0.3, will = 0, ptnc = 0, luck = 0 },
            cloth = { str = 0, ag = 0.05, snp = 0, mg = 0, body = -0.1, will = 0, ptnc = 0, luck = 0 },
            leather = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, will = 0, ptnc = 0, luck = 0 },
            mail = { str = 0.05, ag = -0.05, snp = -0.05, mg = -0.02, body = 0.05, will = 0, ptnc = 0, luck = 0 },
            plate = { str = 0.1, ag = -0.2, snp = -0.1, mg = -0.05, body = 0.2, will = 0, ptnc = 0, luck = 0 },
        },
        legs = {
            nothing = { str = 0, ag = 0.1, snp = 0, mg = 0.1, body = -0.3, will = 0, ptnc = 0, luck = 0 },
            cloth = { str = 0, ag = 0.05, snp = 0, mg = 0, body = -0.1, will = 0, ptnc = 0, luck = 0 },
            leather = { str = 0, ag = 0, snp = 0, mg = 0, body = 0, will = 0, ptnc = 0, luck = 0 },
            mail = { str = 0.05, ag = -0.05, snp = 0, mg = -0.02, body = 0.05, will = 0, ptnc = 0, luck = 0 },
            plate = { str = 0.1, ag = -0.2, snp = -0.1, mg = -0.05, body = 0.1, will = 0, ptnc = 0, luck = 0 },
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
                    stats = { main = 'str', sub = 'body', third = 'snp' },
                },
                {
                    name = 'fight_ag',
                    stats = { main = 'ag', sub = 'snp', third = 'str' },
                },
                {
                    name = 'shooting',
                    stats = { main = 'snp', sub = 'cntr', third = 'ptnc' },
                },
                {
                    name = 'magica',
                    stats = { main = 'mg', sub = 'cntr', third = 'will' },
                },
                {
                    name = 'shadows',
                    stats = { main = 'mg', sub = 'cntr', third = 'body' },
                },
                {
                    name = 'holy',
                    stats = { main = 'will', sub = 'ptnc', third = 'cntr' },
                },
                {
                    name = 'elems',
                    stats = { main = 'will', sub = 'cntr', third = 'ptnc' }
                },
                {
                    name = 'nature',
                    stats = { main = 'ptnc', sub = 'cntr', third = 'will' }
                }
            },
            points = {
                { value = 1.25, from = { 'str', 'ag', 'mg' } },
                { value = 2.5, from = { 'snp', 'cntr', 'will' } },
                { value = 4.75, from = { 'body', 'ptnc' } },
            },
        },
        {
            name = 'passive',
            skills = {
                {
                    name = 'armor',
                    stats = { main = 'body', sub = 'str', third = 'ag' },
                },
                {
                    name = 'controll',
                    stats = { main = 'will', sub = 'mg', third = 'str' },
                },
                {
                    name = 'melee_weapon',
                    stats = { main = 'str', sub = 'mg', third = 'body' },
                },
                {
                    name = 'range_weapon',
                    stats = { main = 'ag', sub = 'snp', third = 'ptnc' },
                },
                {
                    name = 'hacking',
                    stats = { main = 'ag', sub = 'cntr', third = 'mg' }
                },
                {
                    name = 'stealth',
                    stats = { main = 'mg', sub = 'ag', third = 'ptnc' }
                },
            },
            points = {
                { value = 1.25, from = { 'body', 'will', 'ag' } },
                { value = 2.5, from = { 'str', 'ptnc' } },
                { value = 4.75, from = { 'cntr' } }
            },
        },
        {
            name = 'social',
            skills = {
                {
                    name = 'talking',
                    stats = { main = 'mg', sub = 'will', third = 'str' },
                },
                {
                    name = 'stealing',
                    stats = { main = 'ag', sub = 'cntr', third = 'snp' },
                },
                {
                    name = 'hearing',
                    stats = { main = 'cntr', sub = 'mg', third = 'snp' },
                },
                {
                    name = 'profession',
                    stats = { main = 'mg', sub ='ptnc', third = 'cntr' },
                },
            },
            points = {
                { value = 1.25, from = { 'mg', 'cntr' } },
                { value = 2.5, from = { 'ag', 'will' } },
            },
        },
    },
};