source "$(dirname $BASH_SOURCE[0])/../_env.sh"

# $# 1
# $1 ip
get_ip_state()
{
    ping -f -c 4 $1 > /dev/null
    ret=$?
    echo $ret
}

check_env()
{
	if [ ! -f $SC_ROOT/server ] || [ ! -f $SC_ROOT/port ] || [ ! -f $SC_ROOT/key_name ]|| [ ! -f $SC_ROOT/key ]
	then
		echo "Les variables d'environnement sont manquantes veuillez les initialiser."
		exit 0
	fi
	if [ -z "$SC_SERVER" ] || [ -z "$SC_PORT" ] || [ -z "$SC_KEY_NAME" ] || [ -z "$SC_KEY" ]
	then
		echo "Les variables d'environnement sont manquantes veuillez les initialiser."
		exit 0
	fi
}
