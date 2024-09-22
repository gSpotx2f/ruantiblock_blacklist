# Создание конфигов nftables и dnsmasq со списком блокировок для [ruantiblock_openwrt](https://github.com/gSpotx2f/ruantiblock_openwrt).

Дальнейшие действия, кроме последнего пункта, должны производиться на той машине где будет выполняться создание конфигов!

## Зависимости

Для работы парсера нужен Python3 (версии >=3.6). Обычно, во всех современных дистрибутивах Linux он уже установлен по умолчанию.

## Установка скриптов для запуска модуля-парсера

Создайте локальную копию этого репозитория в `/opt/ruantiblock_blacklist`:

    git clone https://github.com/gSpotx2f/ruantiblock_blacklist /opt/ruantiblock_blacklist

## Запуск

Создание конфигов nftables и dnsmasq (эту команду можно добавить в cron для регулярного обновления списка блокировок):

    /opt/ruantiblock_blacklist/1.1/start.sh

По умолчанию, созданные файлы будут находиться в директориях `blacklist-1.1/ip` и `blacklist-1.1/fqdn` (в корне проекта) для конфигураций `ip` и `fqdn` соответственно. В скрипте `start.sh` можно изменить директорию для вывода готовых конфигов (`OUTPUT_DIR`) и поместить их, например, на ваш веб-сервер, чтобы роутер (ruantiblock) забирал их оттуда при обновлении блэклиста.

## Настройка [ruantiblock_openwrt](https://github.com/gSpotx2f/ruantiblock_openwrt) на роутере для получения созданных конфигов с вашего веб-сервера

В файле `/usr/share/ruantiblock/blacklist_sources` измените ссылки на файлы в следующих переменных:

    ruantiblock-ip)
        ...
        DL_IPSET_URL="http://<ПУТЬ К ДИРЕКТОРИИ С КОНФИГАМИ НА ВАШЕМ ВЕБ-СЕРВЕРЕ>/ip/ruantiblock.ip"
        DL_DMASK_URL="http://<ПУТЬ К ДИРЕКТОРИИ С КОНФИГАМИ НА ВАШЕМ ВЕБ-СЕРВЕРЕ>/ip/ruantiblock.dnsmasq"
        DL_STAT_URL="http://<ПУТЬ К ДИРЕКТОРИИ С КОНФИГАМИ НА ВАШЕМ ВЕБ-СЕРВЕРЕ>/ip/update_status"
    ;;
    ruantiblock-fqdn)
        ...
        DL_IPSET_URL="http://<ПУТЬ К ДИРЕКТОРИИ С КОНФИГАМИ НА ВАШЕМ ВЕБ-СЕРВЕРЕ>/fqdn/ruantiblock.ip"
        DL_DMASK_URL="http://<ПУТЬ К ДИРЕКТОРИИ С КОНФИГАМИ НА ВАШЕМ ВЕБ-СЕРВЕРЕ>/fqdn/ruantiblock.dnsmasq"
        DL_STAT_URL="http://<ПУТЬ К ДИРЕКТОРИИ С КОНФИГАМИ НА ВАШЕМ ВЕБ-СЕРВЕРЕ>/fqdn/update_status"
    ;;

Включение режима обновления блэклиста `ruantiblock-fqdn`:

    uci set ruantiblock.config.bllist_preset="ruantiblock-fqdn"
    uci commit ruantiblock

Обновление блэклиста:

    /usr/bin/ruantiblock update
