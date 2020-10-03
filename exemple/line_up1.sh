#!/bin/bash
# Setp one static IP depending of hostname.
source "$(dirname $BASH_SOURCE[0])/../_env.sh"

# Include baseline file to load the full lib.
source $SC_EXEMPLE/baseline.sh

# Give an existing ostname
hostname_1="Firewall-1"

# Give static ip
ip_1="192.168.1.5"

# Load the lease database
lease_init_db

# Get the lease with the associate hostname
# lease is an array with
# ${lease[0]} MAC
# ${lease[1]} IP
# ${lease[2]} HOSTNAME
lease=($(lease_db_get_lease $hostname_1))

# Check is static lease exist with the ip idicate
lease=($(lease_db_get_lease $ip_1))
if [ ${#lease[@]} -ne 0 ]
then
    echo "There is already a lease with this ip."
    echo "lease: ${lease[@]}"
    exit 0
fi

# Create static host
host_db_add ${lease[0]} $ip_1 ${lease[2]}

# Turn the old lease to expiration
lease_turn_off_lease ${lease[0]}
