#!/bin/bash

# Variables
source variables.sh

compute_subnet_id="/subscriptions/${subscription_id}/resourceGroups/${batch_rg}/providers/Microsoft.Network/virtualNetworks/${batch_vnet_name}/subnets/${compute_subnet_name}"
pool_id="batch-ws-pool"
pool_vm_size="STANDARD_F2s_v2"
nfs_share_hostname="${nfs_storage_account_name}.file.core.windows.net"
nfs_share_directory="/${nfs_storage_account_name}/shared"

# Define start task
read -r -d '' START_TASK << EOM
/bin/bash -c hostname;env;pwd
EOM

# Create the pool definition JSON file
# Define the batch pool
cat << EOF >  batchpool_create_${pool_id}.json
{
  "id": "$pool_id",
  "vmSize": "$pool_vm_size",
  "virtualMachineConfiguration": {
       "imageReference": {
            "publisher": "openlogic",
            "offer": "centos-hpc",
            "sku": "7.7",
            "version": "latest"
        },
        "nodeAgentSkuId": "batch.node.centos 7"
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
  "mountConfiguration": [
      {
          "nfsMountConfiguration": {
              "source": "$nfs_share_hostname:/${nfs_share_directory}",
              "relativeMountPath": "shared",
              "mountOptions": "-o rw,hard,rsize=65536,wsize=65536,vers=4,minorversion=1,tcp,sec=sys"
          }
      }
  ],
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
    --json-file batchpool_create_${pool_id}.json