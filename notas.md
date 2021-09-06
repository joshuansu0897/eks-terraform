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