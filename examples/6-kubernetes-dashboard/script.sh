# deploy kubernetes dashboard
kubectl -f ./app.yaml apply

# para acceder al dashboard
kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard

# y actualizamos `type: ClusterIP` a `type: NodePort` aunque podemos no hacerlo, porque es un eks y necesitamos el por-forward

# y haces un port-forward
kubectl port-forward svc/kubernetes-dashboard -n kubernetes-dashboard 8080:443
# y entras a https://localhost:8080/

# tambien puedes usar 
kubectl proxy
# y entrar a http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

# creamos una cuenta y agregamos rol
kubectl -f ./eks-admin-user.yaml apply

# ahora sacamos el token del usuario 
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

# usamos el token de `Name: eks-admin-token-xxxx` en el dashboard y ya esta listo