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

########## data symlink hack #######################################
# https://github.com/bitcoin/bitcoin/pull/11343#issuecomment-329874563
# As long as bitcoin daemon doesn't allow wallet.dat symlinking to
# have data on fast disks and wallet.dat on crypted disk
# we will symlink 'blocks' and 'chainstate' directories
#   /secrets will be our datadir and symlinks
#   /secrets/blocks -> /data/blocks
#   /secrets/chainstate -> /data/chainstate

check_symlink() {
  # cretes symlink if absent or throws fatal error if there's a directory
  local subdir="$1"
  if [[ ! -e "/secrets/${subdir}" ]]; then
    # if no 'subdir' in secrets, create symlink
    ln -s "/data/${subdir}" "/secrets/${subdir}"
  elif [[ ! -L "/secrets/${subdir}" ]]; then
    # 'subdir' exists, but not symlink
    echo_err "Fatal error: /secrets/${subdir} should link to /data/${subdir}"
    exit 1
  fi
}

if grep -q 'datadir.*=.*/secrets' /config/bitcoin.conf; then
  echo_log "Detected '/secrets' as datadir in config, applying symlink hack"
  mkdir -p /data/blocks && chown bitcoin:bitcoin /data/blocks
  mkdir -p /data/chainstate && chown bitcoin:bitcoin /data/chainstate
  check_symlink "blocks"
  check_symlink "chainstate"
  # We could have just bootstrapped our data from chainstorage
  # So move everything from /data except GLOBIGNORE pattern to /secrets
  GLOBIGNORE=/data/blocks:/data/chainstate:/data/bootstrap*
  mv -v -n /data/* /secrets/ 2>/dev/null || /bin/true
  unset GLOBIGNORE
fi

exec /usr/bin/supervisord -c /config/supervisord.conf
