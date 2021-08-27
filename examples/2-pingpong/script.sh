# create pods with thre run command
kubectl.exe run ping --image alpine ping 1.1.1.1

# this create a yaml output (-o yaml) with the pod information, but --dry-run makes it not create the pod
kubectl.exe run --dry-run -o yaml ping2 --image alpine ping 1.1.1.1

# apply a yaml file
kubectl apply -f ./app.yml

sleep 5

# logs tail
kubectl.exe logs deploy/pingpong-deployment --tail 10

sleep 5

# labels
kubectl.exe logs -l app=pingpong

sleep 5

# scale
kubectl.exe scale deploy/pingpong-deployment --replicas=8