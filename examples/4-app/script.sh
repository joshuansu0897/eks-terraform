# deploy redis
kubectl apply -f ./redis.yml
kubectl create deployment redis --image=redis

# deploy hasher
kubectl apply -f ./hasher.yml
kubectl create deployment hasher --image=dockercoins/hasher:v0.1

# deploy rng
kubectl apply -f ./rng.yml
kubectl create deployment rng --image=dockercoins/rng:v0.1

# deploy webui
kubectl apply -f ./webui.yml
kubectl create deployment webui --image=dockercoins/webui:v0.1

# deploy worker
kubectl apply -f ./worker.yml
kubectl create deployment worker --image=dockercoins/worker:v0.1

# then expose the services (this is necesary just if you didn't use the yaml files)
kubectl expose deployment redis --port=6379
kubectl expose deployment rng --port=80
kubectl expose deployment hasher --port=80

# expose the webui
kubectl expose deployment webui --port=80 --type=NodePort

# or use kubectl port-forward (on this case EKS is the only way to access the webui)
kubectl.exe port-forward svc/webui 8080:80