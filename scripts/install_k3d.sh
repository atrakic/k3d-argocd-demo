#!/usr/bin/env bash

set -e
set -o pipefail

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$CURR_DIR/common.sh"

main() {

  local agents=2

  k3d registry create registry.localhost --no-help --port 5000

  k3d cluster create "$cluster_id" --wait \
    --timeout 60s \
    --agents $agents \
    --api-port 6443 \
    --port 8080:80@loadbalancer \
    --port 8443:443@loadbalancer \
    --k3s-server-arg "--no-deploy=traefik,metrics-server" \
    --registry-use k3d-registry.localhost:5000 \
    --registry-config registries-local.yaml
    # -p "32000-32767:32000-32767@loadbalancer" //NodePort range (if you want to avoid the Ingress Controller)

  #export KUBECONFIG=$(k3d kubeconfig get "$cluster_id")
  kubectl config use-context k3d-"$cluster_id"
  #k3d kubeconfig merge "$cluster_id" -d

  kubectl cluster-info
  #kubectl describe nodes
  #kubectl --namespace=kube-system get pods,svc,ing,deploy

  #############################
  # Deploy Ingress Controller #
  #############################

  helm repo add --force-update traefik https://containous.github.io/traefik-helm-chart
  helm upgrade --install traefik traefik/traefik --wait
}

main "$@"
