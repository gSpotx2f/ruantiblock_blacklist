#!/bin/sh

AF_IP_FULL_URL="https://antifilter.download/list/ipresolve.lst"
#AF_IP_URL="https://antifilter.download/list/ip.lst"
AF_NET_URL="https://antifilter.download/list/subnet.lst"
AF_FQDN_URL="https://antifilter.download/list/domains.lst"
AF_DIR="./af"
AF_IP_FILE="${AF_DIR}/ipresolve.lst"
AF_IP_FILE_TMP="${AF_IP_FILE}.tmp"
AF_NET_FILE="${AF_DIR}/subnet.lst"
AF_NET_FILE_TMP="${AF_NET_FILE}.tmp"
AF_FQDN_FILE="${AF_DIR}/domains.lst"
AF_FQDN_FILE_TMP="${AF_FQDN_FILE}.tmp"
AF_IP_FILE_MIN_LINES=10000
AF_NET_FILE_MIN_LINES=100
AF_FQDN_FILE_MIN_LINES=20000

WGET_CMD=$(which wget)
if [ $? -ne 0 ]; then
    echo " Error! Wget doesn't exists" >&2
    exit 1
fi
WGET_PARAMS="--no-check-certificate -q -O"

Download() {
    $WGET_CMD $WGET_PARAMS "$1" "$2"
    if [ $? -ne 0 ]; then
        echo " Downloading failed! Connection error (${2})" >&2
        return 1
    fi
}

GetFile() {
    local _lines=0 _ret_code=1 _file="$1" _file_tmp="$2" _min_lines=$3 _url="$4"
    Download "$_file_tmp" "$_url"
    if [ $? -eq 0 -a -e "$_file_tmp" ]; then
        _lines=$(head -n $_min_lines "$_file_tmp" | wc -l)
        if [ $_lines -ge $_min_lines ]; then
            mv -f "$_file_tmp" "$_file"
            _ret_code=0
        else
            echo " File size error!" >&2
        fi
    fi
    rm -f "$_file_tmp"
    return $_ret_code
}

exit_code=1


### antifilter.download

if [ ! -d "$AF_DIR" ]; then
    mkdir -p "$AF_DIR"
fi

GetFile "$AF_IP_FILE" "$AF_IP_FILE_TMP" $AF_IP_FILE_MIN_LINES "$AF_IP_FULL_URL"
if [ $? -eq 0 ]; then
    exit_code=0
fi
GetFile "$AF_NET_FILE" "$AF_NET_FILE_TMP" $AF_NET_FILE_MIN_LINES "$AF_NET_URL"
if [ $? -eq 0 ]; then
    exit_code=0
fi
GetFile "$AF_FQDN_FILE" "$AF_FQDN_FILE_TMP" $AF_FQDN_FILE_MIN_LINES "$AF_FQDN_URL"
if [ $? -eq 0 ]; then
    exit_code=0
fi

### commit

if [ $exit_code -eq 0 ]; then
    git config user.name github-actions
    git config user.email github-actions@github.com
    git add .
    git commit -m "Lists downloaded: $(date -u "+%Y-%m-%d %H:%M %z")"
    git push
fi


exit $exit_code
