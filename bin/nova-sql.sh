#!/usr/bin/env bash

usage() {
  echo "start_psql -a app -e environment [-n namespace] [-w] [-m]"
  echo "    -a: app to use (core or habu)"
  echo "        can be omitted if using direnv and current working directory is corresponding project"
  echo "    -m: use migration credentials for core (might have more rights)"
  echo "    -e: environment to use (dev, staging, qa, preprod, prod)"
  # shellcheck disable=SC2016
  echo '    -n: namespace to use in that environment (default: jinko-$env)'
  echo "    -w: open in write mode (default: read-only. Unsafe, not enforced!)"
}

: "${APP:=}"
: "${ENVIRONMENT:=}"
: "${WRITE_MODE:=no}"
: "${MIGRATION:=no}"

while getopts "a:e:n:hwm" o; do
  case "${o}" in
  a)
    APP="${OPTARG}"
    ;;
  e)
    ENVIRONMENT="${OPTARG}"
    ;;
  n)
    NAMESPACE="${OPTARG}"
    ;;
  w)
    WRITE_MODE="yes"
    ;;
  m)
    MIGRATION="yes"
    ;;
  h)
    usage
    exit 1
    ;;
  *)
    break
    ;;
  esac
done

shift $((OPTIND - 1))

if [ -z "$APP" ]; then
  case "${DIRENV_SUBPATH:-}" in
  /jinko/jinko)
    APP=core
    ;;
  /jinko/dorayaki/habu)
    APP=habu
    ;;
  esac
fi

if [ -z "$APP" ] || [ -z "$ENVIRONMENT" ]; then
  usage
  exit 1
fi

: "${NAMESPACE:=jinko-${ENVIRONMENT}}"

# if ! tailscale status --json | jq -e '.BackendState == "Running"' >/dev/null 2>/dev/null; then
#   echo "Please connect to VPN first" >&2
#   exit 1
# fi

case "$APP" in
habu)
  secret_name="jinko-habu-env-"
  connection_info=".HABU_SERVICE_DATABASE_PASSWORD"
  ;;
core)
  if [ "$MIGRATION" = "yes" ]; then
    secret_name="jinko-core-webservice-migration-env-"
  else
    secret_name="jinko-core-webservice-env-"
  fi
  connection_info=".POSTGRESQL_CONNECTION"
  ;;
*)
  echo "Unknown app $APP" >&2
  exit 1
  ;;
esac

if [ "$WRITE_MODE" != "yes" ]; then
  export PGOPTIONS="-c default_transaction_read_only=on"
fi

# shellcheck disable=SC2016
context=$(kubectl config view | yq --arg environment "$ENVIRONMENT" -r '.contexts[]|select(.context.cluster | endswith("cluster/jk-" + $environment))|.name' | tail -n1)
if [ -z "$context" ]; then
  echo "need kube access to ${ENVIRONMENT} cluster, see setup at https://docs.google.com/document/d/1IzXOjJPQI5mN364Etf8dzwTCDBZ_fOeTRvZjlk7N9aM/edit"
  exit 1
else
  SECRET=$(kubectl --context="$context" get --namespace "${NAMESPACE}" "$(kubectl --context="$context" get --namespace "${NAMESPACE}" secrets -o name | grep "^secret/$secret_name" | head -n1)" -o jsonpath='{.data}' | jq -r "${connection_info}" | base64 -d)
  export PGOPTIONS="${PGOPTIONS:-}${PGOPTIONS:+ }-c search_path=${APP}"
  echo "Connecting to $APP database (schema ${APP}) in ${ENVIRONMENT}" >&2
  case "$APP" in
  habu)
    CONFIGMAP=$(kubectl --context="$context" get --namespace "${NAMESPACE}" configmaps -o name | grep ^configmap/jinko-backend-habu-config- | head -n1)
    CONFIG=$(kubectl --context="$context" get --namespace "${NAMESPACE}" "$CONFIGMAP" -o jsonpath='{.data}' | jq -r '."production.yml"')
    DATABASE=$(echo "$CONFIG" | yq -r .service.database.database)
    HOST=$(echo "$CONFIG" | yq -r .service.database.host)
    USERNAME=$(echo "$CONFIG" | yq -r .service.database.username)
    export PGPASSWORD=$SECRET
    psql -h "$HOST" -U "$USERNAME" "$DATABASE" "$@"
    ;;
  core)
    echo "$SECRET"
    # psql "$SECRET" "$@"
    ;;
  esac
fi
