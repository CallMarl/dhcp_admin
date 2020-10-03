source "$(dirname $BASH_SOURCE[0])/../_env.sh"

lease_db_get_lease()
{
    lease=(`cat $SC_LEASE_FILE | egrep -i "$1( |$)" | sed -e "s/\n/ /g"`)
    echo "${lease[0]} ${lease[1]} ${lease[2]}"
}

# $# 0
lease_db_get_mac()
{
    list=(`cat $SC_LEASE_FILE | cut -d" " -f1 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
lease_db_get_ip()
{
    list=(`cat $SC_LEASE_FILE | cut -d" " -f2 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
lease_db_get_hostname()
{
    list=(`cat $SC_LEASE_FILE | cut -d" " -f3 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
lease_db_count()
{
    nb=`cat $SC_LEASE_FILE | wc -l`
    echo $nb
}
