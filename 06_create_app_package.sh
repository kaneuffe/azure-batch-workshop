#!/bin/bash

# Variables
source variables.sh

# Create job to create the application packahe
az batch job create \
    --id app-creation-job \
    --pool-id ${pool_id}

# Create task to create the application zip file
az batch task create \
    --task-id app-creation-task \
    --job-id app-creation-job \
    --command-line "/bin/bash -c 'wget -L https://raw.githubusercontent.com/kaneuffe/azure-batch-workshop/main/create_app_zip.sh;chmod u+x create_app_zip.sh;./create_app_zip.sh'"

# Wait for the task to finish
state=$(az batch task show --job-id app-creation-job --task-id app-creation-task --query 'state')
echo "Job task status"
echo $state
while [[ $state != *"completed"* ]]
do
    state=$(az batch task show --job-id app-creation-job --task-id app-creation-task --query 'state')
    echo $state
    sleep 10
done

# Download the app zip file 
az batch task file download \
    --job-id app-creation-job \
    --task-id app-creation-task \
    --file-path "wd/mpi_batch.zip" \
    --destination ./mpi_batch.zip

# Create the application
az batch application create \
    --resource-group $batch_rg \
    --name $batch_account_name \
    --application-name "mpi_batch"

# Upload application package
az batch application package create \
    --resource-group $batch_rg \
    --name $batch_account_name \
    --application-name "mpi_batch" \
    --package-file "mpi_batch.zip" \
    --version-name 1.0.0