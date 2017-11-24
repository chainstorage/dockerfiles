#!/bin/bash
#
# Entrypoint script for currency daemon container

set -e

source ./ep_lib.sh

########## /logs ###################################################
#chmod 777 /logs

########## /config #################################################
check_config supervisord.conf
check_config bitcoin.conf bitcoin:bitcoin 0640

########## /data ###################################################
chown -R bitcoin /data

############ /secrets ##############################################
chown -R bitcoin /secrets

############ bootstrap process #####################################
bootstrap_if_required blocks

exec /usr/bin/supervisord -c /config/supervisord.conf
