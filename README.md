# azure-batch-workshop
This respository is to provide basic material to run and intrdouction into Azure Batch workshp.
To be able to run the scripts, you need to craete a configuration file called variablñes.sh within the same directory wich defines the necessary variables.

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
```
