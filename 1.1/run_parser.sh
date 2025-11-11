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

### Запись событий в syslog (0 - off, 1 - on)
export ENABLE_LOGGING=1
### Максимальное кол-во элементов списка nftables
export NFTSET_MAXELEM_CIDR=65535
export NFTSET_MAXELEM_IP=1000000
export NFTSET_MAXELEM_DNSMASQ=65535
### Политика отбора элементов в сетах nftables. "performance" - производительность и большее потребление RAM. "memory" - хуже производительность и меньше потребление RAM
export NFTSET_POLICY_CIDR="memory"
export NFTSET_POLICY_IP="memory"
export NFTSET_POLICY_DNSMASQ="performance"
### Добавление в список блокировок пользовательских записей из файла $USER_ENTRIES_FILE (0 - off, 1 - on)
###  В $CONFIG_DIR можно создать текстовый файл user_entries с записями IP, CIDR или FQDN (одна на строку). Эти записи будут добавлены в список блокировок
###  В записях FQDN можно задать DNS-сервер для разрешения данного домена, через пробел (прим.: domain.com 8.8.8.8)
###  Можно комментировать строки (#)
export ADD_USER_ENTRIES=0
### DNS-сервер для пользовательских записей (пустая строка - без DNS-сервера). Можно с портом: 8.8.8.8#53. Если в записи указан свой DNS-сервер - он имеет приоритет
export USER_ENTRIES_DNS=""
### Файл пользовательских записей
export USER_ENTRIES_FILE="${CONFIG_DIR}/user_entries"
### URL удаленных файлов записей пользователя, через пробел (прим.: http://server.lan/files/user_entries_1 http://server.lan/files/user_entries_2)
export USER_ENTRIES_REMOTE=""
### Кол-во попыток скачивания удаленного файла записей пользователя (в случае неудачи)
export USER_ENTRIES_REMOTE_DOWNLOAD_ATTEMPTS=3
### Таймаут между попытками скачивания
export USER_ENTRIES_REMOTE_DOWNLOAD_TIMEOUT=60
### Режим безопасного обновления блэклиста. Скачивание во временный файл и затем замена на основной. Увеличивает потребление памяти (0 - выкл, 1 - вкл)
export ENABLE_TMP_DOWNLOADS=0
### Кол-во попыток обновления блэклиста (в случае неудачи)
export MODULE_RUN_ATTEMPTS=3
### Таймаут между попытками обновления
export MODULE_RUN_TIMEOUT=60
### Модули для получения и обработки блэклиста
#BLLIST_MODULE="${MODULES_DIR}/ruab_parser.lua"
BLLIST_MODULE="${MODULES_DIR}/ruab_parser.py"

############################## Parsers #################################

### Режим обхода блокировок: zapret-info-ip, zapret-info-fqdn, zapret-info-fqdn-only, rublacklist-ip, rublacklist-fqdn, rublacklist-fqdn-only, antifilter-ip, antifilter-fqdn, antifilter-fqdn-only, fz-ip, fz-fqdn, fz-fqdn-only
export BLLIST_PRESET=""
### В случае если из источника получено менее указанного кол-ва записей, то обновления списков не происходит
export BLLIST_MIN_ENTRIES=30000
### Лимит IP адресов. При достижении, в конфиг ipset будет добавлена вся подсеть /24 вместо множества IP адресов пренадлежащих этой сети (0 - off)
export BLLIST_IP_LIMIT=0
### Файл с подсетями класса C (/24). IP адреса из этих подсетей не группируются при оптимизации (записи д.б. в виде: 68.183.221. 149.154.162. и пр. Одна запись на строку)
export BLLIST_GR_EXCLUDED_NETS_FILE="${CONFIG_DIR}/gr_excluded_nets"
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
### Включение опции исключения IP/CIDR из блэклиста
export BLLIST_IP_EXCLUDED_ENABLE=0
### Файл с записями IP/CIDR для опции BLLIST_IP_EXCLUDED_ENABLE
export BLLIST_IP_EXCLUDED_FILE="${CONFIG_DIR}/ip_excluded"
### Включение опции исключения IP/CIDR из блэклиста
export BLLIST_CIDR_EXCLUDED_ENABLE=0
### Файл с записями IP/CIDR для опции BLLIST_CIDR_EXCLUDED_ENABLE
export BLLIST_CIDR_EXCLUDED_FILE="./cidr_excluded"
### Лимит субдоменов для группировки. При достижении, в конфиг dnsmasq будет добавлен весь домен 2-го ур-ня вместо множества субдоменов (0 - off)
export BLLIST_SD_LIMIT=0
### Файл с SLD не подлежащими группировке при оптимизации (одна запись на строку)
export BLLIST_GR_EXCLUDED_SLD_FILE="${CONFIG_DIR}/gr_excluded_sld"
### Файл с масками SLD не подлежащими группировке при оптимизации (одна запись на строку)
export BLLIST_GR_EXCLUDED_SLD_MASKS_FILE="${CONFIG_DIR}/gr_excluded_sld_mask"
### Фильтрация записей блэклиста по шаблонам из файла ENTRIES_FILTER_FILE. Записи (FQDN) попадающие под шаблоны исключаются из кофига dnsmasq (0 - off, 1 - on)
export BLLIST_FQDN_FILTER=0
### Тип фильтра FQDN (0 - все записи, кроме совпадающих с шаблонами; 1 - только записи, совпадающие с шаблонами)
export BLLIST_FQDN_FILTER_TYPE=0
### Файл с шаблонами FQDN для опции BLLIST_FQDN_FILTER (каждый шаблон в отдельной строке. # в первом символе строки - комментирует строку)
export BLLIST_FQDN_FILTER_FILE="${CONFIG_DIR}/fqdn_filter"
### Включение опции исключения FQDN из блэклиста
export BLLIST_FQDN_EXCLUDED_ENABLE=0
### Файл с записями FQDN для опции BLLIST_FQDN_EXCLUDED_ENABLE
export BLLIST_FQDN_EXCLUDED_FILE="${CONFIG_DIR}/fqdn_excluded"
### Включение опции исключения записей определённых гос.органов из блэклиста
export BLLIST_ORG_EXCLUDED_ENABLE=0
### Файл с записями для опции BLLIST_ORG_EXCLUDED_ENABLE
export BLLIST_ORG_EXCLUDED_FILE="${CONFIG_DIR}/org_excluded"
### Обрезка www[0-9]. в FQDN (0 - off, 1 - on)
export BLLIST_STRIP_WWW=1
### Преобразование кириллических доменов в punycode (0 - off, 1 - on)
export BLLIST_ENABLE_IDN=0
### Перенаправлять DNS-запросы на альтернативный DNS-сервер для заблокированных FQDN (0 - off, 1 - on)
export BLLIST_ALT_NSLOOKUP=0
### Альтернативный DNS-сервер
export BLLIST_ALT_DNS_ADDR="8.8.8.8"

############################ Configuration #############################

### External config
if [ -n "$1" ]; then
    CONFIG_FILE="$1"
fi
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"

### Blacklist sources
## rublacklist
export RBL_ALL_URL="https://reestr.rublacklist.net/api/v3/snapshot/"
export RBL_IP_URL="https://reestr.rublacklist.net/api/v3/ips/"
export RBL_DPI_URL="https://reestr.rublacklist.net/api/v3/dpi/"
export RBL_ENCODING=""
## zapret-info
#export ZI_ALL_URL="https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-00.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-01.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-02.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-03.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-04.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-05.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-06.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-07.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-08.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-09.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-10.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-11.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-12.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-13.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-14.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-15.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-16.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-17.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-18.csv https://raw.githubusercontent.com/zapret-info/z-i/refs/heads/master/dump-19.csv"
#export ZI_ALL_URL="https://app.assembla.com/spaces/z-i/git/source/master/dump.csv?_format=raw"
export ZI_ALL_URL="https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-00.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-01.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-02.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-03.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-04.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-05.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-06.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-07.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-08.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-09.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-10.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-11.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-12.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-13.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-14.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-15.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-16.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-17.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-18.csv?format=raw https://sourceforge.net/p/zapret-info/code/HEAD/tree/dump-19.csv?format=raw"
export ZI_ENCODING="CP1251"
## antifilter
export AF_IP_FULL_URL="https://antifilter.download/list/ipresolve.lst"
export AF_IP_URL="https://antifilter.download/list/ip.lst"
export AF_NET_URL="https://antifilter.download/list/subnet.lst"
export AF_FQDN_URL="https://antifilter.download/list/domains.lst"
## fz
export FZ_URL="https://raw.githubusercontent.com/fz139/vigruzki/main/dump.xml.00 https://raw.githubusercontent.com/fz139/vigruzki/main/dump.xml.01 https://raw.githubusercontent.com/fz139/vigruzki/main/dump.xml.02"
export FZ_ENCODING="CP1251"

### Blacklist presets
case "$BLLIST_PRESET" in
    zapret-info-ip)
        ### Источник для обновления списка блокировок (zapret-info, rublacklist, antifilter, fz, ruantiblock)
        export BLLIST_SOURCE="zapret-info"
        ### Режим обхода блокировок: ip, fqdn, fqdn-only
        export BLLIST_MODE="ip"
    ;;
    zapret-info-fqdn)
        export BLLIST_SOURCE="zapret-info"
        export BLLIST_MODE="fqdn"
    ;;
    zapret-info-fqdn-only)
        export BLLIST_SOURCE="zapret-info"
        export BLLIST_MODE="fqdn-only"
    ;;
    rublacklist-ip)
        export BLLIST_SOURCE="rublacklist"
        export BLLIST_MODE="ip"
    ;;
    rublacklist-fqdn)
        export BLLIST_SOURCE="rublacklist"
        export BLLIST_MODE="fqdn"
    ;;
    rublacklist-fqdn-only)
        export BLLIST_SOURCE="rublacklist"
        export BLLIST_MODE="fqdn-only"
    ;;
    antifilter-ip)
        export BLLIST_SOURCE="antifilter"
        export BLLIST_MODE="ip"
    ;;
    antifilter-fqdn)
        export BLLIST_SOURCE="antifilter"
        export BLLIST_MODE="fqdn"
    ;;
    antifilter-fqdn-only)
        export BLLIST_SOURCE="antifilter"
        export BLLIST_MODE="fqdn-only"
    ;;
    fz-ip)
        export BLLIST_SOURCE="fz"
        export BLLIST_MODE="ip"
    ;;
    fz-fqdn)
        export BLLIST_SOURCE="fz"
        export BLLIST_MODE="fqdn"
    ;;
    fz-fqdn-only)
        export BLLIST_SOURCE="fz"
        export BLLIST_MODE="fqdn-only"
    ;;
    *)
        export BLLIST_SOURCE=""
        export BLLIST_MODE=""
    ;;
esac

AWK_CMD="awk"
LOGGER_CMD="$(which logger)"
if [ $ENABLE_LOGGING = "1" -a $? -ne 0 ]; then
    echo " Logger doesn't exists" >&2
    ENABLE_LOGGING=0
fi
LOGGER_PARAMS="-t ${SCRIPT_NAME}"
WGET_CMD="$(which wget)"
if [ $? -ne 0 ]; then
    echo " Error! Wget doesn't exists" >&2
    exit 1
fi
WGET_PARAMS="--no-check-certificate -q -O"

### Output directory
if [ -n "$2" ]; then
    export DATA_DIR="$2"
fi

export IP_DATA_FILE="${DATA_DIR}/${NAME}.ip"
export DNSMASQ_DATA_FILE="${DATA_DIR}/${NAME}.dnsmasq"
export NFT_TABLE="ip r"
export NFT_TABLE_DNSMASQ="4#ip#r"
export NFTSET_CIDR="c"
export NFTSET_IP="i"
export NFTSET_DNSMASQ="d"
export NFTSET_CIDR_TYPE="ipv4_addr"
export NFTSET_IP_TYPE="ipv4_addr"
export NFTSET_DNSMASQ_TYPE="ipv4_addr"
export NFTSET_CIDR_PATTERN="set %s {type ${NFTSET_CIDR_TYPE};size ${NFTSET_MAXELEM_CIDR};policy ${NFTSET_POLICY_CIDR};flags interval;auto-merge;"
export NFTSET_IP_PATTERN="set %s {type ${NFTSET_IP_TYPE};size ${NFTSET_MAXELEM_IP};policy ${NFTSET_POLICY_IP};flags dynamic;"
export NFTSET_CIDR_STRING_MAIN=$(printf "$NFTSET_CIDR_PATTERN" "${NFTSET_CIDR}")
export NFTSET_IP_STRING_MAIN=$(printf "$NFTSET_IP_PATTERN" "${NFTSET_IP}")
export UPDATE_STATUS_FILE="${DATA_DIR}/update_status"
export USER_ENTRIES_STATUS_FILE="${DATA_DIR}/user_entries_status"
export IP_DATA_FILE_TMP="${IP_DATA_FILE}.tmp"
export DNSMASQ_DATA_FILE_TMP="${DNSMASQ_DATA_FILE}.tmp"
export UPDATE_STATUS_FILE_TMP="${UPDATE_STATUS_FILE}.tmp"
export USER_ENTRIES_STATUS_FILE_TMP="${USER_ENTRIES_STATUS_FILE}.tmp"

[ -d "$DATA_DIR" ] || mkdir -p "$DATA_DIR"

MakeLogRecord() {
    if [ $ENABLE_LOGGING = "1" ]; then
        $LOGGER_CMD $LOGGER_PARAMS -p "user.${1}" "$2"
    fi
}

Download() {
    $WGET_CMD $WGET_PARAMS "$1" "$2"
    if [ $? -ne 0 ]; then
        echo " Downloading failed! Connection error (${2})" >&2
        MakeLogRecord "err" "Downloading failed! Connection error (${2})"
        return 1
    fi
}

ClearDataFiles() {
    if [ -d "$DATA_DIR" ]; then
        printf "" > "$DNSMASQ_DATA_FILE"
        printf "" > "$IP_DATA_FILE"
        printf "0 0 0" > "$UPDATE_STATUS_FILE"
        printf "" > "$USER_ENTRIES_STATUS_FILE"
    fi
}

ParseUserEntries() {
    $AWK_CMD -v NFTSET_IP_STRING="$NFTSET_IP_STRING_MAIN" -v NFTSET_CIDR_STRING="$NFTSET_CIDR_STRING_MAIN" \
        -v NFTSET_DNSMASQ="$NFTSET_DNSMASQ" -v IP_DATA_FILE="$1" \
        -v DNSMASQ_DATA_FILE="$2" -v USER_ENTRIES_STATUS_FILE="$3" \
        -v ID="$4" -v USER_ENTRIES_DNS="$USER_ENTRIES_DNS" '
        BEGIN {
            null = "";
            ip_array[0] = null;
            cidr_array[0] = null;
            fqdn_array[0] = null;
        }
        function writeIpList(array,  _str) {
            _str = "";
            for(i in array) {
                _str = _str i ",";
            };
            return _str;
        };
        function writeDNSData(val, dns) {
            if(length(dns) == 0 && length(USER_ENTRIES_DNS) > 0) {
                dns = USER_ENTRIES_DNS;
            };
            if(length(dns) > 0) {
                printf "server=/%s/%s\n", val, dns >> DNSMASQ_DATA_FILE;
            };
            printf "nftset=/%s/%s#%s\n", val, ENVIRON["NFT_TABLE_DNSMASQ"], NFTSET_DNSMASQ >> DNSMASQ_DATA_FILE;
        };
        function writeFqdnEntries() {
            delete fqdn_array[0];
            for(i in fqdn_array) {
                split(fqdn_array[i], a, " ");
                writeDNSData(a[1], a[2]);
            };
        };
        ($0 !~ /^([\040\011]*$|#)/) {
            sub("\015", "", $0);
            if($0 ~ /^[0-9]{1,3}([.][0-9]{1,3}){3}$/) {
                ip_array[$0] = null;
            }
            else if($0 ~ /^[0-9]{1,3}([.][0-9]{1,3}){3}[\057][0-9]{1,2}$/) {
                cidr_array[$0] = null;
            }
            else if($0 ~ /^([a-z0-9._-]+[.])*([a-z]{2,}|xn--[a-z0-9]+)([ ][0-9]{1,3}([.][0-9]{1,3}){3}([#][0-9]{2,5})?)?$/) {
                fqdn_array[length(fqdn_array)] = $1 " " $2;
            };
        }
        END {
            ret_code = 0;
            if($0 ~ /[0-9]+/) {
                ret_code = $0;
            };
            delete cidr_array[0];
            delete ip_array[0];
            if(ret_code == 0 && (length(cidr_array) > 0 || length(ip_array) > 0)) {
                printf "table %s {\n%s", ENVIRON["NFT_TABLE"], NFTSET_CIDR_STRING >> IP_DATA_FILE;
                if(length(cidr_array) > 0) {
                    printf "elements={%s};", writeIpList(cidr_array) >> IP_DATA_FILE;
                };
                printf "}\n%s", NFTSET_IP_STRING >> IP_DATA_FILE;

                if(length(ip_array) > 0) {
                    printf "elements={%s};", writeIpList(ip_array) >> IP_DATA_FILE;
                };
                printf "}\n}\n" >> IP_DATA_FILE;
            };
            writeFqdnEntries();
            if(ret_code == 0) {
                printf "%s %s %s %s\n", length(cidr_array), length(ip_array), length(fqdn_array), ID >> USER_ENTRIES_STATUS_FILE;
            };
            exit ret_code;
        }' -
}

AddUserEntries() {
    local _url _return_code=0 _attempt=1 _ip_data_file _dnsmasq_data_file _user_entries_status_file _str _update_string
    if [ "$ADD_USER_ENTRIES" = "1" ]; then
        if [ "$ENABLE_TMP_DOWNLOADS" = "1" ]; then
            _ip_data_file="$IP_DATA_FILE_TMP"
            _dnsmasq_data_file="$DNSMASQ_DATA_FILE_TMP"
            _user_entries_status_file="$USER_ENTRIES_STATUS_FILE_TMP"
            rm -f "$_ip_data_file" "$_dnsmasq_data_file" "$_user_entries_status_file"
        else
            _ip_data_file="$IP_DATA_FILE"
            _dnsmasq_data_file="$DNSMASQ_DATA_FILE"
            _user_entries_status_file="$USER_ENTRIES_STATUS_FILE"
        fi
        if [ "$1" = "flush" ]; then
            if [ "$ENABLE_TMP_DOWNLOADS" != "1" ]; then
                ClearDataFiles
            fi
            printf "flush set %s %s\nflush set %s %s\n" "$NFT_TABLE" "$NFTSET_CIDR" "$NFT_TABLE" "$NFTSET_IP" >> "$_ip_data_file"
        else
            printf "" > "$USER_ENTRIES_STATUS_FILE"
        fi
        if [ -f "$USER_ENTRIES_FILE" ]; then
            { cat "$USER_ENTRIES_FILE"; echo 0; } | ParseUserEntries "$_ip_data_file" "$_dnsmasq_data_file" "$_user_entries_status_file" "local"
        fi
        if [ -n "$USER_ENTRIES_REMOTE" ]; then
            for _url in $USER_ENTRIES_REMOTE
            do
                _attempt=1
                while :
                do
                    { Download - "$_url"; echo $?; } | ParseUserEntries "$_ip_data_file" "$_dnsmasq_data_file" "$_user_entries_status_file" "$_url"
                    if [ $? -eq 0 ]; then
                        break
                    else
                        _return_code=1
                        ### STDOUT
                        echo " User entries download attempt ${_attempt}: failed [${_url}]" >&2
                        MakeLogRecord "err" "User entries download attempt ${_attempt}: failed [${_url}]"
                        _attempt=$(($_attempt + 1))
                        [ $_attempt -gt $USER_ENTRIES_REMOTE_DOWNLOAD_ATTEMPTS ] && break
                        sleep $USER_ENTRIES_REMOTE_DOWNLOAD_TIMEOUT
                    fi
                done
            done
        fi
        if [ "$ENABLE_TMP_DOWNLOADS" = "1" ]; then
            if [ $_return_code -eq 0 ]; then
                if [ "$1" = "flush" ]; then
                    ClearDataFiles
                fi
                cat "$_ip_data_file" >> "$IP_DATA_FILE"
                cat "$_dnsmasq_data_file" >> "$DNSMASQ_DATA_FILE"
                mv -f "$_user_entries_status_file" "$USER_ENTRIES_STATUS_FILE"
            fi
            rm -f "$_ip_data_file" "$_dnsmasq_data_file"  "$_user_entries_status_file"
        fi
        while read _str
        do
            _update_string="$(printf "$_str" | $AWK_CMD '{
                if(NF == 4) {
                    printf "User entries (%s): CIDR: %s, IP: %s, FQDN: %s", $4, $1, $2, $3;
                };
            }')"
            if [ -n "$_update_string" ]; then
                ### STDOUT
                echo " ${_update_string}"
                MakeLogRecord "notice" "${_update_string}"
            fi
        done < "$USER_ENTRIES_STATUS_FILE"
    else
        printf "" > "$USER_ENTRIES_STATUS_FILE"
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
            _attempt=$(($_attempt + 1))
            [ $_attempt -gt $MODULE_RUN_ATTEMPTS ] && break
            sleep $MODULE_RUN_TIMEOUT
        done
        if [ $_return_code -eq 0 ]; then
            _update_string="$($AWK_CMD '{
                printf "Received entries: %s\n", (NF < 3) ? "No data" : "CIDR: "$1", IP: "$2", FQDN: "$3;
                exit;
            }' "$UPDATE_STATUS_FILE")"
            ### STDOUT
            echo " ${_update_string}"
            MakeLogRecord "notice" "${_update_string}"
            AddUserEntries
        fi

    elif [ -z "$BLLIST_PRESET" -a -z "$BLLIST_MODULE" ]; then
        ADD_USER_ENTRIES=1
        AddUserEntries flush
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
