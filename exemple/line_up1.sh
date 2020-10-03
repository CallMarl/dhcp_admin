#!/bin/bash
# Cette line up à pour objectif d'attibué 2 ip statique en fonction de nom d'hotes
source "$(dirname $BASH_SOURCE[0])/../_env.sh"
source $SC_EXEMPLE/baseline.sh

# Dans cette line up on souhaite définir 2 hotes statiquement.

# Ces ligne correspondent à 2 nom d'hotes connue
hostname_1="Firewall-1"

# Ces lignes correspondent au address ip statique que l'on souhaite leur
# attribuer.

ip_1="192.168.1.5"

# Cela signifie que 2 ou + d'ip seront présent dans le fichier lease db après
# execution de cette commande.
lease_init_db 1

# Récupère le lease associé au nom d'hôte.
# lease est un tableau avec
# ${lease[0]} MAC
# ${lease[1]} IP
# ${lease[2]} HOSTNAME
lease=($(lease_db_get_lease $hostname_1))

# Créer l'hote statique
# Transforme le bail en hote
# Transforme le bail en hote avec des spécificité
lease=($(lease_db_get_lease $ip_1))
if [ ${#lease[@]} -ne 0 ]
then
    echo "Il existe déjà un bail avec cette IP"
    echo "lease: ${lease[@]}"
    exit 0
fi
host_db_add ${lease[0]} $ip_1 ${lease[2]}

# Port le bail dhcp à expiration
lease_turn_off_lease ${lease[0]}
