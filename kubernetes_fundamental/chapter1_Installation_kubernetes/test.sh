#!/bin/bash

TEST < cat "27eee4.6e66ff60318da929" 
echo "..."
$TEST 

#sed -i 's/token/token=""/g'

sed -e "s/#- name: CALICO_IPV4POOL_CIDR/- name: CALICO_IPV4POOL_CIDR/g" calico.yaml
sed -e "s/# value: \"192.168.0.0/16\"/ value: \"192.168.0.0/16\"/g" calico.yaml


# sed -n -e "/`echo $USER`/s/[^:]*:[^:]*:\([^:]*\):\([^:]*\):.*/UID=\1\nGID=\2/p" /etc/passwd