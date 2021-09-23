# Crear el service account
kubectl create sa viewer

# Crear el RoleBinding
kubectl create rolebinding viewercanview2 --clusterrole=view --serviceaccount=default:viewer

# Correr el pod
kubectl run eyepod --rm -ti --restart=Never --serviceaccount=viewer --image alpine

# Dentro del pod --, obtener la última versión estable de kubernetes
apk add --no-cache curl
curl https://storage.googleapis.com/kubernetes-release/release/stable.txt

# Descargar la versión de kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.1/bin/linux/amd64/kubectl

# Hacer a kubectl ejecutable

chmod +x ./kubectl

# Obtener todo

./kubectl get all

# Preguntas de authorization

./kubectl auth can-i list nodes

./kubectl auth can-i create pods

./kubectl auth can-i get pods

# Obtener RoleBindings

kubectl get clusterrolebindings -o yaml | grep -e kubernetes-admin -e system:masters

kubectl describe clusterrolebinding cluster-admin