#!/bin/bash

if [ -f /.slaving_started ]; then
	echo "Slave already started!"
	exit 0
fi

if [[ $# -ne 6 ]]; then
	echo "Usage: $0 <slaving_username> <slaving_password> <master_db_ip> <bin_file> <bin_position> <db_dump_file>"
	exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &
sleep 5

echo "=> Importing SQL file $6"
mysql -uroot  < "$6"



echo "=> Starting Slaving on $3 with $1:$2 at $4:$5"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "CHANGE MASTER TO MASTER_HOST='$3', MASTER_USER='$1', MASTER_PASSWORD='$2', MASTER_LOG_FILE='$4', MASTER_LOG_POS=$5;"
	RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.slaving_started