# Create a deployment with the image jpetazzo/httpenv
kubectl create deployment httpenv --image=jpetazzo/httpenv:latest

# Scale the deployment to 10 replicas
kubectl scale deployment httpenv --replicas=10

sleep 5

# list pods
kubectl get pods -o wide

# expose the deployment as a service (this create a ClusterIP service)
kubectl expose deployment httpenv --port=8888

# for this example you are using EKS, so, you can't make curls to the service, you need connecto to the pod
kubectl exec -it httpenv-xxxxxxxx -- /bin/sh

## inside container
wget -qO- http://service-ip:8888
# 10 times
##

# NOTAS
# si miras detalladamente, cada HOSTNAME es diferente
# Kubernetes usa IPTABLES para enrutar el trafico, hacia nuestro pods y eventualmente a nuestros nodos 
# no es Round Robin, es probabilistico usa `statistic mode random probability`
