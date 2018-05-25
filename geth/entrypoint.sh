#!/bin/bash
#
# Entrypoint script for currency daemon container

set -e

source ./entrypoint_lib.sh

########## /logs ###################################################
#chmod 777 /logs

########## /config #################################################
check_config supervisord.conf
check_config geth.toml geth:geth 0640

############ bootstrap process #####################################
#bootstrap_if_required blocks

########## /data ###################################################
chown -R geth /data

############ /secrets ##############################################
chown -R geth /secrets

exec /usr/bin/supervisord -c /config/supervisord.conf
