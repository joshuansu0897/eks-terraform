# deploy pods
kubectl apply -f examples/12-volume/nginx-with-volume.yaml

# vemos los pods - habra uno en ejecucion y otro terminado, esto pasa por restartPolicy: OnFailure y termina con 0, o sea, no fallo
kubectl get pod nginx-with-volume

# para mas detalles
kubectl describe pod nginx-with-volume

# port-forward nginx-with-volume
kubectl port-forward nginx-with-volume 8080:80