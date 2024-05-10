#!/usr/bin/bash

source /opt/conda/.bashrc
source /config/env-variables

# Collect all message sources together with '-a' argument
MESSAGE_SOURCES=""
for m in $MESSAGE_SOURCE; do
    MESSAGE_SOURCES="-a $m ${MESSAGE_SOURCES}"
done

micromamba activate
/opt/conda/bin/satpy_launcher.py -n false ${MESSAGE_SOURCES} -c /config/trollflow2_log_config.yaml /config/trollflow2.yaml
