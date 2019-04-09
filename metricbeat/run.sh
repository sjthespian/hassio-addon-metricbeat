#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

ELASTICSEARCH_HOST=$(jq --raw-output ".elasticsearch_host" $CONFIG_PATH)
ELASTICSEARCH_PORT=$(jq --raw-output ".elasticsearch_port" $CONFIG_PATH)
ELASTICSEARCH_USER=$(jq --raw-output ".elasticsearch_user" $CONFIG_PATH)
ELASTICSEARCH_PSWD=$(jq --raw-output ".elasticsearch_password" $CONFIG_PATH)

ESARGS="-E output.elasticsearch.hosts=[\"${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}\"]"
if [ -n "$ELASTICSEARCH_USER" ]; then
  ESARGS="${ESARGS} -E output.elasticsearch.username=\"${ELASTICSEARCH_USER}\""
fi
if [ -n "$ELASTICSEARCH_PSWD" ]; then
  ESARGS="${ESARGS} -E output.elasticsearch.password=\"${ELASTICSEARCH_PSWD}\""
fi
/usr/bin/metricbeat -e ${ESARGS}
