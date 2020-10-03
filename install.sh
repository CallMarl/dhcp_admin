#!/bin/bash

root="$(dirname $(realpath ${BASH_SOURCE[0]}))"

dhcp_admin=/usr/local/sbin/dhcp-admin
omapi_keygen=/usr/local/sbin/omapi-keygen

ln -sf $root/dhcp-admin.sh $dhcp_admin
ln -sf $root/omapi-keygen.sh $omapi_keygen

chown root:root $dhcp_admin $ompapi_keygen
chmod 750 $dhcp_admin $omapi_keygen
