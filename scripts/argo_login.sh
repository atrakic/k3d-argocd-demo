#!/usr/bin/env bash

set -e
set -o pipefail

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$CURR_DIR/common.sh"

main() {
  
  # getpass: argocd v1.9 and later
  ARGOCD_HOST=argocd.localhost
  PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | xargs)
  #curl -v --raw -X POST --http2 -H "Content-Type: application/grpc" $ARGOCD_HOST:8443
  
  argocd login --insecure --username admin --password "$PASS" $ARGOCD_HOST:8443
  argocd app list
}

main "$@"
