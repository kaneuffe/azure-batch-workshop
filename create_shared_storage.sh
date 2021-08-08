#!/bin/bash

source variables.sh

az storage account create \
    --resource-group $batch_rg \
    --name $nfs_storage_account_name \
    --location $region \
    --kind FileStorage \
    --sku Premium_LRS \
    --allow-blob-public-access false \
    --default-action deny \
    --https-only false \
    --enable-large-file-share

storageAccountKey=$(az storage account keys list \
    --resource-group $batch_rg \
    --account-name $nfs_storage_account_name \
    --query "[0].value" | tr -d '"')

az storage account network-rule add \
    --resource-group $batch_rg \
    --account-name $nfs_storage_account_name \
    --vnet-name $batch_vnet_name \
    --subnet $compute_subnet_name

az storage share-rm create \
    --resource-group $batch_rg \
    --storage-account $nfs_storage_account_name \
    --name $nfs_share \
    --quota 1024 \
    --enabled-protocols NFS \
    --root-squash NoRootSquash
