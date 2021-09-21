## aqui demostramos que un pod en el namespace default puede acceder a lo que engloba kube-system
# create a bash pod
kubectl run --image alpine -it bash

# INSIDE POD
apk add --no-cache curl
curl -k https://kubernetes.default.svc.cluster.local/
# INSIDE POD

## ahora como podemos tener la misma app en dos namespaces diferentes (estamos suponiendo que tienes el stack de helm en el namespace default)
# creamos un namespace
kubectl create namespace blue

# cambiamos el namespace
kubectl config set-context --current --namespace=blue

# instalamos el stack de helm
helm install -n blue --generate-name dockercoins/ # deberia funcionar, no es asi porque tengo que modificar el chart