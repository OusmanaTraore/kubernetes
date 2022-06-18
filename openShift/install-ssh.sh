#!/bin/bash

sudo -i 
# Login as root user on your local machine
ssh-keygen -t ed25519 -C "openshift"
eval "$(ssh-agent -s)"
ssh-add

# Login on your redhat account and download the installation program (client and pull-secret)

mkdir /root/bin
cd Downloads/
tar -xzf openshift-install-linux.tar.gz
tar -xzf openshift-client-linux.tar.gz

cp openshift-install oc kubectl /root/bin


# Create the install-config.yaml file

./openshift-install create install-config --dir=openshift

# Select the platform to target
IBM CLOUD

#
./openshift-install create cluster --dir=openshift --log-level=info

##
export KUBECONFIG=/root/openshift/auth/kubeconfig