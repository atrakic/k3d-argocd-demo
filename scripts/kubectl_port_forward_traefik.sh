kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000
# kubectl port-forward svc/argocd-server -n argocd 8080:443
