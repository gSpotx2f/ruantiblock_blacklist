#!/bin/sh

############################## Usage ##################################
#
# run_parser.sh [<config> [<output directory>]]

#################### Platform-specific settings ########################

export SCRIPT_NAME="ruantiblock_blacklist"
export NAME="ruantiblock"
export LANG="en_US.UTF-8"
export LANGUAGE="en"

CONFIG_DIR="."
CONFIG_FILE="${CONFIG_DIR}/${NAME}.conf"
export DATA_DIR="."
export MODULES_DIR="."

########################## Default Settings ############################

### Добавление в список блокировок пользовательских записей из файла $USER_ENTRIES_FILE (0 - off, 1 - on)
###  В $DATA_DIR можно создать текстовый файл user_entries с записями IP, CIDR или FQDN (одна на строку). Эти записи будут добавлены в список блокировок
###  В записях FQDN можно задать DNS-сервер для разрешения данного домена, через пробел (прим.: domain.com 8.8.8.8)
###  Можно комментировать строки (#)
export ADD_USER_ENTRIES=0
### DNS-сервер для пользовательских записей (пустая строка - без DNS-сервера). Можно с портом: 8.8.8.8#53. Если в записи указан свой DNS-сервер - он имеет приоритет
export USER_ENTRIES_DNS=""
### Файл пользовательских записей
export USER_ENTRIES_FILE="${CONFIG_DIR}/user_entries"
### Запись событий в syslog (0 - off, 1 - on)
export ENABLE_LOGGING=1
### Максимальное кол-во элементов списка nftables
export NFTSET_MAXELEM_CIDR=65535
export NFTSET_MAXELEM_IP=1000000
#export NFTSET_MAXELEM_DNSMASQ=65535
### Политика отбора элементов в сетах nftables. "performance" - производительность и большее потребление RAM. "memory" - хуже производительность и меньше потребление RAM
export NFTSET_POLICY_CIDR="memory"
export NFTSET_POLICY_IP="memory"
#export NFTSET_POLICY_DNSMASQ="performance"
### Кол-во попыток обновления блэклиста (в случае неудачи)
export MODULE_RUN_ATTEMPTS=3
### Таймаут между попытками обновления
export MODULE_RUN_TIMEOUT=60
### Модули для получения и обработки блэклиста
BLLIST_MODULE="${MODULES_DIR}/ruab_parser.py"

############################## Parsers #################################

### Режим обхода блокировок: zapret-info-fqdn, zapret-info-ip, rublacklist-fqdn, rublacklist-ip, antifilter-ip, fz-fqdn, fz-ip, ruantiblock-fqdn, ruantiblock-ip
export BLLIST_PRESET=""
### В случае если из источника получено менее указанного кол-ва записей, то обновления списков не происходит
export BLLIST_MIN_ENTRIES=30000
### Лимит IP адресов. При достижении, в конфиг ipset будет добавлена вся подсеть /24 вместо множества IP адресов пренадлежащих этой сети (0 - off)
export BLLIST_IP_LIMIT=0
### Подсети класса C (/24). IP адреса из этих подсетей не группируются при оптимизации (записи д.б. в виде: 68.183.221. 149.154.162. и пр.). Прим.: "68.183.221. 149.154.162."
export BLLIST_GR_EXCLUDED_NETS=""
### Группировать идущие подряд IP адреса в подсетях /24 в диапазоны CIDR
export BLLIST_SUMMARIZE_IP=0
### Группировать идущие подряд подсети /24 в диапазоны CIDR
export BLLIST_SUMMARIZE_CIDR=0
### Фильтрация записей блэклиста по шаблонам из файла BLLIST_IP_FILTER_FILE. Записи (IP, CIDR) попадающие под шаблоны исключаются из кофига ipset (0 - off, 1 - on)
export BLLIST_IP_FILTER=0
### Тип фильтра IP (0 - все записи, кроме совпадающих с шаблонами; 1 - только записи, совпадающие с шаблонами)
export BLLIST_IP_FILTER_TYPE=0
### Файл с шаблонами IP для опции BLLIST_IP_FILTER (каждый шаблон в отдельной строке. # в первом символе строки - комментирует строку)
export BLLIST_IP_FILTER_FILE="${CONFIG_DIR}/ip_filter"
### Лимит субдоменов для группировки. При достижении, в конфиг dnsmasq будет добавлен весь домен 2-го ур-ня вместо множества субдоменов (0 - off)
export BLLIST_SD_LIMIT=0
### SLD не подлежащие группировке при оптимизации (через пробел)
export BLLIST_GR_EXCLUDED_SLD=""
### Не группировать SLD попадающие под выражения (через пробел) ("[.][a-z]{2,3}[.][a-z]{2}$")
export BLLIST_GR_EXCLUDED_MASKS=""
### Фильтрация записей блэклиста по шаблонам из файла ENTRIES_FILTER_FILE. Записи (FQDN) попадающие под шаблоны исключаются из кофига dnsmasq (0 - off, 1 - on)
export BLLIST_FQDN_FILTER=0
### Тип фильтра FQDN (0 - все записи, кроме совпадающих с шаблонами; 1 - только записи, совпадающие с шаблонами)
export BLLIST_FQDN_FILTER_TYPE=0
### Файл с шаблонами FQDN для опции BLLIST_FQDN_FILTER (каждый шаблон в отдельной строке. # в первом символе строки - комментирует строку)
export BLLIST_FQDN_FILTER_FILE="${CONFIG_DIR}/fqdn_filter"
### Обрезка www[0-9]. в FQDN (0 - off, 1 - on)
export BLLIST_STRIP_WWW=1
### Преобразование кириллических доменов в punycode (0 - off, 1 - on)
export BLLIST_ENABLE_IDN=0
### Перенаправлять DNS-запросы на альтернативный DNS-сервер для заблокированных FQDN (0 - off, 1 - on)
export BLLIST_ALT_NSLOOKUP=0
### Альтернативный DNS-сервер
export BLLIST_ALT_DNS_ADDR="8.8.8.8"

### Источники блэклиста
export RBL_ALL_URL="https://reestr.rublacklist.net/api/v2/current/csv/"
export RBL_IP_URL="https://reestr.rublacklist.net/api/v2/ips/csv/"
export RBL_DPI_URL="https://reestr.rublacklist.net/api/v3/dpi/"
export ZI_ALL_URL="https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv"
export AF_IP_URL="https://antifilter.download/list/allyouneed.lst"
export AF_FQDN_URL="https://antifilter.download/list/domains.lst"
export FZ_URL="https://raw.githubusercontent.com/fz139/vigruzki/main/dump.xml.00 https://raw.githubusercontent.com/fz139/vigruzki/main/dump.xml.01 https://raw.githubusercontent.com/fz139/vigruzki/main/dump.xml.02"
# export RA_IP_NFTSET_URL="https://raw.githubusercontent.com/gSpotx2f/ruantiblock_blacklist/master/blacklist/ip/ruantiblock.ip"
# export RA_IP_DMASK_URL="https://raw.githubusercontent.com/gSpotx2f/ruantiblock_blacklist/master/blacklist/ip/ruantiblock.dnsmasq"
# export RA_IP_STAT_URL="https://raw.githubusercontent.com/gSpotx2f/ruantiblock_blacklist/master/blacklist/ip/update_status"
# export RA_FQDN_NFTSET_URL="https://raw.githubusercontent.com/gSpotx2f/ruantiblock_blacklist/master/blacklist/fqdn/ruantiblock.ip"
# export RA_FQDN_DMASK_URL="https://raw.githubusercontent.com/gSpotx2f/ruantiblock_blacklist/master/blacklist/fqdn/ruantiblock.dnsmasq"
# export RA_FQDN_STAT_URL="https://raw.githubusercontent.com/gSpotx2f/ruantiblock_blacklist/master/blacklist/fqdn/update_status"
export RBL_ENCODING=""
export ZI_ENCODING="CP1251"
export AF_ENCODING=""
export FZ_ENCODING="CP1251"
# export RA_ENCODING=""

############################ Configuration #############################

### External config
if [ -n "$1" ]; then
    CONFIG_FILE="$1"
fi
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"

### Blacklist source and mode
case "$BLLIST_PRESET" in
    zapret-info-ip)
        ### Источник для обновления списка блокировок (zapret-info, rublacklist, antifilter, ruantiblock)
        export BLLIST_SOURCE="zapret-info"
        ### Режим обхода блокировок: ip, fqdn
        export BLLIST_MODE="ip"
    ;;
    rublacklist-ip)
        export BLLIST_SOURCE="rublacklist"
        export BLLIST_MODE="ip"
    ;;
    rublacklist-fqdn)
        export BLLIST_SOURCE="rublacklist"
        export BLLIST_MODE="fqdn"
    ;;
    antifilter-ip)
        export BLLIST_SOURCE="antifilter"
        export BLLIST_MODE="ip"
    ;;
    fz-ip)
        export BLLIST_SOURCE="fz"
        export BLLIST_MODE="ip"
    ;;
    fz-fqdn)
        export BLLIST_SOURCE="fz"
        export BLLIST_MODE="fqdn"
    ;;
#     ruantiblock-ip)
#         export BLLIST_SOURCE="ruantiblock"
#         export BLLIST_MODE="ip"
#     ;;
#     ruantiblock-fqdn)
#         export BLLIST_SOURCE="ruantiblock"
#         export BLLIST_MODE="fqdn"
#     ;;
    *)
        export BLLIST_SOURCE="zapret-info"
        export BLLIST_MODE="fqdn"
    ;;
esac

AWK_CMD="awk"
LOGGER_CMD=`which logger`
if [ $ENABLE_LOGGING = "1" -a $? -ne 0 ]; then
    echo " Logger doesn't exists" >&2
    ENABLE_LOGGING=0
fi
LOGGER_PARAMS="-t ${SCRIPT_NAME}"

### Output directory
if [ -n "$2" ]; then
    export DATA_DIR="$2"
fi

export IP_DATA_FILE="${DATA_DIR}/${NAME}.ip"
export DNSMASQ_DATA_FILE="${DATA_DIR}/${NAME}.dnsmasq"
export NFT_TABLE="ip r"
export NFT_TABLE_DNSMASQ="4#ip#r"
export NFTSET_ALLOWED_HOSTS="allowed_ip"
export NFTSET_ONION="onion"
export NFTSET_CIDR="c"
export NFTSET_IP="i"
export NFTSET_DNSMASQ="d"
export NFTSET_ALLOWED_HOSTS_TYPE="ipv4_addr"
export NFTSET_CIDR_TYPE="ipv4_addr"
export NFTSET_IP_TYPE="ipv4_addr"
export NFTSET_DNSMASQ_TYPE="ipv4_addr"
export NFTSET_CIDR_CFG="set ${NFTSET_CIDR} {type ${NFTSET_CIDR_TYPE};size ${NFTSET_MAXELEM_CIDR};policy ${NFTSET_POLICY_CIDR};flags interval;auto-merge;"
export NFTSET_IP_CFG="set ${NFTSET_IP} {type ${NFTSET_IP_TYPE};size ${NFTSET_MAXELEM_IP};policy ${NFTSET_POLICY_IP};flags dynamic;"
export UPDATE_STATUS_FILE="${DATA_DIR}/update_status"

[ -d "$DATA_DIR" ] || mkdir -p "$DATA_DIR"

MakeLogRecord() {
    if [ $ENABLE_LOGGING = "1" ]; then
        $LOGGER_CMD $LOGGER_PARAMS -p "user.${1}" "$2"
    fi
}

ClearDataFiles() {
    if [ -d "$DATA_DIR" ]; then
        printf "" > "$DNSMASQ_DATA_FILE"
        printf "" > "$IP_DATA_FILE"
        printf "0 0 0" > "$UPDATE_STATUS_FILE"
    fi
}

AddUserEntries() {
    if [ "$ADD_USER_ENTRIES" = "1" ]; then
        if [ -f "$USER_ENTRIES_FILE" ]; then
            $AWK_CMD 'BEGIN {
                        null="";
                        ip_array[0]=null;
                        cidr_array[0]=null;
                        fqdn_array[0]=null;
                    }
                    function writeIpList(array,  _str) {
                        _str="";
                        for(i in array) {
                            _str=_str i ",";
                        };
                        return _str;
                    };
                    function writeDNSData(val, dns) {
                        if(length(dns) == 0 && length(ENVIRON["USER_ENTRIES_DNS"]) > 0) {
                            dns=ENVIRON["USER_ENTRIES_DNS"];
                        };
                        if(length(dns) > 0) {
                            printf "server=/%s/%s\n", val, dns >> ENVIRON["DNSMASQ_DATA_FILE"];
                        };
                        printf "nftset=/%s/%s#%s\n", val, ENVIRON["NFT_TABLE_DNSMASQ"], ENVIRON["NFTSET_DNSMASQ"] >> ENVIRON["DNSMASQ_DATA_FILE"];
                    };
                    function writeFqdnEntries() {
                        delete fqdn_array[0];
                        for(i in fqdn_array) {
                            split(fqdn_array[i], a, " ");
                            writeDNSData(a[1], a[2]);
                        };
                    };
                    ($0 !~ /^([\040\011]*$|#)/) {
                        if($0 ~ /^[0-9]{1,3}([.][0-9]{1,3}){3}$/) {
                            ip_array[$0]=null;
                        }
                        else if($0 ~ /^[0-9]{1,3}([.][0-9]{1,3}){3}[\057][0-9]{1,2}$/) {
                            cidr_array[$0]=null;
                        }
                        else if($0 ~ /^[a-z0-9.\052-]+[.]([a-z]{2,}|xn--[a-z0-9]+)([ ][0-9]{1,3}([.][0-9]{1,3}){3}([#][0-9]{2,5})?)?$/) {
                            fqdn_array[length(fqdn_array)]=$1 " " $2;
                        };
                    }
                    END {
                        printf "table %s {\n%s", ENVIRON["NFT_TABLE"], ENVIRON["NFTSET_CIDR_CFG"] >> ENVIRON["IP_DATA_FILE"];
                        delete cidr_array[0];
                        if(length(cidr_array) > 0) {
                            printf "elements={%s};", writeIpList(cidr_array) >> ENVIRON["IP_DATA_FILE"];
                        };
                        printf "}\n%s", ENVIRON["NFTSET_IP_CFG"] >> ENVIRON["IP_DATA_FILE"];
                        delete ip_array[0];
                        if(length(ip_array) > 0) {
                            printf "elements={%s};", writeIpList(ip_array) >> ENVIRON["IP_DATA_FILE"];
                        };
                        printf "}\n}\n" >> ENVIRON["IP_DATA_FILE"];
                        writeFqdnEntries();
                    }' "$USER_ENTRIES_FILE"
        fi
    fi
}

GetDataFiles() {
    local _return_code=1 _attempt=1 _update_string
    if [ -n "$BLLIST_PRESET" -a -n "$BLLIST_MODULE" ]; then
        while :
        do
            nice -n 19 $BLLIST_MODULE
            _return_code=$?
            [ $_return_code -eq 0 ] && break
            ### STDOUT
            echo " Module run attempt ${_attempt}: failed [${BLLIST_MODULE}]"
            MakeLogRecord "err" "Module run attempt ${_attempt}: failed [${BLLIST_MODULE}]"
            _attempt=`expr $_attempt + 1`
            [ $_attempt -gt $MODULE_RUN_ATTEMPTS ] && break
            sleep $MODULE_RUN_TIMEOUT
        done
        if [ $_return_code -eq 0 ]; then
            AddUserEntries
            _update_string=`$AWK_CMD '{
                printf "Received entries: %s\n", (NF < 3) ? "No data" : "CIDR: "$1", IP: "$2", FQDN: "$3;
                exit;
            }' "$UPDATE_STATUS_FILE"`
            ### STDOUT
            echo " ${_update_string}"
            MakeLogRecord "notice" "${_update_string}"
        fi

    elif [ -z "$BLLIST_PRESET" -a -z "$BLLIST_MODULE" ]; then
        ClearDataFiles
        ADD_USER_ENTRIES=1
        AddUserEntries
        _return_code=0
    else
        _return_code=2
        return $_return_code
    fi

    return $_return_code
}

Update() {
    local _return_code=0

    echo " ${SCRIPT_NAME} update (${1})..."
    MakeLogRecord "notice" "update (${1})..."
    GetDataFiles
    case $? in
        0)
            echo " Blacklist updated"
            MakeLogRecord "notice" "Blacklist updated"
        ;;
        2)
            echo " Error! Blacklist update error" >&2
            MakeLogRecord "err" "Error! Blacklist update error"
            _return_code=1
        ;;
        *)
            echo " Module error! [${BLLIST_MODULE}]" >&2
            MakeLogRecord "err" "Module error! [${BLLIST_MODULE}]"
            _return_code=1
        ;;
    esac
    return $_return_code
}

Update $1
exit $?
