# Verificar si tenemos helm instalado
helm

# Configurar helm agregando un repo
helm repo add stable https://charts.helm.sh/stable

# Buscar paquetes
helm search repo
helm search repo prometheus

# Ejemplo de cómo instalar un paquete
# como quiero instalar prometheus LTS, necesitas este otro repo 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# details of prometheus
helm show all prometheus-community/prometheus
helm show chart prometheus-community/prometheus

# la instalacion se realiza de la siguiente forma
helm install --generate-name prometheus-community/prometheus --set server.service.type=NodePort --set server.persistentVolume.enabled=false

# Obtener servicios
kubectl get svc

# acceder a prometheus
kubectl port-forward svc/prometheus-xxxx-server 9090:80

# Crear helm chart
helm create dockercoins
cd dockercoins
mv templates/ templates-original
mkdir templates
cd ..

# nota, tienes que tener deployado los archivos del ejemplo 4,7 y 9
# nota, dice sh, pero realmente es un powershell
kubectl get -o yaml deployment worker | Out-File -Encoding default dockercoins/templates/worker-deployment.yaml
kubectl get -o yaml deployment hasher | Out-File -Encoding default dockercoins/templates/hasher-deployment.yaml
kubectl get -o yaml daemonset rng | Out-File -Encoding default dockercoins/templates/rng-daemonset.yaml
kubectl get -o yaml deployment webui | Out-File -Encoding default dockercoins/templates/webui-deployment.yaml
kubectl get -o yaml deployment redis | Out-File -Encoding default dockercoins/templates/redis-deployment.yaml
kubectl get -o yaml service hasher | Out-File -Encoding default dockercoins/templates/hasher-service.yaml
kubectl get -o yaml service rng | Out-File -Encoding default dockercoins/templates/rng-service.yaml
kubectl get -o yaml service webui | Out-File -Encoding default dockercoins/templates/webui-service.yaml
kubectl get -o yaml service redis | Out-File -Encoding default dockercoins/templates/redis-service.yaml

helm install --generate-name dockercoins/

# list chart instaled
helm list

# delete chart
helm delete dockercoins-xxxxx