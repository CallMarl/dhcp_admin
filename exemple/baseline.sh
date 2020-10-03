# Base file for lineup

source "$(dirname $BASH_SOURCE[0])/../_env.sh"

display_usage()
{
	echo "Usage $0: [server] [port] [key_name] [omapi]"
	echo "	server :   ip of dhcp server."
	echo "	port :     omapi port of dhcp server."
	echo "	key name : omapi key name (same as dhcpd.conf)."
	echo "	key :      omapi hash (same as dhcpd.conf)."
}

if [ $# -ne 4 ]
then
    display_usage
    exit 0
fi

SERVER=$1
PORT=$2
KEY_NAME=$3
KEY=$4

source $SC_LIB/host_db.sh
source $SC_LIB/lease_db.sh
source $SC_LIB/lease.sh
source $SC_LIB/omapi.sh
source $SC_LIB/tmp_db.sh
source $SC_LIB/utile.sh
