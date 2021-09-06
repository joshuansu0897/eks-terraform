# get deployment of rng
kubectl get deploy/rng -o yaml > rng.out.yml

# cambiamos el Kind del archivo, de Deployment a DaemonSet
# si intentamos aplicar nos dara error, porque Deployment tiene atributos de mas, pero se puede arreglar con un flag

kubectl apply -f rng.yml --validate=false

# esto crea el DaemonSet, un DaemonSet se asegura que un pod corra en todos o casi todos los nodos

# sacamos el label
kubectl describe service rng

# hacemos get solo de los pods con ese label
kubectl get pods --selector=app=rng

# ahora vamos eliminar el labvel de un pod
kubectl label pod rng-xxxx app-

# como no tiene label, DaemonSet crea uno nuevo, pero el otro pod no se elimina, sigue existiendo