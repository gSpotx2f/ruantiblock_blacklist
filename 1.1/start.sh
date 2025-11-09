#!/bin/sh

WORK_DIR="/opt/ruantiblock_blacklist/1.1"
OUTPUT_DIR="${WORK_DIR}/blacklist-1.1"

cd ${WORK_DIR}
${WORK_DIR}/run_parser.sh ${WORK_DIR}/ruantiblock_ip.conf ${OUTPUT_DIR}/ip && ${WORK_DIR}/run_parser.sh ${WORK_DIR}/ruantiblock_fqdn.conf ${OUTPUT_DIR}/fqdn

exit 0
