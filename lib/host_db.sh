source "$(dirname $BASH_SOURCE[0])/../_env.sh"
source $SC_LIB/omapi.sh

host_db_get_host()
{
    host=(`cat $SC_HOST_FILE | egrep -i "$1( |$)" | sed -e "s/\n/ /g"`)
    echo "${host[0]} ${host[1]} ${host[2]}"
}

# $# 0
# Fonction qui retourne la liste des address MAC des baux valide existant
host_db_get_mac()
{
    list=(`cat $SC_HOST_FILE | cut -d" " -f1 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
host_db_get_ip()
{
    list=(`cat $SC_HOST_FILE | cut -d" " -f2 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
host_db_get_hostname()
{
    list=(`cat $SC_HOST_FILE | cut -d" " -f3 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
host_db_count()
{
    nb=`cat $SC_HOST_FILE | wc -l`
    echo $nb
}

# $# 3
# $1 addresse MAC
# $2 addresse ip
# $3 nom d'hote
host_db_add()
{
    if [ $# -eq 3 ]
    then
        omapi_add_host $1 $2 $3
        echo "$1 $2 $3" >> $SC_HOST_FILE
        lease=($(lease_db_get_lease $1))
        echo "${lease[0]} ${lease[1]} ${lease[2]} " >> $SC_TMP_FILE
        sed -i "/$1/d" $SC_LEASE_FILE
    else
	echo "$0 : erreur sur les arguments : [ $@ ], 3 argument sont attendu"
	exit 0
    fi
}
