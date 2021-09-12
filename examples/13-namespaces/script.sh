# show all namespaces
kubectl get namespaces
kubectl get ns

# show pods in kube-system namespace
kubectl get pod -n kube-system

# create a new namespace
kubectl create namespace dbz

# ver el context
kubectl config get-contexts

# Mover de contexto o namespaces
kubectl config set-context --current --namespace=dbz
kubectl config get-contexts