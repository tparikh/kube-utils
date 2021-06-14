#!/bin/bash -e

set -e

display_usage() {
  echo "Cordons all nodes in a GKE nodepool"
  echo -e "\nUsage:\n ./cordon-gke-nodepool [nodepool-name] "
  echo -e " ./cordon-gke-nodepool pool-1 \n"
}

if [ $# -lt 1 ]
then
  display_usage
  exit 1
fi

NODE_POOL=$1

NODES=$(kubectl get nodes -l cloud.google.com/gke-nodepool="${NODE_POOL}" -o=name)

echo "WARNING: Following nodes will be cordoned from ${NODE_POOL}"
echo ""
for node in $NODES; do
  echo "$node"
done

echo ""
while true; do
    read -p "Do you wish to continue [y/N]? " yn
    case $yn in
        [y]* ) break;;
        [N]* ) exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Cordoning nodes...."
for node in $NODES; do
  echo "Cordoning node ${node}"
  kubectl cordon "${node}";
done
echo "Cordoning finished"
