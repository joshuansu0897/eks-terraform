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

Los namespaces no proveen aislación de recursos
Un pod en un namespace A puede comunicarse con otro namespace B
Un pod en el namespace default puede comunicarse con otro en el kube-system
Desde cualquier pod en el Cluster podemos comunicarlos a la api de K8S desde este ednpoint https://kubernetes.default.svc.cluster.local/

### **Autenticación y autorización**

**Autenticación** es el método por el cual Kubernetes deja ingresar a un usuario.
**Autorización** es el mecanismo para que un usuario tenga una serie determinada de permisos para realizar ciertas acciones sobre el cluster.

- Cuando el API server recibe un request intenta autorizarlo con uno o más de uno de los siguientes métodos: Certificados TLS, Bearer Tokens, Basic Auth o Proxy de autenticación.
- Si cualquier método rechaza la solicitud, se devuelve un 401.
- Si el request no es aceptado o rechazado, el usuario es anónimo.
- Por defecto el usuario anónimo no puede hacer ninguna operación en el cluster.

**Service Account Tokens** es un mecanismo de autenticación de kubernetes y vive dentro de la plataforma, nos permite dar permisos a diferentes tipos de usuarios.

- Existen en la API de kubernetes. kubectl get serviceaccount
- Pueden crearse, eliminarse y actualizarse
- Un service account está asociado a secretos `kubectl get secrets`
- Son utilizados para otorgar permisos a aplicaciones y servicios

**Role based access control(RBAC)** es un mecanismo de kubernetes para gestionar roles y la asociación de estos a los usuarios para delimitar las acciones que pueden realizar dentro de la plataforma.

- Un rol es un objeto que contiene una lista de rules
    - ej: el rol `external-loadbalancer-config` puede:
        - List, get en recursos endpoints, services y pods
        - update en recursos services
- Un rolebiding asocia un rol a un usuario
- Pueden existir usuarios, roles y rolebidings con el mismo nombre
- Una buena práctica es tener un 1-1-1 bidings
- Los Cluster-scope permissions permiten definir permisos a nivel de cluster y no solo namespace
- Un pod puede estar asociado a un service-account
    - el token se encuentra en `/var/run/secrets`

### **Recomendaciones**

**Establece una cultura de containers en la organización**
– Escribir Dockerfiles para una aplicación
– Escribir compose files para describir servicios
– Mostrar las ventajas de correr aplicaciones en contenedores
– Configurar builds automáticos de imágenes
– Automatizar el CI/CD (staging) pipeline

**Developer Experience:** Si tienes una persona nueva, debe sentirse acompañada en este proceso de por qué usamos kubernetes y quieres mantener la armonía de ese proceso.

**Elección de un cluster de producción:** Hay alternativas como Cloud, Managed o Self-managed, también puedes usar un cluster grande o múltiples pequeños.

**Recordar el uso de namespaces:** Puedes desplegar varias versiones de tu aplicación en diferentes namespaces.

**Servicios con estados (stateful)**
– Intenta evitarlos al principio
– Técnicas para exponerlos a los pods (ExternalName, ClusterIP, Ambassador)
– Storage provider, Persistent volumens, Stateful set

**Gestión del tráfico Http**
– Ingress controllers (virtual host routing)

**Configuración de la aplicación**
– Secretos y config maps

**Stacks deployments**
– GitOps (infraestructure as code)
– Heml, Spinnaker o Brigade

### **GitOps**
**GitOps** es una práctica que gestiona toda la configuración de nuestra infraestructura y nuestras aplicaciones en producción a través de Git. **Git** es la fuente de verdad. Esto implica que todo proceso de infraestructura conlleva code reviews, comentarios en los archivos de configuración y enlaces a issues y PR.

- Infraestructura como código
- Mecanismo de convergencia
- Uso de CI como fuente de verdad
- Pull vs Push
- Developers y operaciones(git)
- Actualizaciones atómicas

**GitOps** tomo tanta popularidad en la comunidad de DevOps por el impacto que genera.

- Poder desplegar features nuevos rápidos
- Reducir el tiempo para arreglar bugs
- Generar el sentimiento de control y empoderamiento. Confidencia y control
- 20 deploys por día
- 80% en ahorro del tiempo para arreglar errores en producción
