#!/bin/sh
# Cette line up à pour objectif de se connecter à un hote dynamiquement via ssh
source "$(dirname $BASH_SOURCE[0])/../_env.sh"
source $SC_EXEMPLE/baseline.sh

user="user"
port="22"
hostname="Bdd-1"
mac=""

# Récupère l'address ip associé au nom d'hote
host=($(host_db_get_host $hostname))
#host=($(host_db_get_host $mac))

if [ ${#host[@]} -eq 0 ]
then
    echo "Aucun hôte n'est associé au paramettre que vous nous avec fournit"
    exit 0
fi

# Vérifie si il existe un bail avec la même ip que celle indiqué dans l'hôte
# donné. Ce control pourrait être fait en amont (au moment de l'ajout d'hôte)
lease=($(lease_db_get_lease ${host[1]}))
if [ ${#lease[@]} -ne 0 ]
then
    echo "Il existe également un bail avec la même ip que votre hote, il existe un conflit"
    echo "Si cette erreur est apparue c'est qu'il existe certainement une incohérence dans"
    echo "votre fichier de configuration dhcpd.conf"
    echo "hote: ${host[@]}"
    echo "lease: ${lease[@]}"
    exit 0
fi

# Vérifie si l'IP associé au nom d'hôte repond
if [ $(get_ip_state ${host[1]}) -eq 0 ]
then
    echo $user\@${host[1]} -p $port
    ssh $user\@${host[1]} -p $port
    exit 0
fi

#Teste de la connexion sur l'ancien bails
host=($(tmp_db_get_tmp $hostname))
if [ ${#host[@]} -eq 0 ] || [ $(get_ip_state ${host[1]}) -ne 0 ]
then
    echo "Il est impossible de se connecter, êtes vous sur que l'hote est actif ?"
else
    echo $user\@${host[1]} -p $port
    ssh $user\@${host[1]} -p $port
    exit 0
fi
