#!/bin/bash

if [ -f /.slaving_started ]; then
	echo "Slave already started!"
	exit 0
fi

if [[ $# -ne 7 ]]; then
	echo "Usage: $0 <dbname> <slaving_username> <slaving_password> <master_db_ip> <bin_file> <bin_position> <db_dump_file>"
	exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &
sleep 5

echo "=> Importing SQL file $7"
mysql -uroot $1 < "$7"



echo "=> Starting Slaving on $4 with $2:$3 at $5:$6"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "CHANGE MASTER TO MASTER_HOST='$4', MASTER_USER='$2', MASTER_PASSWORD='$3', MASTER_LOG_FILE='$5', MASTER_LOG_POS=$6;"
	RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.slaving_started