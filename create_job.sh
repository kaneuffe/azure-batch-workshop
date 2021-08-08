#!/bin/bash

# Variables
source variables.sh

pool_id="batch-ws-pool"

az batch job create \
    --id my-first-mpi-job \
    --pool-id ${pool_id}
