# Share library for containers' entrypoints
#
# Provided functions:
# echo_log
# echo_err
# check_config
# check_kv_config
# bootstrap_if_required

######################################################################
# Print to stdout with date-time prefix
# [2017-11-20T15:43:35+0000]: hello
# Arguments:
#   message - optional, example: hello
######################################################################
echo_log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@"
}

######################################################################
# Print to stderr with date-time prefix
# [2017-11-20T15:43:35+0000]: error
# Arguments:
#   message - optional, example: error
######################################################################
echo_err() {
  echo_log "$@" >&2
}

######################################################################
# Check for config presence and copy default configuration if required
# Arguments:
#   config_name  - required, example: bitcoin.conf
#   chown_string - optional, example: bitcoin:bitcoin
#   chmod_string - optional, example: 0755
######################################################################
check_config() {
  local default_path='/default/'
  local runtime_path='/config/'
  if [[ $# -lt 1 ]]; then
    echo_err "[${FUNCNAME[0]}] No config_name specified"
    exit 1
  fi
  local config_name="$1"
  echo_log "Checking for '${config_name}' config file in ${runtime_path}"
  if [[ ! -s "${runtime_path}${config_name}" ]]; then
    echo_log "Not found or empty. Will copy defaults now."
    cp -v "${default_path}${config_name}" "${runtime_path}${config_name}"
    if [[ $# -ge 2 ]]; then
      echo_log "Will do 'chown $2 ${runtime_path}${config_name}' now"
      chown $2 "${runtime_path}${config_name}"
    fi
    if [[ $# -ge 3 ]]; then
      echo_log "Will do 'chmod $3 ${runtime_path}${config_name}' now"
      chmod $3 "${runtime_path}${config_name}"
    fi
  else
    echo_log "Runtime configuration found. Ok."
  fi
}

######################################################################
# Check for centralized KV config with consul-template
#   and overwrite current runtime config with generated one
# Will do nothing if DISABLE_KV_CONFIG env var is set
# Arguments:
#   config_name   - required, example: bitcoin.conf
#   template_path - required, example: /daemon.conf.tpl
#   chown_string  - optional, example: bitcoin:bitcoin
#   chmod_string  - optional, example: 0755
######################################################################
check_kv_config() {
  if [[ -v DISABLE_KV_CONFIG ]]; then
    echo_log "DISABLE_KV_CONFIG is set. Skipping KV config discovery."
  else
    if [[ $# -lt 2 ]]; then
      echo_err "[${FUNCNAME[0]}] No config_name and/or template_path specified"
      exit 1
    fi
    local config_name="$1"
    local template_path="$2"
    local runtime_path='/config/'
    local tmp_file='/config/.kv_config_result'
    echo_log "Trying to generate configuration from KV store"
    echo_log "CONSUL_HTTP_ADDR = ${CONSUL_HTTP_ADDR}"
    consul-template -log-level=err \
                    -template "${template_path}:${tmp_file}" -once
    if grep -qv '^[[:space:]]*$' "${tmp_file}" ; then
      # if generated config is not empty
      touch -a "${runtime_path}${config_name}"
      if diff "${runtime_path}${config_name}" "${tmp_file}" >/dev/null ; then
        echo_log "Config generated from KV is identical to runtime. Skipping."
      else
        echo_log "Config generated from KV is different:"
        diff "${runtime_path}${config_name}" "${tmp_file}" || /bin/true
        echo_log "Updating runtime config ${runtime_path}${config_name}"
        cp "${tmp_file}" "${runtime_path}${config_name}"
        if [[ $# -ge 3 ]]; then
          echo_log "Will do 'chown $3 ${runtime_path}${config_name}' now"
          chown $3 "${runtime_path}${config_name}"
        fi
        if [[ $# -ge 4 ]]; then
          echo_log "Will do 'chmod $4 ${runtime_path}${config_name}' now"
          chmod $4 "${runtime_path}${config_name}"
        fi
      fi
    else
      echo_log "Generated config is empty (no data available?). Skipping."
    fi
    rm -f --preserve-root "${tmp_file}"
  fi
}


######################################################################
# Executes bootstrap command if test_path file/directory is absent
#   inside data directory and there is 'bootstrap' file with command
# Arguments:
#   test_path  - required, example: blocks
######################################################################
bootstrap_if_required() {
  if [[ $# -lt 1 ]]; then
    echo_err "[${FUNCNAME[0]}] No test_path specified"
    exit 1
  fi
  local test_path="$1"

  # Generate example bootstrap file if required
  if [[ ! -s /data/bootstrap.example ]]; then
    echo_log "Generating bootstrap.example"
    cat << EXAMPLE > /data/bootstrap.example
# Chainstorage.io bootstrap example
#
# You can create 'bootstrap' file with the following command
#   to fetch snapshotted blockchain data.
#
# Usage: FETCH <url> [user] [password]

FETCH https://bitcoind.chainstorage.io/last/ user password
EXAMPLE
  fi

  echo_log "Checking if /data/${test_path} exist."
  if [[ -e "/data/${test_path}" ]]; then
    echo_log "Path found, skipping any bootstrap processes."
  else
    echo_log "Path not found."
    if [[ -s /data/bootstrap ]]; then
      echo_log "Processing bootstrap file..."
      local cmd_str
      local cmd_list
      local cmd_name
      local cmd_url
      local cmd_user
      local cmd_pass
      # remove comments and empty lines from file, take only one line
      cmd_str="$(awk '!/^ *#/ && NF' /data/bootstrap | head -n 1)"
      cmd_list=(${cmd_str})
      # cmd_name in lowercase
      cmd_name="${cmd_list[0],,}"
      cmd_url="${cmd_list[1]}"
      cmd_user="${cmd_list[2]}"
      if [[ -n "${cmd_user}" ]]; then
        cmd_user="--user=${cmd_user}"
      fi
      cmd_pass="${cmd_list[3]}"
      if [[ -n "${cmd_pass}" ]]; then
        cmd_pass="--password=${cmd_pass}"
      fi
      case "${cmd_name}" in
        fetch)
          echo_log "FETCH command found."
          if [[ -z "${cmd_url}" ]]; then
            echo_err "No URL to fetch. Use 'FETCH https://some.url'"
            exit 1
          fi
          echo_log "Will try to fetch '${cmd_url}' url now."

          # Must detect redirection here because wget will not make
          # recursive download if /last/ -> /20170101-1010/ due to
          # --no-parent flag.
          local redir_args=("${cmd_user}" "${cmd_pass}" "${cmd_url}")
          local redir_url
          redir_url="$(wget -O /dev/null ${redir_args[@]} 2>&1 \
                       | grep '\[following\]' \
                       | tail -n 1 \
                       | grep -o 'http[^ ]*' \
                       || /bin/true)"
          if [[ -n "${redir_url}" ]]; then
            echo_log "Redirected to: ${redir_url}"
            cmd_url="${redir_url}"
          fi

          # Actual recursive download of redirected url
          local wget_args=("${cmd_user}" "${cmd_pass}" "${cmd_url}")
          wget --recursive --level=10 --reject='index.html*' \
            --relative --no-parent --no-verbose \
            --no-host-directories --cut-dirs=1 \
            --directory-prefix=/data/ "${wget_args[@]}"
          echo_log "Done fetching."
          ;;
        *)
          echo_err "Unexpected bootstrap command '${cmd_name}'!"
          exit 1
          ;;
      esac
    fi
  fi
}
