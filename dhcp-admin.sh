#!/bin/bash
source "$(dirname $(realpath ${BASH_SOURCE[0]}))/_env.sh"

source "$SC_LIB/host_db.sh"
source "$SC_LIB/lease_db.sh"
source "$SC_LIB/lease.sh"
source "$SC_LIB/omapi.sh"
source "$SC_LIB/tmp_db.sh"
source "$SC_LIB/utile.sh"

display_usage()
{
	echo "Usage $0: [cmd] [option]"
	echo "	init     setup dhcp-admin environnement."
	echo "	show     display content of .db files."
	echo "	add      enable you to give static ip to host."
	echo "	wait     enable you to wait for host befor give him static ip."
	echo "	rm       enable you to remove static host (not implemented)."
	echo "	connect  enable you to connect to the static host (not implemented)."
}

uninit()
{
	rm $SC_ROOT/server
	rm $SC_ROOT/port
	rm $SC_ROOT/key_name
	rm $SC_ROOT/key
}

init()
{
	lease_init_db
	if [ $# -ne 4 ]
	then
		echo "Usage $0: [server] [port] [key_name] [omapi]"
		echo "	server :   ip of dhcp server."
		echo "	port :     omapi port of dhcp server."
		echo "	key name : omapi key name (same as dhcpd.conf)."
		echo "	key :      omapi hash (same as dhcpd.conf)."
	else
		echo $1 > $SC_ROOT/server
		echo $2 > $SC_ROOT/port
		echo $3 > $SC_ROOT/key_name
		echo $4 > $SC_ROOT/key
		echo "Make sur parametters are correct."
		echo "dhcp-admin doesn't implement any control."
	fi
}

show()
{
	echo "HOST LIST : "
	cat $SC_HOST_FILE
	echo ""
	echo "TMP LIST : "
	cat $SC_TMP_FILE
	echo ""
	echo "LEASE LIST : "
	cat $SC_LEASE_FILE
	echo ""
}

if [ -f $SC_ROOT/server ]
then
	SC_SERVER=`cat $SC_ROOT/server`
fi

if [ -f $SC_ROOT/port ]
then
	SC_PORT=`cat $SC_ROOT/port`
fi

if [ -f $SC_ROOT/key_name ]
then
	SC_KEY_NAME=`cat $SC_ROOT/key_name`
fi

if [ -f $SC_ROOT/key ]
then
	SC_KEY=`cat $SC_ROOT/key`
fi

case "$1" in
	init)
		init $2 $3 $4 $5
		;;
	connect)
		source $SC_TOOLS/connect.sh $@
		;;
	add)
		source $SC_TOOLS/add.sh $@
		;;
	uninit)
		uninit
		;;
	rm)
		source $SC_TOOLS/rm.sh $@
		;;
	show)
		show
		;;
	wait)
		source $SC_TOOLS/wait.sh $@
		;;
	*)
		display_usage
		exit 0
		;;
esac

exit 0
