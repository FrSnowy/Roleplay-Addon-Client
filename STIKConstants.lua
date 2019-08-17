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
        settings = {
            title = "Настройки",
            getPlotInv = "Получать приглашения в сюжеты",
            getEventInv = "Получать приглашения на события",
            showDeclineMessages = "Показывать уведомления об отказе",
            showRollInfo = "Показывать информацию о броске",
            parameters = "Параметры",
            parts = "Сохраненные сюжеты",
            plot = "Сюжет",
            removePlot = "Удалить",
            selectPlot = "Активировать",
            unselectPlot = "Деактивировать",
            activeEventTitle = "Активный сюжет",
            unactivateButton = "Покинуть текущее событие"
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
};