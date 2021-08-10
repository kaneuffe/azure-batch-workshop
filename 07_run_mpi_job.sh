#!/bin/bash

# Variables
source variables.sh

pool_id="batch-ws-pool"

# Create job
az batch job create \
    --id my-first-mpi-job \
    --pool-id ${pool_id}

# Create task
az batch task create \
    --job-id my-first-mpi-job \
    --task-id mpi-task \
    --json-file mpi-task.json

# Download output of task1
az batch task file download \
    --job-id my-first-mpi-job \
    --task-id mpi-task \
    --file-path stdout.txt \
    --destination ./mpi-stdout.txt

# Download error file of task1
az batch task file download \
    --job-id my-first-mpi-job \
    --task-id mpi-task \
    --file-path stderr.txt \
    --destination ./mpi-stderr.txt