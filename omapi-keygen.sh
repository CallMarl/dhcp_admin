#!/bin/bash

#Params
public_key_file="omapi_key.pub"
private_key_file="omapi_key.pri"

help()
{
    echo "Usage : $0 [algo] private_key magic_hash"
    echo "available algo:"
    echo "  - hmac_md5"
}

warn1()
{
    echo "Parametter are missing."
    echo ""
    help
    exit 0;
}

warn2()
{
    echo "A key file already exist at this location."
    echo "Please remove them or change the location."
    echo ""
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
    echo "private key : $private_key" > "./$private_key_file"
    echo "magic hash : $magic_hash" >> "./$private_key_file"
    echo "$magic_hash" | openssl dgst -md5 \
        -mac hmac \
        -macopt key:$private_key | cut -d " " -f 2 > $public_key_file
    echo "creating ./key and ./key.pub file"
    cat "$public_key_file"
}

private_key=$2
magic_hash=$3

case "$1" in
    hmac_md5)
        check
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
