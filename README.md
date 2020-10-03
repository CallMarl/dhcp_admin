# Outil d'administration DHCP

Cette outil permet d'administrer les bails et les hotes DHCP dynamiquement pour
le serveur isc-dhcp-serveur. L'intégralité de l'outil est basé sur la commande
dhcp-lease-list.

Il implement notament des consigne pour le protocole OMAPI, et est restraint par
les restriction imposer par le serveur isc-dhcp-server.

### Les fichier .db

les fichier ``*.db`` sont des fichier utilitaire qui permette de garder une
tace sur les hotes, les baux sans avoir à parser le fichier ``/var/lib/dhcp3/dhcpd.leases``.
En effet l'outil est basé uniquement sur la commande isc-dhcp-server.

- le fichier host.db list l'ensemble des hotes configurer.
/!\\ un hotes configurer ne signifie pas que cette hotes est encore actifs.
(cf: restriction de isc-dhcp-server)

- le fichier lease.db list l'ensemble des baux actifs. A la différence de
isc-dhcp-server la liste ne référence pas les baux qui ont été exploité pour
créer un hote statique.

- le fichier tmp.db list l'ensemble des ip et address mac des ancien bail
qui on été converti en host static. Ceci est obligatoire car le serveur
isc-dhcp ne supporte pas la feature FORCERENEW comme indiqué dans la RFC3203
