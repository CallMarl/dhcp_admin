#!/bin/sh

#Params
public_key_file="key.pub"
private_key_file="key"

help()
{
    echo "Usage: $0"
    echo "[algo] private_key magic_hash"
    echo "algo:"
    echo "  - hmac_md5"
    echo "  - hmac_sha256"
}

warn1()
{
    echo "Parametter are missing."
    help
    exit 0;
}

warn2()
{
    echo "A key file already exist at this location."
    echo "You're able to change public key file name by editing this script params,"
    echo "or change your directory."
    help
    exit 0
}

check()
{
    if [ -z $private_key ] || [ -z $magic_hash ]
    then
        warn1
    fi;
    if [ -f "./$public_key_file" ] || [ -f "./key" ]
    then
        warn2
    fi
}

hmac_md5()
{
    echo $1 > "./$private_key_file"
    echo "$magic_hash" | openssl dgst -sha256 \
        -mac hmac \
        -macopt key:$private_key \
        -out $public_key_file
}

private_key = $2
magic_hash = $3
check

case "$1" in
    hmac_md5)
        hmac_md5
        ;;
    help)
        help
        ;;
	*)
        help
        exit 0
		;;
esac
exit 0
