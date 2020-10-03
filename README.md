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

comming soon

## Misc
---
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
### Line up

In folder exemple there is some files named `line up` those files are exemples about how it is possible to use function to create small process exection. Lot of comment are inside they explain each row.
