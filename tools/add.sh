source "$(dirname $BASH_SOURCE[0])/../_env.sh"

display_usage()
{
	echo "Usage dhcp-admin add : [-ku]"
	echo "	-k [ hostname | mac addr | lease ip ][ ip ]"
	echo "	   set statique ip to know host"
	echo "	-u [ nombre d\'hôte ][ liste ip ]: "
	echo "	   will attribut static ip for random machine."
}

know()
{
	if [ $# -ne 2 ]
	then
		display_usage
		exit 0
	fi
	lease_init_db
	lease=($(lease_db_get_lease $1))
	if [ ${#lease[@]} -eq 0 ]
	then
		echo "Machine not found"
		exit 0
	fi
	lease_tmp=($(lease_db_get_lease $2))
	if [ ${#lease_tmp[@]} -ne 0 ]
	then
		echo "There is already a host with this ip"
		echo "host: ${lease_tmp[@]}"
		exit 0
	fi
	host_tmp=($(host_db_get_host $2))
	if [ ${#host_tmp[@]} -ne 0 ]
	then
		echo "There is already a host with this ip."
		echo "host: ${host_tmp[@]}"
		exit 0
	fi
	host_db_add ${lease[0]} $2 ${lease[2]}
	lease_turn_off_lease ${lease[0]}
}

unknow()
{
	if [ $# -ne 1 ]
	then
		display_usage
		exit 0
	fi
	lease_tmp=($(lease_db_get_lease $1))
	if [ ${#lease_tmp[@]} -ne 0 ]
	then
		echo "There is already a lease with this ip."
		echo "lease: ${lease_tmp[@]}"
		exit 0
	fi
	host_tmp=($(host_db_get_host $1))
	if [ ${#host_tmp[@]} -ne 0 ]
	then
		echo "There is alredy a host with this ip."
		echo "host: ${host_tmp[@]}"
		exit 0
	fi

	lease_init_db
	mac_list=($(lease_db_get_mac))
	lease=($(lease_db_get_lease ${mac_list[0]}))
	host_db_add ${lease[0]} $1 ${lease[2]}
	lease_turn_off_lease ${lease[0]}
	echo "MAC ${lease[0]} IP $1 HOSTNAME ${lease[2]}"
}

check_env
case "$2" in
	"-k")
		know $3 $4
		;;
	"-u")
		unknow $3
		;;
	*)
		display_usage
		exit 0
		;;
esac
