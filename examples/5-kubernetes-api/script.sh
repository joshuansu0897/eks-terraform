# Muetra el ClusterIp
kubectl get svc kubernetes

# esto nos regresa el servicio de kubernetes que tiene una ip privada y un ssl
# si el master node esta en tu red, puedes usar esa ip para entrar a la api de kubernetes
# en el caso de EKS, para acceder a la api AWS crea un endpoint, eso siempre es auto generado en la creacion del cluster EKS
# aun asi, para acceder a esta api, tienes que autenticarte

# para acceder a la api con tus credenciales tienes que usar
kubectl proxy
