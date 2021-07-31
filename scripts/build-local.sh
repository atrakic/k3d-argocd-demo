#!/usr/bin/env bash

set -e
set -o pipefail

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$CURR_DIR/common.sh"

VERSION=${1:-v0.0.1}
APP=covid19-dashboard
IMAGE=localhost/$APP:$VERSION
REGISTRY=localhost:5000 # registry.localhost

docker build -t $IMAGE -f ./apps/covid19-dashboard/src/Dockerfile .
docker tag $IMAGE $REGISTRY/$IMAGE
docker push $REGISTRY/$IMAGE
k3d image import $IMAGE -c "$cluster_id" --verbose

#kubectl run --image $REGISTRY/$IMAGE test-$APP --command -- tail -f /dev/null
#kubectl rollout restart deployment $APP
