display_usage()
{
	echo "isc-dhcp-admin wait [-lp]"
	echo "	-l [ host_number ]"
	echo "	   attends tant que le nombre de bails disponibles est inférieur à celui indiqué"
	echo "	-p [ hostname | mac addr | host ip ]([ max_time ])"
	echo "	   attends jusqu'à ce que l'hôte reponds sur sont ip"
}

wait_for_lease()
{
	hostname_list=($(lease_get_hostname))
	# si $1 est set alors on attends jusqu'à ce que le nombre de lease requis
	# soit respecté.
	if [ -z $1 ]
	then
		display_usage
		exit 0
	fi
	lease_init_db
	timer=0
	while [ $(lease_db_count) -lt $1 ]
	do
		echo "Warn: Cette commande dépend du nombre d'hôte qui peuvent réelement se connecté (inf)."
		lease_init_db
		sleep 10;
		if [ ! -z $2 ]
		then
			((timer+=10))
			if [ timer -lt $2 ]
			then
				echo "Warn: Le temps que vous avez indiqué s'est écoulé."
				echo "il se peux que le nombre d'hote que vous avez indiqué n'est été ateint"
				break;
			fi
		fi
	done
}

wait_for_response()
{
	echo "Pas encore implémenté"
}

case "$2" in
	"-l")
		wait_for_lease $3
		;;
	"-p")
		wait_for_response $3 $4
		;;
	*)
		display_usage
		exit 0
		;;
esac
