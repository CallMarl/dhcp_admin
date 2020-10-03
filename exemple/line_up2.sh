#!/bin/bash
# This lineup is to set static host dynamicaly
# based on mac address 
# (could be run durring Virtual machine installation for exemple)

source "$(dirname $BASH_SOURCE[0])/../_env.sh"

# Include baseline file to load the full lib.
source $SC_EXEMPLE/baseline.sh

# Define number of random host required
number_of_host=2
# List of static ip for the new host
static_ip=("192.168.1.3" "192.168.1.4")

# wait host during 3600 sec
wait_for_lease $number_of_host 3600

# get the mac list address
mac_list=($(lease_db_get_mac))

# create static host for each lease
i=0
while [ $i -lt $number_of_host ] ;
do

    # Get the lease with the associate mac address
    # lease is an array with
    # ${lease[0]} MAC
    # ${lease[1]} IP
    # ${lease[2]} HOSTNAME
    lease=($(lease_db_get_lease ${mac_list[$i]}))
    # display the lease value
    echo ${lease[@]}
    # create the static host
    host_db_add ${lease[0]} ${static_ip[$i]} ${lease[2]}
    # turn the old lease to expiration
    turn_off_lease ${lease[0]}
    echo "MAC ${lease[0]} IP ${static_ip[$i]} HOSTNAME ${lease[2]}"
    ((i++))
done
