#!/usr/bin/env bash

set -e
set -o pipefail

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$CURR_DIR/common.sh"

main() {

  # Deploy gitops app
  APP=guestbook
  NS=dev
  
  kubectl create namespace "$NS"
  argocd app create $APP --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace "$NS"
  argocd app sync $APP
  kubectl apply -f manifests/guestbook-ui.ingress.yml -n "$NS"
}

main "$@"
