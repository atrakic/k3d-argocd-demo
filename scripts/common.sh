#!/bin/bash

CMD=k3s
command -v $CMD >/dev/null 2>&1 || curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

CMD=argocd
command -v $CMD >/dev/null 2>&1 || curl -sSL -o /usr/local/bin/argocd \
  https://github.com/argoproj/argo-cd/releases/download/"$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')"/argocd-linux-amd64 \
  chmod +x /usr/local/bin/argocd

CMD=helm
command -v $CMD >/dev/null 2>&1 || curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

PATH=/usr/local/bin:$PATH
export PATH

cluster_id=${cluster_id:-argocd}
export cluster_id
