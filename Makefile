ARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEFLAGS += --silent

NS := dev
APP := argo-demo

.PHONY: install_k3d install_argocd argo_login status test clean

all: install

install: install_k3d install_argo argo_login build-local
	echo "Installing ${APP} with argocd ..."
	kubectl create namespace ${NS}
	argocd app create ${APP} \
		--repo https://github.com/atrakic/k3d-argocd-demo.git \
		--path apps/covid19-dashboard/k8s-specifications \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace ${NS} --directory-recurse
	argocd app sync ${APP}
	#kubectl apply -f argocd/covid19-dashboard-app.yml

install_k3d install_argocd build-local argo_login:
	./scripts/$@.sh

status:
	k3d cluster ls
	echo
	kubectl get deployment,svc,po,ing,rs -o wide
	echo
	argocd app list

clean:
	echo -n "Are you sure? (Press Enter to continue or Ctrl+C to abort) "
	read _ 
	./scripts/clean.sh

test:
	[ -f ./test/test.sh ] && ./test/test.sh

-include include.mk
