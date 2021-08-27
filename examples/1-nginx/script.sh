# create namespace
kubectl create namespace example

sleep 5

# apply a yaml file
kubectl apply -f ./app.yml

sleep 5

# show info from the namespace
kubectl get all -n example

sleep 5

# describre the service
kubectl -n example describe service my-service

sleep 5 

# describe a pod
kubectl -n example describe pod my-deployment-xxxxxxx

sleep 5

# conect to the pod
kubectl exec -it my-deployment-xxxxxxx -n example -- /bin/bash

# inside pod - DNS resolution conf
cat /etc/resolv.conf

# inside pod - disconect from pod
exit

sleep 5

# clean up
kubectl delete namespace example