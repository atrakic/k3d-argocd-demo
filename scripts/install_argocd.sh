#!/usr/bin/env bash

set -e
set -o pipefail


CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$CURR_DIR/common.sh"

main() {

  ARGOCD_HOST=argocd.localhost
  NS=argocd
  
  kubectl create namespace "$NS"
  kubectl apply -n "$NS" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n $NS --timeout=600s
  kubectl wait --for=condition=available deployment argocd-repo-server -n "$NS" --timeout=60s
  kubectl wait --for=condition=available deployment argocd-dex-server -n "$NS" --timeout=60s

  kubectl -n "$NS" patch deployment argocd-server --type json \
    -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]' 

  #kubectl create namespace argo-rollouts
  #kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

  kubectl apply -f ./manifests/argo.ingress_rule_traefik.yml
  #curl -v --raw -X POST --http2 -H "Content-Type: application/grpc" $ARGOCD_HOST:8443
}

main "$@"
