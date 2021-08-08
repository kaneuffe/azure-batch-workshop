#!/bin/bash

# Variables
source variables.sh

pool_id="batch-ws-pool"

az batch task create \
    --job-id my-first-mpi-job \
    --json-file mpi-task.json