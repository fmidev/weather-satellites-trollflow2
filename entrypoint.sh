#!/usr/bin/bash

_term() {
  echo "Entrypoint caught SIGTERM signal"
  kill -TERM "$child" 2>/dev/null
  echo "Waiting for child process to exit"
  wait "$child"
}

trap _term SIGTERM

source /opt/conda/.bashrc
source /config/env-variables

# Collect all message sources together with '-a' argument
MESSAGE_SOURCES=""
for m in $MESSAGE_SOURCE; do
    MESSAGE_SOURCES="-a $m ${MESSAGE_SOURCES}"
done

micromamba activate
/opt/conda/bin/satpy_launcher.py -n false ${MESSAGE_SOURCES} -c /config/trollflow2_log_config.yaml /config/trollflow2.yaml &

child=$!

wait "$child"
