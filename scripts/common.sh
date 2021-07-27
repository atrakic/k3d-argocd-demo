#!/bin/bash

cluster_id=${cluster_id:-argocd}
export cluster_id

command -v k3d >/dev/null 2>&1  || curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

ARGO_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
command -v argocd >/dev/null 2>&1  || curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/"$ARGO_VERSION"/argocd-linux-amd64

PATH=/usr/local/bin:$PATH
export PATH
