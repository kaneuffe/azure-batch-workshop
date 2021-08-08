#!/bin/bash

# Variables
source variables.sh

pool_id="batch-ws-pool"

az batch pool delete --pool-id ${pool_id}