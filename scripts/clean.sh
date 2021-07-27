#!/usr/bin/env bash

set -e
set -o pipefail

k3d cluster delete --all
k3d registry delete --all
