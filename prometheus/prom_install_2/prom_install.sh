#!/bin/bash

sudo apt-get install docker-compose -y

git clone https://github.com/fc4it-k8s/prometheus-101

cd prometheus-101

docker-compose up
