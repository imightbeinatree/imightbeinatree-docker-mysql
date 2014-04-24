#!/bin/bash

if [ -f /.db_created ]; then
	echo "Database already created!"
	exit 0
fi


if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <db_name>"
	exit 1
fi

/start_mysql.sh

echo "=> Creating database $1"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "CREATE DATABASE $1"
	RET=$?
done

/stop_mysql.sh

echo "=> Done!"
touch /.db_created