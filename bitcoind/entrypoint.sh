#!/bin/bash
set -e

############ /logs ######################
#chmod 777 /logs

############ /config ######################
if [[ ! -s "/config/supervisord.conf" ]]; then
    cp /default/supervisord.conf /config/supervisord.conf
fi

if [[ ! -s "/config/bitcoin.conf" ]]; then
    cp /default/bitcoin.conf /config/bitcoin.conf
	chown bitcoin:bitcoin "/config/bitcoin.conf"
fi

############ /data ######################
chown -R bitcoin /data

############ /secrets ######################
chown -R bitcoin /secrets

exec /usr/bin/supervisord -c /config/supervisord.conf
