#!/bin/bash

# Variables
source variables.sh

# Allow Azure Batch to access the subscription (one-time operation).
az role assignment create \
    --assignee MicrosoftAzureBatch \
    --role contributor

# Create a resource group.
az group create --name $batch_rg --location $region

# Create an Azure Key Vault. A Batch account that allocates pools in the user's subscription 
# must be configured with a Key Vault located in the same region. 
az keyvault create \
    --resource-group $batch_rg \
    --name ${batch_account_name}${keyvault_extension} \
    --location $region \
    --enabled-for-deployment true \
    --enabled-for-disk-encryption true \
    --enabled-for-template-deployment true

# Add an access policy to the Key Vault to allow access by the Batch Service.
az keyvault set-policy \
    --resource-group $batch_rg \
    --name ${batch_account_name}${keyvault_extension} \
    --spn ddbf3205-c6bd-46ae-8127-60eb93363864 \
    --secret-permissions backup delete get list purge recover restore set \
    --key-permissions backup create decrypt delete encrypt get import list purge recover restore sign unwrapKey update verify wrapKey

# Add a storage account reference to the Batch account for use as 'auto-storage'
# for applications. Start by creating the storage account.
az storage account create \
    --resource-group $batch_rg \
    --name $storage_account_name \
    --location $region \
    --sku Standard_LRS \
    --encryption-services blob

# Find storage key
storage_key=$( az storage account keys list --account-name "$storage_account_name" --resource-group batch-ws-rg --query [0].value  --output tsv )
echo $storage_key

# Create storage container
az storage container create \
  --name batch \
  --account-name $storage_account_name \
  --account-key $storage_key

# Create the Batch account, referencing the Key Vault either by name (if they
# exist in the same resource group) or by its full resource ID.
az batch account create \
    --resource-group $batch_rg \
    --name $batch_account_name \
    --location $region \
    --keyvault ${batch_account_name}${keyvault_extension} \
    --storage-account $storage_account_name \
    --identity-type SystemAssigned

# Authenticate directly against the account for further CLI interaction.
# Batch accounts that allocate pools in the user's subscription must be
# authenticated via an Azure Active Directory token.
az batch account login -g $batch_rg -n $batch_account_name