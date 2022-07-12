kind create cluster --config=first-cluster.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl rollout status deployment --namespace=ingress-nginx ingress-nginx-controller

kubectl wait --namespace ingress-nginx \                                                                                                                                              6s ⎈ kind-kind
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

#kumactl install control-plane | kubectl apply -f -
#kubectl get pod -n kuma-system

