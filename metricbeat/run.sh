#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

ELASTICSEARCH_HOST=$(jq --raw-output ".elasticsearch_host" $CONFIG_PATH)
ELASTICSEARCH_PORT=$(jq --raw-output ".elasticsearch_post" $CONFIG_PATH)
ELASTICSEARCH_USER=$(jq --raw-output ".elasticsearch_user" $CONFIG_PATH)
ELASTICSEARCH_PSWD=$(jq --raw-output ".elasticsearch_password" $CONFIG_PATH)

ESARGS=-E output.elasticsearch.hosts=["${ELASTISEARCH_HOST}:${ELASTISEARCH_PORT}"]
if [ -n "$ELASTICSEARCH_USER" ]; then
  ESARGS=${ESARGS} -E output.elasticsearch.username="${ELASTISEARCH_USER}"
fi
if [ -n "$ELASTICSEARCH_PSWD" ]; then
  ESARGS=${ESARGS} -E output.elasticsearch.password="${ELASTISEARCH_PSWD}"
fi
metricbeat -e ${ESARGS}
