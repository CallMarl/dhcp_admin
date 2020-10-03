display_usage()
{
	echo "dhcp-admin wait [-lp]"
	echo "	-l [ host_number ]([max_time])"
	echo "	   wait while the number of host is under the amount indicate."
	echo "	-p [ hostname | mac addr | host ip ]([ max_time ])"
	echo "	   wait while host didn't give response on it new ip."
}

wait_for_lease()
{
	hostname_list=($(lease_get_hostname))
	if [ -z $1 ]
	then
		display_usage
		exit 0
	fi
	lease_init_db
	timer=0
	while [ $(lease_db_count) -lt $1 ]
	do
		echo "Warn: This command wait while the number of host is $1 (could be inf)."
		echo "      available host $(lease_db_count)"
		lease_init_db
		sleep 10;
		if [ ! -z $2 ]
		then
			((timer+=10))
			if [ timer -lt $2 ]
			then
				echo "Warn: The max time is over."
				echo "      The number of available host are $(lease_db_count)"
				break;
			fi
		fi
	done
}

wait_for_response()
{
	echo "(Not implemented)"
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
