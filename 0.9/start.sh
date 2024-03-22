#!/bin/sh

WORK_DIR="/opt/ruantiblock_blacklist"
OUTPUT_DIR="${WORK_DIR}/blacklist"

${WORK_DIR}/0.9/run_parser.sh ${WORK_DIR}/0.9/ruantiblock_ip.conf ${OUTPUT_DIR}/ip && ${WORK_DIR}/0.9/run_parser.sh ${WORK_DIR}/0.9/ruantiblock_fqdn.conf ${OUTPUT_DIR}/fqdn

exit 0
