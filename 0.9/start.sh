#!/bin/sh

WORK_DIR="/opt/ruantiblock_blacklist/0.9"
OUTPUT_DIR="${WORK_DIR}/blacklist"

cd ${WORK_DIR}
${WORK_DIR}/run_parser.sh ${WORK_DIR}/ruantiblock_ip.conf ${OUTPUT_DIR}/ip && ${WORK_DIR}/run_parser.sh ${WORK_DIR}/ruantiblock_fqdn.conf ${OUTPUT_DIR}/fqdn

exit 0
