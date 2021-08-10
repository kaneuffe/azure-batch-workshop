#!/bin/bash

source variables.sh

# Create a VNET
az network vnet create \
    --name $batch_vnet_name \
    --location $region \
    --resource-group $batch_rg \
    --address-prefix 10.0.0.0/16

# Create a network security group the subnet.
az network nsg create \
  --resource-group $batch_rg \
  --name compute-nsg \
  --location $region

# Create an NSG rule to allow SSH traffic from the Internet to the compute subnet.
az network nsg rule create \
  --resource-group $batch_rg \
  --nsg-name compute-nsg \
  --name Allow-SSH-All \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 200 \
  --source-address-prefix Internet \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 22

az network nsg rule create \
  --resource-group $batch_rg \
  --nsg-name compute-nsg \
  --name Allow-Batch \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 100 \
  --source-address-prefix "BatchNodeManagement" \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range "29876-29877"

az network nsg rule create \
  --resource-group $batch_rg \
  --nsg-name compute-nsg \
  --name ModeAgentRule-DenyAll \
  --access Deny \
  --protocol Tcp \
  --direction Inbound \
  --priority 300 \
  --source-address-prefix "*" \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range "29876-29877"

# Create a subnet with service endpoints
az network vnet subnet create \
  --name $compute_subnet_name \
  --resource-group $batch_rg \
  --vnet-name $batch_vnet_name \
  --address-prefix 10.0.0.0/24 \
  --network-security-group compute-nsg \
  --service-endpoints "Microsoft.Storage" "Microsoft.KeyVault"
