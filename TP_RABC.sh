kubectl get cm -n kube-system kubeadm-config -o jsonpath='{
.data.ClusterConfiguration }' > cluster-configuration.yaml
$ kubeadm kubeconfig user --client-name red --config=cluster-configuration.yaml
> kubeconfig

export KUBECONFIG=kubeconfig
kubectl get pod

### Role 
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: access-pod-svc
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list"]

### RoleBinding
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rb-red
subjects:
- kind: User
  name: red
roleRef:
  kind: Role
  name: access-pod-svc
  apiGroup: rbac.authorization.k8s.io

### Vérification de l'accès
kubectl get pod
kubectl get services
kubectl get deploy

### Création de pod
---
apiVersion: v1
kind: Pod
metadata:
  name: blue
spec:
containers:
- name: web
  image: particule/helloworld
---
apiVersion: v1
kind: Pod
metadata:
  name: green
spec:
containers:
- name: web
  image: particule/helloworld


##### Modification des roles
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: access-pod-svc
rules:
- apiGroups: [""]
  resources: ["pods"]
  resourceNames: ["blue"]
  verbs: ["get", "list"]

### Vérification de l'accès
kubectl get pods
kubectl get pods blue
kubectl get pods green

### Accès depuis un pod
kubectl create serviceaccount monserviceaccount

### Role Binding
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rb-red
subjects:
- kind: ServiceAccount
  name: monserviceaccount
roleRef:
  kind: Role
  name: access-pod-svc
  apiGroup: rbac.authorization.k8s.io

### Héritage par le Pod des droits affecté au ServiceAccount
---
apiVersion: v1
kind: Pod
metadata:
  name: kubectl
spec:
  serviceAccountName: monserviceaccount
  containers:
  - name: kubectl
    image: particule/kubectl
    command: ["/bin/sh", "-c", "sleep 1000"]

### Connection au Pod pour exécuter les commandes
kubectl exec -it kubectl -- /bin/sh
kubectl get pods
kubectl get pods blue

### ClusterRole
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: access-node
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list"]

### ClusterRoleBinding
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: crb-sa
subjects:
- kind: ServiceAccount
namespace: default
  name: monserviceaccount
roleRef:
  kind: ClusterRole
  name: access-node
  apiGroup: rbac.authorization.k8s.io

### Connection au Pod
kubectl get pv
kubectl get  nodes