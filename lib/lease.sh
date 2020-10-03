source "$(dirname $BASH_SOURCE[0])/../_env.sh"

# $# 0
# Fonction qui retourne la liste des address MAC des baux valide existant
lease_get_mac()
{
	list=(`dhcp-lease-list --parsable 2>/dev/null | cut -d" " -f2 | sed -e "s/\n/ /g"`)
	echo ${list[@]}
}

# $# 0
lease_get_ip()
{
	list=(`dhcp-lease-list --parsable 2>/dev/null | cut -d" " -f4 | sed -e "s/\n/ /g"`)
	echo ${list[@]}
}

# $# 0
lease_get_hostname()
{
	list=(`dhcp-lease-list --parsable 2>/dev/null | cut -d" " -f6 | sed -e "s/\n/ /g"`)
	echo ${list[@]}
}

# $#1
# $1 Address MAC
lease_turn_off_lease()
{
	respon=$(omapi_turn_off_lease $1)
	echo "$response"
}

lease_init_db()
{
	# Récupére la liste des hostname depuis dchp-lease-list
	hostname_list=($(lease_get_hostname))
	ip_list=($(lease_get_ip))
	mac_list=($(lease_get_mac))

	# vérification au cas où un hote supplémentaire se serait connecté.
	while [ ${#hostname_list[@]} -ne ${#mac_list[@]} ] || [ ${#hostname_list[@]} -ne ${#ip_list[@]} ]
	do
		hostname_list=($(lease_get_hostname))
		ip_list=($(lease_get_ip))
		mac_list=($(lease_get_mac))
	done

	# Récupère les hote de la de la base de donné et supprime les lease qui
	# serait toujours actif mais ferai doublon au hote
	host_db_get_mac=($(host_db_get_mac))
	for db_mac in ${host_db_get_mac[@]}
	do
		i=0
		for mac in ${mac_list[@]}
		do
			if [ $db_mac == $mac ]
			then
				hostname_list=(${hostname_list[@]/${hostname_list[$i]}})
				ip_list=( ${ip_list[@]/${ip_list[$i]}})
				mac_list=( ${mac_list[@]/${mac_list[$i]}} )
			fi
			((i++))
		done
	done

	# Récupère les lease de la base de donné et met
	# a jours la base de donné en cas de doublon d'address MAC
	lease_db_get_mac=($(lease_db_get_mac))
	i=0
	for mac in ${mac_list[@]}
	do
		for db_mac in ${lease_db_get_mac[@]}
		do
			if  [ $db_mac == $mac ]
			then
				sed -i "/$db_mac/d" $SC_LEASE_FILE
			fi
		done
		echo "$mac ${ip_list[$i]} ${hostname_list[$i]}" >> $SC_LEASE_FILE
		((i++))
		sleep 1
	done
}
