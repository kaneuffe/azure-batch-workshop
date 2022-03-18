#!/bin/bash

# Variables
source variables.sh

az batch job delete --job-id my-first-batch-job

az batch job delete --job-id my-first-mpi-job

az batch pool delete --pool-id ${pool_id}