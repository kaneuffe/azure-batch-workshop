#!/bin/bash

# Variables
source variables.sh

compute_subnet_id="/subscriptions/${subscription_id}/resourceGroups/${batch_rg}/providers/Microsoft.Network/virtualNetworks/${batch_vnet_name}/subnets/${compute_subnet_name}"

# Define start task
read -r -d '' START_TASK << EOM
/bin/bash -c hostname;env;pwd
EOM

# Create the pool definition JSON file
# Define the batch pool
cat << EOF >  ${pool_id}.json
{
  "id": "$pool_id",
  "vmSize": "$pool_vm_size",
  "virtualMachineConfiguration": {
       "imageReference": {
            "publisher": "microsoft-dsvm",
            "offer": "ubuntu-hpc",
            "sku": "2004",
            "version": "latest"
        },
        "nodeAgentSkuId": "batch.node.ubuntu 20.04"
    },
  "targetDedicatedNodes": 2,
  "enableInterNodeCommunication": true,
  "networkConfiguration": {
    "subnetId": "$compute_subnet_id"
  },
  "maxTasksPerNode": 1,
  "taskSchedulingPolicy": {
    "nodeFillType": "Pack"
  },
  "startTask": {
    "commandLine":"${START_TASK}",
    "userIdentity": {
        "autoUser": {
          "scope":"pool",
          "elevationLevel":"admin"
        }
    },
    "maxTaskRetryCount":1,
    "waitForSuccess":true
  }
}
EOF

# Create a batch pool
az batch pool create \
    --json-file ${pool_id}.json

# Look at the status of the batch pool
echo "az batch pool show --pool-id $pool_id --query \"state\""

az batch pool show --pool-id $pool_id \
    --query "state"

