#!/bin/bash

### Lancement du container 
echo " Lancement du container > "
sudo -i 
docker run -d --net=host -v /home/ubuntu/prometheus.yaml:/etc/prometheus/prometheus.yaml --name prometheus-server  prom/prometheus

### Start Node Exporter 
echo " Start Node Exporter > "
docker run -d \
-v "/proc:/host/proc" \
-v "/sys:/host/sys" \
-v "/:/rootfs" \
--net="host" \
--name=prometheus \
quay.io/prometheus/node-exporter:v0.13.0 \
-collector.procfs /host/proc \
-collector.sysfs /host/sys \
-collector.filesystem.ignored-mount-points
"^/(sys|proc|dev|host|etc)($|/)"