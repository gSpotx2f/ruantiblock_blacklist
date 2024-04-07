#!/bin/sh

WORK_DIR="/opt/ruantiblock_blacklist"
OUTPUT_DIR="${WORK_DIR}/blacklist-1.1"

${WORK_DIR}/1.1/run_parser.sh ${WORK_DIR}/1.1/ruantiblock_ip.conf ${OUTPUT_DIR}/ip && ${WORK_DIR}/1.1/run_parser.sh ${WORK_DIR}/1.1/ruantiblock_fqdn.conf ${OUTPUT_DIR}/fqdn

exit 0
