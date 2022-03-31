#!/bin/bash

###   Deploiemeent de nginx      
echo "Deploiemeent de nginx >"
kubectl create deployment nginx --image=nginx

kubectl get deployments

kubectl describe deployment nginx

kubectl get events

kubectl get deployment nginx -o yaml

echo -e "
Run the command again and redirect the output to a file. Then edit the file. Remove the creationTimestamp ,
resourceVersion , selfLink , and uid lines. Also remove all the lines including and after status: , which should
be somewhere around line 120, if others have already been removed.
"
kubectl get deployment nginx -o yaml > first.yaml

kubectl delete deployment nginx

kubectl create -f first.yaml
kubectl get deployment nginx -o yaml > second.yaml

kubectl get deployment nginx -o json

kubectl expose -h

kubectl expose deployment/nginx

echo "editer le fichier first.yaml"
echo -e "
....
spec:
containers:
- image: nginx
imagePullPolicy: Always
name: nginx
ports:
- containerPort: 80
protocol: TCP
resources: {}"

kubectl replace -f first.yaml
kubectl get deploy,pod
kubectl expose deployment/nginx
kubectl get svc nginx
kubectl get ep nginx
kubectl get ep nginx

kubectl describe pod nginx-7cbc4b4d9c-d27xw \
| grep Node:

sudo tcpdump -i tunl0

curl 10.100.61.122:80
kubectl get deployment nginx


kubectl scale deployment nginx --replicas=3
kubectl get ep nginx
kubectl get pod -o wide
kubectl delete pod nginx-1423793266-7f1qw
kubectl get po
curl 10.100.61.122:80

### Acces from Oustside the cluster
kubectl exec nginx-1423793266-13p69 \
-- printenv |grep KUBERNETES
kubectl get svc
kubectl delete svc nginx

kubectl expose deployment nginx --type=LoadBalancer

kubectl get svc
curl ifconfig.io
kubectl scale deployment nginx --replicas=0
kubectl get svc

kubectl scale deployment nginx --replicas=2

kubectl delete deployments nginx

kubectl delete ep nginx

kubectl delete svc nginx

