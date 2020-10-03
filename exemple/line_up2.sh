#!/bin/bash
# Cette line up à pour objectif d'attibué des hôtes dynamiquement

source "$(dirname $BASH_SOURCE[0])/../_env.sh"
source $SC_EXEMPLE/baseline.sh

number_of_host=2
static_ip=("192.168.1.3" "192.168.1.4")

lease_init_db $number_of_host

mac_list=($(lease_db_get_mac))

i=0
while [ $i -lt $number_of_host ] ;
do
    lease=($(lease_db_get_lease ${mac_list[$i]}))
    echo ${lease[@]}
    host_db_add ${lease[0]} ${static_ip[$i]} ${lease[2]}
    turn_off_lease ${lease[0]}
    echo "MAC ${lease[0]} IP ${static_ip[$i]} HOSTNAME ${lease[2]}"
    ((i++))
done
