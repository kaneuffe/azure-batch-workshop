#!/bin/bash

# Variables
source variables.sh

az login --use-device-code
az account set --subscription ${subscription_id}

# Authenticate directly against the account for further CLI interaction.
# Batch accounts that allocate pools in the user's subscription must be
# authenticated via an Azure Active Directory token.
az batch account login -g $batch_rg -n $batch_account_name