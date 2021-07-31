# k3d-argocd-demo

This repo demonstrates how to use [Argo CD](https://argoproj.io/) to build and deploy a private image on [k3d](https://github.com/rancher/k3d) with [Traefik v2](https://doc.traefik.io/traefik/v2.0/).

## Demo
| Application | Description |
|-------------|-------------|
| [Argo CD login](https://argocd.localhost:8443/) | |
| [Covid19 app](http://covid19.localhost:8080/) | a web app as plain YAML|


## Deployment
```
$ make


$ argocd app list
NAME       CLUSTER                         NAMESPACE  PROJECT  STATUS  HEALTH       SYNCPOLICY  CONDITIONS  REPO                                            PATH                                       TARGET
argo-demo  https://kubernetes.default.svc  dev        default  Synced  Progressing  <none>      <none>      https://github.com/atrakic/k3d-argocd-demo.git  apps/covid19-dashboard/k8s-specifications
```
