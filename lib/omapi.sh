source "$(dirname $BASH_SOURCE[0])/../_env.sh"

connect_message()
{
	CONNECT_MESSAGE="
	server $SC_SERVER
	port $SC_PORT
	key $SC_KEY_NAME $SC_KEY
	connect"
	echo "$CONNECT_MESSAGE"
}

#omapi_check_connect()
#{
#	response=`cat <<- EOF | omshell
#	$(connect_message)
#	close
#	EOF
#	`
	#echo $response
#	if [ ! -z $(echo "$response" | grep "not connected") ]
#	then
#		echo "0"
#	fi
#	echo "1"
#}

# $# 1
# $1 script omshell
set_query()
{
	response=`cat <<- EOF | omshell
	$(connect_message)
	$1
	EOF
	`
	echo "$response"
}

# $# 3
# $1 addresse MAC
# $2 addresse ip
# $3 nom d'hote
omapi_add_host()
{
	message="
	new host
	set name = \"$3\"
	set hardware-address = $1
	set hardware-type = 00:00:00:01
	set ip-address = $2
	create
	"
	response=$(set_query "$message")
	echo "$response"
}

# $# 1
# $1 addresse MAC
omapi_remove_host()
{
	message="
	new host
	set hardware-address = $1
	open
	remove
	"
	response=$(set_query "$message")
	echo "$response"
}

# $# 1
# $1 addresse MAC
omapi_turn_off_lease()
{
	message="
	new lease
	set hardware-address = $1
	open
	set ends = 00:00:00:01
	update
	"
	response=$(set_query "$message")
	echo "$response"
}
