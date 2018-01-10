#!/bin/bash
#
# Entrypoint script for currency daemon container

set -e

source ./ep_lib.sh

########## /config #################################################
check_config supervisord.conf
check_config parity.conf parity:parity 0640

############ bootstrap process #####################################
bootstrap_if_required chains

########## /data ###################################################
chown -R parity /data

############ /secrets ##############################################
chown -R parity /secrets

exec /usr/bin/supervisord -c /config/supervisord.conf
