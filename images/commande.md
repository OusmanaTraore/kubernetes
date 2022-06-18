kubectl create secret docker-registry private-reg-cred \
--docker-server=myprivateregistry.com:5000  \
--docker-username=dock_user \
--docker-password=dock_password \
--docker-email=dock_user@myprivateregistry.com

apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  securityContext:
    runAsUser: 1001
  containers:
  -  image: ubuntu
     name: web
     command: ["sleep", "5000"]
     securityContext:
      runAsUser: 1002

  -  image: ubuntu
     name: sidecar
     command: ["sleep", "5000"]


# weave net 
ip a | grep eth0

kubectl get po -n kube-system | grep weave

kubectl logs -n kube-system weave-net-f5rqv -c weave


kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.50.0.0/16"

kubectl get pods -n kube-system


## 
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range

## From the hr pod nslookup the mysql service and redirect the output to a file /root/CKA/nslookup.out

kubectl exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out

## Install kubeadm kubectl kubelet
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

versioN="1.23.0-00"

sudo apt-get update
sudo apt-get install -y kubelet=${versioN} kubeadm=${versioN} kubectl=${versioN}
sudo apt-mark hold kubelet kubeadm kubectl

## install kubeadm init 
ifconfig eth0

kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address 10.51.139.12 --pod-network-cidr=10.244.0.0/16


kubeadm join 10.51.139.12:6443 --token ml6rzh.vfnsxyerda9ifviq \
        --discovery-token-ca-cert-hash sha256:84f9deea91b4635c8fc820082d84d34da0e887cfcefce92c2b28b242d0866832 