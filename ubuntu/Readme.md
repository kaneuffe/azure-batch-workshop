# Ubuntu version
This version is meant to be used with an Ubuntu HPC image and assumes that the Batch account and the network have been already been created by running 01_create_account.sh and 02_create_network.sh. 
We add a 01a_login.sh script which can be used independently after the account has already been created. 
This version will require InfiniBand equipped compute nodes which need to be configured in the variables.sh scritp as for example:
```
pool_vm_size="STANDARD_HB60rs"
```
This version just runs a simple OSU bw benchmark between two nodes without the requirement for a shared filesystem or and application package.
