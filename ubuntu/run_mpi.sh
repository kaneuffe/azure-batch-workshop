#!/bin/bash

if [ -f /etc/profile.d/modules.sh ]; then
        . /etc/profile.d/modules.sh
fi

module load mpi/hpcx

# Create host file
batch_hosts=hosts.batch
rm -rf $batch_hosts
IFS=';' read -ra ADDR <<< "$AZ_BATCH_NODE_LIST"
for i in "${ADDR[@]}"; do echo $i >> $batch_hosts;done

# Determine hosts to run on
src=$(tail -n1 $batch_hosts)
dst=$(head -n1 $batch_hosts)
echo "Src: $src"
echo "Dst: $dst"

NP=$(($NODES*$PPN))

#Runnning the following command
echo "mpirun -np $NP -oversubscripe --host ${src}:${PPN},${dst}:${PPN} --map-by ppr:${PPN}:node --mca btl tcp,vader,self --mca coll_hcoll_enable 0 --mca btl_tcp_if_include lo,eth0 --mca pml ^ucx ${AZ_BATCH_APP_PACKAGE_mpi_batch_1_0_0}/mpi_batch/mpi_hello_world"

# Run two node MPI tests
mpirun -np $NP --oversubscribe --host ${src}:${PPN},${dst}:${PPN} --map-by ppr:${PPN}:node --mca btl tcp,vader,self --mca coll_hcoll_enable 0 --mca btl_tcp_if_include lo,eth0 --mca pml ^ucx ${AZ_BATCH_APP_PACKAGE_mpi_batch_1_0_0}/mpi_batch/mpi_hello_world