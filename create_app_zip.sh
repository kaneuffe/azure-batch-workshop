#!/bin/bash

mkdir ./mpi_batch
cd ./mpi_batch

echo "Writing mpi_hello_world.c file"

cat << 'EOF' > mpi_hello_world.c
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    // Initialize the MPI environment
    MPI_Init(NULL, NULL);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    printf("Hello world from processor %s, rank %d out of %d processors\n",
           processor_name, world_rank, world_size);

    // Finalize the MPI environment.
    MPI_Finalize();
}
EOF

echo "Writing run_mpi.sh file"

cat << 'EOF' > run_mpi.sh
#!/bin/bash

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

module load gcc-9.2.0
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
EOF

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

module load gcc-9.2.0
module load mpi/hpcx

echo "Compiling mpi_hello_world.c file"
mpicc -o mpi_hello_world mpi_hello_world.c

echo "Deleting source file"
rm  mpi_hello_world.c

cd ..
echo "Creating zip file"
zip -r mpi_batch.zip mpi_batch
