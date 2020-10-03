source "$(dirname $BASH_SOURCE[0])/../_env.sh"

tmp_db_get_tmp()
{
    tmp=(`cat $SC_TMP_FILE | egrep -i "$1( |$)" | sed -e "s/\n/ /g"`)
    echo "${tmp[0]} ${tmp[1]} ${tmp[2]}"
}

# $# 0
# Fonction qui retourne la liste des address MAC des baux valide existant
tmp_db_get_mac()
{
    list=(`cat $SC_TMP_FILE | cut -d" " -f1 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
tmp_db_get_ip()
{
    list=(`cat $SC_TMP_FILE | cut -d" " -f2 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
tmp_db_get_hostname()
{
    list=(`cat $SC_TMP_FILE | cut -d" " -f3 | sed -e "s/\n/ /g"`)
    echo ${list[@]}
}

# $# 0
tmp_db_count()
{
    nb=`cat $SC_TMP_FILE | wc -l`
    echo $nb
}
