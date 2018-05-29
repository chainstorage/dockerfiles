#!/bin/bash
#
# Entrypoint script for currency daemon container

set -e

source ./ep_lib.sh

########## /logs ###################################################
chown neo /logs

########## /config #################################################
check_config supervisord.conf
check_config config.json neo:neo 0640

############ bootstrap process #####################################
bootstrap_if_required blocks

########## /data ###################################################
chown -R neo /data

############ /secrets ##############################################
chown -R neo /secrets

exec /usr/bin/supervisord -c /config/supervisord.conf
