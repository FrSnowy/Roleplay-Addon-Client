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
            fight_str = 'Силовое действие',
            fight_ag = 'Ловкое действие',
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
            profession = 'Ремесло',
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
        { size = 6, penalty = 0.75 },
        { size = 12, penalty = 0.8 },
        { size = 20, penalty = 0.83 },
        { size = 100, penalty = 0.85 },
    },
    armorPenalty = {
        head = {
            nothing = {
                fight_str = 0, fight_ag = 0, shooting = 0.1, magica = 0.1, shadows = 0.1, holy = 0.1, elems = 0, nature = 0,
                melee_weapon = 0.1, range_weapon = 0.1, controll = -0.1, armor = 0.1, hacking = 0.2, stealth = 0.1,
                talking = 0.1, stealing = 0.1, hearing = 0.2, profession = 0.1,
            },
            cloth = {
                fight_str = 0, fight_ag = 0, shooting = 0.05, magica = 0.05, shadows = 0.05, holy = 0.05, elems = 0.2, nature = 0.1,
                melee_weapon = 0.05, range_weapon = 0.05, controll = -0.05, armor = 0.05, hacking = 0.1, stealth = 0.05,
                talking = 0.05, stealing = 0.1, hearing = 0.1, profession = 0.05,
            },
            leather = {
                fight_str = 0, fight_ag = 0, shooting = 0, magica = 0, shadows = 0, holy = 0, elems = 0.1, nature = 0.05,
                melee_weapon = -0.05, range_weapon = -0.05, controll = 0, armor = 0, hacking = 0, stealth = 0,
                talking = 0, stealing = 0, hearing = 0, profession = 0,
            },
            mail = {
                fight_str = 0, fight_ag = -0.05, shooting = -0.1, magica = -0.1, shadows = -0.15, holy = 0.05, elems = 0, nature = 0,
                melee_weapon = -0.05, range_weapon = -0.1, controll = 0.05, armor = -0.05, hacking = -0.05, stealth = -0.05,
                talking = 0, stealing = -0.05, hearing = -0.1, profession = 0,
            },
            plate = {
                fight_str = 0, fight_ag = -0.1, shooting = -0.2, magica = -0.2, shadows = -0.15, holy = 0, elems = -0.2, nature = -0.3,
                melee_weapon = -0.1, range_weapon = -0.2, controll = 0.1, armor = -0.2, hacking = -0.2, stealth = -0.1,
                talking = -0.1, stealing = -0.1, hearing = -0.3, profession = -0.2,
            },
        },
        body = {
            nothing = {
                fight_str = -0.05, fight_ag = 0.1, shooting = 0.1, magica = 0.1, shadows = 0.1, holy = -0.2, elems = -0.05, nature = 0.1,
                melee_weapon = 0.05, range_weapon = 0.05, controll = -0.1, armor = 0.2, hacking = 0.2, stealth = 0.2,
                talking = -0.3, stealing = 0.2, hearing = 0, profession = 0.05
            },
            cloth = {
                fight_str = -0.05, fight_ag = 0.1, shooting = 0.05, magica = 0.05, shadows = 0.1, holy = 0, elems = 0.1, nature = 0.1,
                melee_weapon = 0, range_weapon = 0, controll = -0.05, armor = 0.1, hacking = 0.1, stealth = 0.1,
                talking = 0, stealing = 0.1, hearing = 0, profession = 0,
            },
            leather = {
                fight_str = 0, fight_ag = 0, shooting = 0, magica = 0, shadows = 0.05, holy = 0.05, elems = 0.05, nature = 0.05,
                melee_weapon = 0, range_weapon = 0, controll = 0, armor = 0, hacking = 0, stealth = 0,
                talking = 0, stealing = 0, hearing = 0, profession = -0.05,
            },
            mail = {
                fight_str = 0.05, fight_ag = -0.12, shooting = -0.1, magica = -0.1, shadows = 0, holy = 0.02, elems = 0, nature = -0.05,
                melee_weapon = -0.05, range_weapon = -0.1, controll = 0.05, armor = -0.1, hacking = -0.1, stealth = -0.05,
                talking = 0.02, stealing = -0.1, hearing = 0, profession = -0.05,
            },
            plate = {
                fight_str = 0.1, fight_ag = -0.25, shooting = -0.2, magica = -0.2, shadows = -0.1, holy = 0, elems = -0.05, nature = -0.2,
                melee_weapon = -0.1, range_weapon = -0.15, controll = 0.1, armor = -0.2, hacking = -0.2, stealth = -0.1,
                talking = 0.05, stealing = -0.2, hearing = 0, profession = -0.05,
            },
        },
        legs = {
            nothing = {
                fight_str = -0.05, fight_ag = 0.1, shooting = 0.1, magica = 0.1, shadows = 0, holy = -0.2, elems = -0.1, nature = 0.1,
                melee_weapon = 0, range_weapon = 0, controll = -0.3, armor = 0.3, hacking = 0, stealth = 0.2,
                talking = -0.5, stealing = 0.1, hearing = 0, profession = 0.05,
            },
            cloth = {
                fight_str = -0.05, fight_ag = 0.1, shooting = 0.05, magica = 0.05, shadows = 0, holy = 0, elems = 0.05, nature = 0.1,
                melee_weapon = 0, range_weapon = 0, controll = -0.05, armor = 0.1, hacking = 0, stealth = 0.1,
                talking = 0, stealing = 0, hearing = 0, profession = 0,
            },
            leather = {
                fight_str = 0, fight_ag = 0.05, shooting = 0, magica = 0, shadows = 0.05, holy = 0.05, elems = 0.1, nature = 0.05,
                melee_weapon = 0, range_weapon = 0, controll = 0, armor = 0, hacking = 0, stealth = 0,
                talking = 0, stealing = 0, hearing = 0, profession = 0,
            },
            mail = {
                fight_str = 0.05, fight_ag = -0.12, shooting = -0.05, magica = -0.05, shadows = 0, holy = 0.02, elems = 0, nature = -0.05,
                melee_weapon = 0, range_weapon = 0, controll = 0.05, armor = -0.05, hacking = 0, stealth = -0.07,
                talking = 0.02, stealing = -0.05, hearing = 0, profession = -0.05,
            },
            plate = {
                fight_str = 0.1, fight_ag = -0.25, shooting = -0.1, magica = -0.1, shadows = -0.1, holy = 0, elems = -0.05, nature = -0.2,
                melee_weapon = 0, range_weapon = 0, controll = 0.1, armor = -0.1, hacking = 0, stealth = -0.2,
                talking = 0.05, stealing = -0.1, hearing = 0, profession = -0.1,
            },
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
                    img = 'sword',
                    stats = { main = 'str', sub = 'body', third = 'snp' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'melee_weapon', normal = 30 },
                    },
                },
                {
                    name = 'fight_ag',
                    img = 'dagger',
                    stats = { main = 'ag', sub = 'snp', third = 'str' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'melee_weapon', normal = 40 },
                    },
                },
                {
                    name = 'shooting',
                    img = 'bow',
                    stats = { main = 'snp', sub = 'cntr', third = 'ptnc' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'range_weapon', normal = 30 },
                    },
                },
                {
                    name = 'magica',
                    img = 'magic',
                    stats = { main = 'mg', sub = 'cntr', third = 'will' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'controll', normal = 20 },
                        { block = 'skills', category = 'battle', name = 'nature', normal = 1, reverse = true },
                    },
                },
                {
                    name = 'shadows',
                    img = 'warlock',
                    stats = { main = 'mg', sub = 'cntr', third = 'body' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'controll', normal = 1, reverse = true },
                        { block = 'skills', category = 'battle', name = 'holy', normal = 1, reverse = true },
                    }
                },
                {
                    name = 'holy',
                    img = 'holy',
                    stats = { main = 'will', sub = 'ptnc', third = 'cntr' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'controll', normal = 25 },
                        { block = 'skills', category = 'battle', name = 'shadows', normal = 1, reverse = true },
                    },
                },
                {
                    name = 'elems',
                    img = 'elements',
                    stats = { main = 'will', sub = 'cntr', third = 'ptnc' },
                },
                {
                    name = 'nature',
                    img = 'nature',
                    stats = { main = 'ptnc', sub = 'cntr', third = 'will' },
                    modifier = {
                        { block = 'skills', category = 'passive', name = 'controll', normal = 20 },
                        { block = 'skills', category = 'battle', name = 'magica', normal = 1, reverse = true },
                    },
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
                    name = 'melee_weapon',
                    img = 'weapon',
                    stats = { main = 'str', sub = 'mg', third = 'body' },
                },
                {
                    name = 'range_weapon',
                    img = 'rifle',
                    stats = { main = 'ag', sub = 'snp', third = 'ptnc' },
                },
                {
                    name = 'controll',
                    img = 'fear',
                    stats = { main = 'will', sub = 'body', third = 'str' },
                },
                {
                    name = 'armor',
                    img = 'armor',
                    stats = { main = 'body', sub = 'str', third = 'ag' },
                },
            },
            points = {
                { value = 1.25, from = { 'body', 'ptnc', 'cntr' } },
                { value = 2.5, from = { 'str', 'mg', 'ag' } },
                { value = 4.75, from = { 'will', 'snp' } }
            },
        },
        {
            name = 'social',
            skills = {
                {
                    name = 'talking',
                    img = 'talking',
                    stats = { main = 'mg', sub = 'will', third = 'body' },
                },
                {
                    name = 'stealing',
                    img = 'stealing',
                    stats = { main = 'ag', sub = 'cntr', third = 'snp' },
                },
                {
                    name = 'hacking',
                    img = 'lock',
                    stats = { main = 'ag', sub = 'cntr', third = 'mg' },
                },
                {
                    name = 'stealth',
                    img = 'ninja',
                    stats = { main = 'mg', sub = 'ag', third = 'ptnc' },
                },
                {
                    name = 'hearing',
                    img = 'hearing',
                    stats = { main = 'cntr', sub = 'mg', third = 'ptnc' },
                },
                {
                    name = 'profession',
                    img = 'craft',
                    stats = { main = 'mg', sub ='ptnc', third = 'cntr' },
                },
            },
            points = {
                { value = 1.25, from = { 'mg', 'cntr' } },
                { value = 2.5, from = { 'ag', 'will', 'ptnc' } },
            },
        },
    },
};