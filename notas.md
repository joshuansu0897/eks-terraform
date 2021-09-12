### **Nodo Master**

**API Server**: A lo que todo se conecta, los agentes, el CLI, el dashboard etc. Cuando se cae un nodo master es lo que se pierde. Se usa el algoritmo de ruft para algoritmo de elección.

**Scheduler**: Cuando se deben crear un job, un pod en máquinas específicas, el scheduler se encarga de asignar las tareas y administrar los flujos de trabajos, revisando siempre las restricciones y los recursos disponibles.

**Controller Manager**: Es un proceso que está en un ciclo de reconciliación constante buscando llegar al estado deseado con base al modelo declarativo con el que se le dan instrucciones a K8s. Tipos de controller manager: Replica manager, Deployment manager, Service manager, etc.

**Etcd**: Key value store que permite que el cluster este altamente disponible.


### **Componentes muy importantes que viven en los nodos:**

**Kubelet**: Agente de kubernetes, se conecta con el control play y le pregunta que recursos (pods, contenedores) debo correr al scheduler via API Server. Monitorea los pods constantemente para saber si están vivos, los recursos disponibles etc y le comunica constantemente al scheduler via API Server.

**Kube-proxy**: Se encarga de balancear el tráfico que corre en nuestros contenedores/servicios. Una vez llega una request se encarga de decidir a que pod y contenedor debe de ir.

Todos los nodos y masters están conectados a una red física para poder hablarsen entre sí.


### **Imperativo vs Declarativo:**

Un sistema es imperativo cuando ejecuta una seria de pasos, que deben seguir un orden especifico. Si algun paso se interrumpe, la secuencia inicia desde el paso 1.
Un sistema es declarativo cuando trata de converger a un estado deseado, a partir de un estado actual.


#### **update the kubectl context** `aws eks update-kubeconfig --name example`


### **Accediendo a los contenedores**

**Cluster IP**: Una ip vitual es asignada para el servicio

**NodePort**: Un puerto es asignado para el servidor en todos los nodos

**ExternalName**: Una entrada de DNS manejada por CoreDNS

**Load Balancer**: Un loadbalancer externo es provisionado para el servicio. Solo disponible cuando se usa un servicio con un balanceador

Algoritmos para LoadBalancer https://www.nginx.com/resources/glossary/load-balancing/:
- Round-Robin
- Least Connnection
- Least Time
- Hash
- IP Hash
- Random with two choices

Kubernetes usa IPTABLES para enrutar el trafico, hacia nuestro pods y eventualmente a nuestros nodos 
no es Round Robin, es probabilistico usa `statistic mode random probability`


### **Conceptos**

**Kubectl-proxy**: es un proxy que corre en foregrown (en userspaces) que nos permite acceder a la API de K8s de manera autenticada, ya que se requiere unas credenciales para acceder con permisos de autenticación.

**Kubectl-portforward**: nos permite hacer lo mismo que el proxy pero, para acceder a cualquier puerto de un servicio que este expuesto de nuestro Cluster.

La configuración con las credenciales para acceder al Cluster de K8s están en el archivo ~/.kube/config

**DaemonSet** se asegura que todos, o algunos nodos corra una copia de un Pod. No se crean en el CLI (kubectl), sino a través de los manifest files.


### **Despliegues controlados**

**MAX SURGE**: cuantos pods se crean a partir de los que tengo, o sea que si hay 100 hasta 25 pods pueden estar creándose al mismo momento por default (25%)

**MAX UNAVAILABLE**: a lo sumo puede haber, un 25% de mis pods no disponibles (es el valor por default)


### **Healthchecks**

**Liveness**: son errores de los cuales tu app no se puede recuperar, te falta algun archivo, te falta algun parametro, va a matar el pod y levantara uno nuevo con la misma version n veces hasta que se cance

**Readiness**: Esta live, pero el pod no esta listo para recivir trafico, remueve el servicio

Tipos de Health Checks:

**ExecAction**: ejecuta un comando dentro del pod, si el comando da algo diferente de 0

**TCPSocketAction**: intenta conectarse al puerto, si se conecta esta listo para trabajar

**HTTPGetAction**: si tu app expone un server, un api, y hace una peticion a tu /help /status o /, si recive 200 es porque esta listo para trabajar

### **Helm**

Es una herramienta que nos sirve como gestor de paquetes de Kubernetes.

Conceptos:

**helm**: es el cliente de Helm.

**tiller**: es el componente del servidor. Nos sirve para recibir los comandos que le enviamos desde helm. Ya que tiller se comunica directamente con el API de Kubernetes. (pero creo que ya no existe)

**chart**: son los paquetes manejados por helm.

### **Config Map**

Un configmap es un objeto de la API utilizado para almacenar datos no confidenciales en el formato clave-valor.
Un ConfigMap te permite desacoplar la configuración de un entorno específico de una imagen de contenedor, así las aplicaciones son fácilmente portables.

Tenemos diferentes formas de configurar nuestras aplicaciones:
- Argumentos por línea de comandos
- Variables de entorno (env map en el spec)
- Archivos de configuración (config maps)
    - Guardan tanto archivo como valores clave/valor

Hay cuatro maneras diferentes de usar un ConfigMap para configurar un contenedor dentro de un Pod:
- Argumento en la linea de comandos como entrypoint de un contenedor
- Variable de enorno de un contenedor (env map en el spec)
- Como fichero en un volumen de solo lectura, para que lo lea la aplicación
- Escribir el código para ejecutar dentro de un Pod que utiliza la API para leer el ConfigMap


### **Volume**

Un volumen nos va a permitir compartir archivos entre diferentes pods o en nuestro host. 
Estos se usan para que los archivos vivan a lo largo del tiempo y el pod pueda seguir haciendo uso de estos archivos de logs, archivos de configuración o cualquier otro.

Docker:
- Permiten compartir información entre contenedores del mismo host
- Permiten acceder a mecanismo de storage
- Docker config y docker secrets

Kubernetes:
- Permiten compartir información entre contenedores del mismo pod
- Permite acceder también a mecanismo de storage
- Se utilizan para el manejo de secrets y configuraciones

Ciclo de Vida
- El volumen se crea cuando el pod se crea.
    - Esto aplica principalmente para los volúmenes emptyDir.
    - Para otro tipo se conectan en vez de crearse.
- Un volumen se mantiene aún cuando se reinicie el contenedor.
- Un volumen se destruye cuando el pod se elimina.

### **NameSpaces**

Kubernetes starts with four initial namespaces:
- **default** The default namespace for objects with no other namespace
- **kube-system** The namespace for objects created by the Kubernetes system
- **kube-public** This namespace is created automatically and is readable by all users (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.
- **kube-node-lease** This namespace for the lease objects associated with each node which improves the performance of the node heartbeats as the cluster scales.