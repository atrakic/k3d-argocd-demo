#!/usr/bin/env bash

set -e
set -o pipefail


CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$CURR_DIR/common.sh"

main() {

  NS=argocd
  kubectl create namespace "$NS"
  
  kubectl apply -n "$NS" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n $NS --timeout=600s
  kubectl -n "$NS" patch deployment argocd-server --type json \
    -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]' 

  kubectl wait --for=condition=available deployment argocd-repo-server --timeout=60s -n "$NS"
  kubectl wait --for=condition=available deployment argocd-dex-server --timeout=60s -n "$NS"

  #kubectl create namespace argo-rollouts
  #kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

  # Ingress
  ARGOCD_HOST=argocd.localhost
  kubectl apply -f ./manifests/argo.ingress_rule_traefik.yml
  kubectl -n "$NS" get pods,svc,ing,deploy
  sleep 1
  curl -skSL -H "Host: $ARGOCD_HOST" localhost:8080

  # getpass: argocd v1.9 and later
  PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | xargs)
  argocd login --insecure --username admin --password "$PASS" argocd.k3d.local:8080
  argocd app list
}

main "$@"
