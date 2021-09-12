# create config map from a file
kubectl create configmap haproxy --from-file=haproxy.cfg

# see configmaps
kubectl get configmap haproxy -o yaml

# deploy pod
kubectl apply -f haproxy.yaml

# see pods
kubectl get pods haproxy -o wide

# port-forward - si vas a la pagina web, veremos que no redirecciona a google o a ibm
kubectl port-forward haproxy 8080:80

# creamos otro configmap, ahora pasandole los valores como parametros
kubectl create configmap registry --from-literal=http.addr=0.0.0.0:80

# deployamos el registry
kubectl apply -f  registry.yaml

# port-forward
kubectl port-forward registry 5000:5000

# no nos podemos conectar, porque lo cambiamos, ahora escucha en el 80

kubectl port-forward registry 5000:80

curl http://localhost:5000/v2/_catalog
