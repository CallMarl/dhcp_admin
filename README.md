# DHCP ADMIN

This tool allows you to dynamically manage DHCP leases and hosts for
the [isc-dhcp-server](https://github.com/isc-projects/dhcp) server. This tools is based on `dhcp-lease-list` command line.

This tool also use OMAPI protocole to dynamically inetract with the isc-dhcp-server.

## Install

Clone this repository in `/usr/local/src` then run from the folder `install.sh`
script. You can now run `dhcp-admin`. Help message should appear.

If command not run :
* Make sur your have the admin privileges.
* Make sur `/usr/local/sbin` is in your environnement $PATH variable.  

#### Requirement

To work this tools need OMAPI service activate on your isc-dhcp-server. To activate
it insert those rules in the `/etc/dhcp/dhcpd.conf` file :

```
# List of available OMAPI key
# First key :
key my_key_name {
	algorithm hmac-md5;
	secret 0a0c4a3979592d1561582cf98a912c8f;
}

# Setup OMAPI servie
omapi-port 5000;            # Wich port OMAPI will bind.
omapi-key my_key_name;      # Key used by OMAPI service.
```

To generate key dhcp-admin give you à little script named `omapi_keygen`.

### Configure

During first use run `dhcp-admin init` to setup OMAPI connection.

## Usage

##### Full install process :

 - 1 generate hash with `omapi_keygen`

```
omapi-keygen hmac_md5 dhcp_admin_demo my_super_salt
creating ./omapi_key.pri and ./omapi_key.pub file
0a0c4a3979592d1561582cf98a912c8f
```

- 2 edit `dhcpd.conf`

```
key dhcp_admin {
        algorithm hmac-md5;
        secret 0a0c4a3979592d1561582cf98a912c8f;
}

# Setup OMAPI servie
omapi-port 5000;           # Wich port OMAPI will bind.
omapi-key dhcp_admin;      # Key used by OMAPI service.
```

- 3 restart service

```
root@cl1-routeur /etc/dhcp # service isc-dhcp-server restart && service isc-dhcp-server status
● isc-dhcp-server.service - LSB: DHCP server
   Loaded: loaded (/etc/init.d/isc-dhcp-server; generated)
   Active: active (running) since Sun 2020-10-04 12:31:43 CEST; 25ms ago
     Docs: man:systemd-sysv-generator(8)
  Process: 6679 ExecStart=/etc/init.d/isc-dhcp-server start (code=exited, status=0/SUCCESS)
    Tasks: 1 (limit: 1044)
   Memory: 4.8M
   CGroup: /system.slice/isc-dhcp-server.service
           └─6691 /usr/sbin/dhcpd -4 -q -cf /etc/dhcp/dhcpd.conf eth1
```

- 4 verify omapi port

```
root@cl1-routeur /etc/dhcp # netstat -tunlp | grep dhcpd
tcp        0      0 0.0.0.0:5000            0.0.0.0:*               LISTEN      6691/dhcpd
udp        0      0 0.0.0.0:67              0.0.0.0:*                           6691/dhcpd
```

- 5 init your dhcp-admin tool

```
root@cl1-routeur /etc/dhcp # dhcp-admin init 127.0.0.1 5000 dhcp_admin 0a0c4a3979592d1561582cf98a912c8f
Make sur parametters are correct.
dhcp-admin doesn't implement any control.
```

*Tool in now ready !*

##### Create static host dynamically :

- 1 display lease

```
root@cl1-routeur /etc/dhcp # dhcp-admin show
HOST LIST :

TMP LIST :

LEASE LIST :
00:15:5d:01:65:07 192.168.1.50 cl1-webserver
00:15:5d:01:65:0a 192.168.1.52 cl1-docker
00:15:5d:01:65:0c 192.168.1.54 cl1-cli
```

- 2 select the lease you want to set static

```
root@cl1-routeur /etc/dhcp # dhcp-admin add -k cl1-webserver 192.168.1.2
...
omapi command interaction will be display
...
```

- 3 display new host

```
root@cl1-routeur /etc/dhcp # dhcp-admin show
HOST LIST :
00:15:5d:01:65:07 192.168.1.2 cl1-webserver

TMP LIST :
00:15:5d:01:65:07 192.168.1.50 cl1-webserver

LEASE LIST :
00:15:5d:01:65:0a 192.168.1.52 cl1-docker
00:15:5d:01:65:0c 192.168.1.54 cl1-cli
```

- 4 effective check with dhcp-lease-list

```
root@cl1-routeur /etc/dhcp # dhcp-lease-list
MAC                IP              hostname       valid until         manufacturer
===============================================================================================
00:15:5d:01:65:07  192.168.1.50    cl1-webserver  2020-10-04 10:53:54 -NA-
00:15:5d:01:65:0a  192.168.1.52    cl1-docker     2020-10-04 10:53:46 -NA-
00:15:5d:01:65:0c  192.168.1.54    cl1-cli        2020-10-04 10:58:48 -NA-
```

*Here we can see the dhcp old lease for cl1-webserver is active.*

- 5 new effective affter cl1-webserver reboot

```
root@cl1-routeur /etc/dhcp # dhcp-lease-list
Reading leases from /var/lib/dhcp/dhcpd.leases
MAC                IP              hostname       valid until         manufacturer
===============================================================================================
00:15:5d:01:65:0a  192.168.1.52    cl1-docker     2020-10-04 11:02:27 -NA-
00:15:5d:01:65:0c  192.168.1.54    cl1-cli        2020-10-04 11:02:55 -NA-
```
*Here we can see the dhcp lease cl1-webserver doesn't appear any more.*

- 6 The cl1-webserver has now 192.168.1.2 ip address

```
root@cl1-webserver /home/user # ip a | grep eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    inet 192.168.1.2/24 brd 192.168.1.254 scope global dynamic eth0
```

__|!|__ ***Please very	important!*** \
 Take a look of what are each `*.db`. Those files are displayed by `dchp-admin show` command line. The ip address from `tmp.db` are actually not auto-removed by the `dhcp-admin` command when you are sure about the new static lease is effective please remove the old lease manualy `/usr/local/src/file/tmp.db` files. If you don't do it this will potential cause some bug with dynamic lease with the same ip as thoses ip displayed in the tmp.db file. 

- 7 check after manualy update

```
root@cl1-routeur /usr/local/src/dhcp_admin/file (git)-[main] # dhcp-admin show
HOST LIST :
00:15:5d:01:65:07 192.168.1.2 cl1-webserver

TMP LIST :

LEASE LIST :
00:15:5d:01:65:0a 192.168.1.52 cl1-docker
00:15:5d:01:65:0c 192.168.1.54 cl1-cli
```

## Misc
###### Files .db

The ``* .db`` files are utility files that allow you to keep a
trace on hosts and leases without having to analyze the file ``/var/lib/dhcp3/dhcpd.leases``.

- The `host.db` file list all the configured host. \
__|!|__ Configured host do not significate active hote. The activation duration will depend of the previous lease expiration date.

- The `lease.db` file list all the actifs lease without very newest static configuration.

- the `tmp.db` file lists all the ip and mac addresses of the old lease
which has not yet been converted to static. \
(Static host is configured but the new lease is not active)
---
###### Line up

In folder exemple there is some files named `line up` those files are exemples about how it is possible to use function to create small process exection. Lot of comment are inside they explain each row.
