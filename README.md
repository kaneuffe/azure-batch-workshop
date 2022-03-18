# azure-batch-workshop
This respository is to provide basic material to run and introduction into Azure Batch workshop.
To be able to run the scripts, you need to craete a configuration file called variables.sh within the same directory:

```shell-script
#!/bin/bash

# Configuration variables

# ID of your Azure subscription
subscription_id=
# Name of the resource group
batch_rg="batch-ws-rg"
# Region
region="westeurope"
# Unique batch account name (e.g. batchwsaccount3245353)
batch_account_name=
# Unique storage account name (e.g. batchwastorage3245353)
storage_account_name=
# VNET name
batch_vnet_name="batch-ws-vnet"
# Compute subnet name
compute_subnet_name="compute"
# Unique storage account name for shared Azure Files NFS storage (e.g. batchwsnfsstorage3422435234)
nfs_storage_account_name="batchwsnfssa" # unique
# Name of tha Azure Files fileshare
nfs_share="shared"
# Unique extension for the keyvault name (e.g. kv234)
keyvault_extension=
# Pool name
pool_id="batch-ws-pool"
# SKU of the compute node VM
pool_vm_size="STANDARD_F2s_v2"


```

The scripts need to be run after the other and will require contributer of even owner rights to the subscription, later ownlyif the batch service has not been enabled before.
