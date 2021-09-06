# para ver todos los deplyoments en formato json
kubectl get deploy -o json

# mucha info, asi que usaremos jq para filtar lo que nos interesa
kubectl get deploy -o json | jq ".items[] | {name:.metadata.name} + .spec.strategy.rollingUpdate"

# esto nos muestra la strategia
# ejemplo
# {
#   "name": "hasher",
#   "maxSurge": "25%",
#   "maxUnavailable": "25%"
# }

# en una nueva terminal, 
kubectl get replicasets -w

# Cambiamos la imagen del deploy y le decimos que worker tenga la imagen dockercoins/worker:0.2
kubectl set image deploy worker worker=dockercoins/worker:v0.2

# Cambiamos la imagen del deploy a algo no existente
kubectl set image deploy worker worker=dockercoins/worker:noexiste

# Si le mandamos una imagen que no existe o está rota, va a cabmiar el 25% de los pods para usar la nueva version
# mantendra el 75% con la version antigua para siempre tener servicio, si todo sale bien seguira atualizando los pods de 25% en 25%

# hacemos un rollback a la versión anterior.
kubectl rollout undo deploy worker

# Para cambiar la estrategia de deployment: 
kubectl edit deploy worker

# cambiamos de 25% los dos valores a maxSurge: 1 y maxUnavailable: 0
# Si pongo maxsurge en 1, solo se va a crear como maximo un pod nuevo por cada nuevo deployment. 
# Si pongo maxunavailable en 0, no van a haber pods unavailables a la hora de hacer deployments. 
# Esta estrategia es bastante conservadora: quiero crear de a uno y hasta que ese no este disponible, no cambies nada.

# para saber como va el deployment
kubectl rollout status deploy worker