#!/bin/bash

# Variables
source variables.sh

# Create job
az batch job create \
    --id my-first-batch-job \
    --pool-id ${pool_id}

# Create tasks
for i in {1..4}
do
   az batch task create \
    --task-id mytask$i \
    --job-id my-first-batch-job \
    --command-line "/bin/bash -c 'printenv | grep AZ_BATCH; sleep 10s'"
done

sleep 60s

# List task files
for i in {1..4}
do
az batch task file list \
    --job-id my-first-batch-job \
    --task-id mytask$i \
    --output table
done

for i in {1..4}
do
# Download output of task1
    az batch task file download \
    --job-id my-first-batch-job \
    --task-id mytask$i \
    --file-path stdout.txt \
    --destination ./task"$i"_stdout.txt

# Download error file of task1
    az batch task file download \
    --job-id my-first-batch-job \
    --task-id mytask$i \
    --file-path stderr.txt \
    --destination ./task"$i"_stderr.txt
done


