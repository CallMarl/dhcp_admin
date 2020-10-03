# Fichier de base d'une line up.

source "$(dirname $BASH_SOURCE[0])/../_env.sh"

display_usage()
{
    echo "$0 : [server ip][port][key name][key]"
    echo "  - server ip : ip du server dhcp"
    echo "  - port : port omapi d'écoute"
    echo "  - key name : nom de clef indiqué dans le fichier dhcpd.conf"
    echo "  - key : hash secret indiqué dans le fichier dhcpd.conf"
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
