#!/bin/sh

EXPIRED_DOMAINS_URL="https://raw.githubusercontent.com/fz139/free-blocked-domains/refs/heads/main/domains.lst"
EXPIRED_DOMAINS_FILE="$1"
EXPIRED_DOMAINS_FILE_TMP="${EXPIRED_DOMAINS_FILE}.tmp"
EXPIRED_DOMAINS_FILE_MIN_LINES=20000

WGET_CMD="$(which wget)"
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

Main() {
    local _lines=0 _ret_code=1
    Download "$EXPIRED_DOMAINS_FILE_TMP" "$EXPIRED_DOMAINS_URL"
    if [ $? -eq 0 -a -e "$EXPIRED_DOMAINS_FILE_TMP" ]; then
        _lines=$(cat "$EXPIRED_DOMAINS_FILE_TMP" | wc -l)
        if [ $_lines -ge $EXPIRED_DOMAINS_FILE_MIN_LINES ]; then
            mv -f "$EXPIRED_DOMAINS_FILE_TMP" "$EXPIRED_DOMAINS_FILE"
            _ret_code=0
        else
            echo " File size error!" >&2
        fi
    fi
    rm -f "$EXPIRED_DOMAINS_FILE_TMP"
    return $_ret_code
}

if [ -n "$EXPIRED_DOMAINS_FILE" ]; then
    Main $1
    exit $?
fi

echo " Usage: $(basename $0) <output file>" >&2
exit 1
