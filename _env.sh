#!/bin/bash

SC_ROOT="$(dirname $(realpath ${BASH_SOURCE[0]}))"
SC_FILE="$SC_ROOT/file"
SC_LIB="$SC_ROOT/lib"
SC_EXEMPLE="$SC_ROOT/exemple"

SC_HOST_FILE="$SC_FILE/host.db"
SC_LEASE_FILE="$SC_FILE/lease.db"
SC_TMP_FILE="$SC_FILE/tmp.db"
SC_TOOLS="$SC_ROOT/tools"
