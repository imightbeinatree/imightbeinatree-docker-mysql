#!/bin/bash

if [ -f /.slaving_started ]; then
	echo "Slave already started!"
	exit 0
fi

if [[ $# -ne 5 ]]; then
	echo "Usage: $0 <slaving_username> <slaving_password> <master_db_ip> <bin_file> <bin_position>"
	exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Starting Slaving on $master_db_ip with $slaving_username:$slaving_password at $bin_file:$bin_position"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "CHANGE MASTER TO MASTER_HOST='$master_db_ip', MASTER_USER='$slaving_username', MASTER_PASSWORD='$slaving_password', MASTER_LOG_FILE='$bin_file', MASTER_LOG_POS=$bin_position;"
	RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.slaving_started






